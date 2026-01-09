import 'package:flutter/material.dart';
import '../domain/product_model.dart';
import '../data/product_service.dart';
import '../../../core/ui/ui_feedback.dart';

class EditProductPage extends StatefulWidget {
  final Product product;

  const EditProductPage({
  super.key,
  required this.product,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final ProductService _service = ProductService();

  late TextEditingController _name;
  late TextEditingController _description;
  late TextEditingController _price;
  late TextEditingController _stock;
  late TextEditingController _category;

  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.product.name);
    _description = TextEditingController(text: widget.product.description);
    _price = TextEditingController(text: widget.product.price.toString());
    _stock = TextEditingController(text: widget.product.stock.toString());
    _category = TextEditingController(text: widget.product.category);
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _price.dispose();
    _stock.dispose();
    _category.dispose();
    super.dispose();
  }

  Future<void> _updateProduct() async {
    if (isUpdating) return;

    FocusScope.of(context).unfocus();

    if (_name.text.trim().isEmpty ||
        _price.text.trim().isEmpty ||
        _stock.text.trim().isEmpty) {
      UIFeedback.error(context, 'Completa todos los campos obligatorios');
      return;
    }

    final price = double.tryParse(_price.text);
    final stock = int.tryParse(_stock.text);

    if (price == null || stock == null || stock < 0) {
      UIFeedback.error(context, 'Precio o stock inválido');
      return;
    }

    setState(() => isUpdating = true);

    try {
      await _service.updateProduct(
        id: widget.product.id,
        name: _name.text.trim(),
        description: _description.text.trim(),
        price: price,
        stock: stock,
        category: _category.text.trim(),
      );

      if (!mounted) return;

      UIFeedback.success(context, 'Producto actualizado correctamente');
      Navigator.pop(context, true); // 🔑 devuelve resultado al padre
    } catch (_) {
      if (!mounted) return;
      UIFeedback.error(context, 'Error al actualizar el producto');
    } finally {
      if (mounted) {
        setState(() => isUpdating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar producto')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _field(_name, 'Nombre'),
          _field(_description, 'Descripción'),
          _field(
            _price,
            'Precio',
            const TextInputType.numberWithOptions(decimal: true),
          ),
          _field(_stock, 'Stock', TextInputType.number),
          _field(_category, 'Categoría'),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isUpdating ? null : _updateProduct,
              child: isUpdating
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Text('Guardar cambios'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
      TextEditingController controller,
      String label, [
        TextInputType type = TextInputType.text,
      ]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: type,
        enabled: !isUpdating,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ).copyWith(labelText: label),
      ),
    );
  }
}
