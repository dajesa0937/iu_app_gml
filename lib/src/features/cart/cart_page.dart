import 'package:flutter/material.dart';
import 'cart_controller.dart';
import '../../core/ui/ui_feedback.dart';
import 'package:url_launcher/url_launcher.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartController();

    return Scaffold(
      appBar: AppBar(title: const Text('Carrito')),
      body: cart.isEmpty
          ? const Center(child: Text('Carrito vacío'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (_, i) {
                final item = cart.items[i];
                return ListTile(
                  title: Text(item.product.name),
                  subtitle: Text(
                    'Cantidad: ${item.quantity}',
                  ),
                  trailing: Text(
                    '\$${item.subtotal.toStringAsFixed(0)}',
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Total: \$${cart.total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () =>
                      _sendToWhatsApp(context, cart),
                  child: const Text('Confirmar pedido'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendToWhatsApp(
      BuildContext context,
      CartController cart,
      ) async {
    final phone = '573108394870'; // WhatsApp Business GML
    final message = _buildMessage(cart);

    final url = Uri.parse(
      'https://wa.me/$phone?text=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
      cart.clear();
    } else {
      UIFeedback.error(context, 'No se pudo abrir WhatsApp');
    }
  }

  String _buildMessage(CartController cart) {
    final buffer = StringBuffer();
    buffer.writeln('🛒 *Pedido GML*');
    buffer.writeln('');

    for (final item in cart.items) {
      buffer.writeln(
        '- ${item.product.name} x${item.quantity} '
            '(\$${item.subtotal.toStringAsFixed(0)})',
      );
    }

    buffer.writeln('');
    buffer.writeln(
      '💰 Total: \$${cart.total.toStringAsFixed(0)}',
    );

    return buffer.toString();
  }
}
