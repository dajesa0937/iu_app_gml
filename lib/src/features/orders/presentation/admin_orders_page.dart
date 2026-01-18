import 'package:flutter/material.dart';
import '../data/order_service.dart';
import '../domain/order_model.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  final OrderService _service = OrderService();
  late Future<List<Order>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _service.getAllOrders();
  }

  Future<void> _reload() async {
    setState(() {
      _ordersFuture = _service.getAllOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos (Admin)')),
      body: FutureBuilder<List<Order>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error cargando pedidos'));
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return const Center(child: Text('No hay pedidos'));
          }

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (_, i) {
                final order = orders[i];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('Pedido #${order.id.substring(0, 6)}'),
                    subtitle: Text(
                      'Total: \$${order.total.toStringAsFixed(0)}\nEstado: ${order.status}',
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        await _service.updateStatus(order.id, value);
                        _reload();
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'pending', child: Text('Pendiente')),
                        PopupMenuItem(value: 'confirmed', child: Text('Confirmado')),
                        PopupMenuItem(value: 'delivered', child: Text('Entregado')),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
