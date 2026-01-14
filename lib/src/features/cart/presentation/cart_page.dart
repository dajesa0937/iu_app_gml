import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/ui/empty_state.dart';
import '../../../core/ui/ui_feedback.dart';
import '../data/cart_service.dart';
import '../data/order_service.dart';
import '../domain/cart_item.dart';

const String gmlWhatsAppNumber = '573108394870';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cart = CartService();

  String _buildWhatsAppMessage(List<CartItem> items, String orderId) {
    double total = 0;
    final buffer = StringBuffer();

    buffer.writeln('Hola 👋');
    buffer.writeln('Pedido *GML*');
    buffer.writeln('🧾 Pedido N°: *$orderId*\n');

    for (final item in items) {
      final subtotal = item.subtotal;
      total += subtotal;

      buffer.writeln(
        '- ${item.product.name} x${item.quantity} → \$${subtotal.toStringAsFixed(0)}',
      );
    }

    buffer.writeln('\n💰 Total: \$${total.toStringAsFixed(0)}');
    buffer.writeln('\nGracias.');

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final items = _cart.items;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi carrito')),
      body: items.isEmpty
          ? const EmptyState(
        icon: Icons.shopping_cart_outlined,
        title: 'Carrito vacío',
        subtitle: 'Agrega productos para continuar',
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, i) {
                final item = items[i];

                return ListTile(
                  title: Text(item.product.name),
                  subtitle: Text(
                    'Cantidad: ${item.quantity} · \$${item.subtotal.toStringAsFixed(0)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            _cart.decrease(item.product);
                          });
                        },
                      ),
                      Text(
                        item.quantity.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _cart.increase(item.product);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: const Border(
                top: BorderSide(color: Colors.black12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Total: \$${_cart.total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    if (_cart.items.isEmpty) {
                      UIFeedback.error(
                        context,
                        'El carrito está vacío',
                      );
                      return;
                    }

                    try {
                      final orderService = OrderService();

                      // 1️⃣ Crear pedido en backend
                      final orderId =
                      await orderService.createOrder(_cart.items);

                      // 2️⃣ Construir mensaje WhatsApp
                      final message = Uri.encodeComponent(
                        _buildWhatsAppMessage(_cart.items, orderId),
                      );

                      final url = Uri.parse(
                        'https://wa.me/$gmlWhatsAppNumber?text=$message',
                      );

                      // 3️⃣ Limpiar carrito
                      _cart.clear();
                      setState(() {});

                      // 4️⃣ Abrir WhatsApp
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    } catch (e) {
                      UIFeedback.error(
                        context,
                        'Error al confirmar pedido',
                      );
                    }
                  },
                  child: const Text('Confirmar pedido'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
