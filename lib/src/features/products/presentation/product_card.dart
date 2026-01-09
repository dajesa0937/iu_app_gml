import 'package:flutter/material.dart';
import '../domain/product_model.dart';
import '../data/product_service.dart';
import 'edit_product_page.dart';
import '../../../core/ui/ui_feedback.dart';
import '../../../core/ui/confirm_dialog.dart';

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
    final bool hasStock = product.stock > 0;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Nombre
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            /// Categoría
            Text(
              product.category,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 8),

            /// Descripción
            Text(
              product.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),

            const SizedBox(height: 12),

            /// Precio + stock
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatPrice(product.price),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: hasStock
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    hasStock ? 'Stock: ${product.stock}' : 'Agotado',
                    style: TextStyle(
                      fontSize: 12,
                      color: hasStock ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            /// Acciones ADMIN
            if (isAdmin) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EditProductPage(product: product),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _confirmDelete(context, product.id);
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Confirmación + borrado
  Future<void> _confirmDelete(BuildContext context, String id) async {
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: 'Eliminar producto',
      message: '¿Seguro que deseas eliminar este producto?',
      confirmText: 'Eliminar',
    );

    if (!confirmed) return;

    try {
      await ProductService().deleteProduct(id);
      UIFeedback.success(context, 'Producto eliminado');
    } catch (_) {
      UIFeedback.error(context, 'Error al eliminar el producto');
    }
  }

  String _formatPrice(double price) {
    return '\$ ${price.toStringAsFixed(0)}';
  }
}
