import 'package:flutter/material.dart';
import '../../cart/data/cart_service.dart';
import '../../../core/ui/ui_feedback.dart';
import '../domain/product_model.dart';
import '../data/product_service.dart';
import 'edit_product_page.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isAdmin;
  final VoidCallback onRefresh;

  const ProductCard({
  super.key,
  required this.product,
  required this.isAdmin,
  required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final cart = CartService();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text('\$ ${product.price.toStringAsFixed(0)}'),

            const SizedBox(height: 12),

            // 👤 CLIENTE → AGREGAR AL CARRITO
            if (!isAdmin)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Agregar al carrito'),
                  onPressed: () {
                    cart.addProduct(product);
                    UIFeedback.success(context, 'Producto agregado');
                  },
                ),
              ),

            // 👑 ADMIN → EDITAR / ELIMINAR
            if (isAdmin)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EditProductPage(product: product),
                        ),
                      );

                      if (updated == true) {
                        onRefresh();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _confirmDelete(context);
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: const Text(
          '¿Seguro que deseas eliminar este producto?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ProductService().deleteProduct(product.id);
        UIFeedback.success(context, 'Producto eliminado');
        onRefresh();
      } catch (_) {
        UIFeedback.error(context, 'Error al eliminar el producto');
      }
    }
  }
}
