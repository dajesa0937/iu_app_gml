import 'package:flutter/material.dart';
import '../data/product_service.dart';
import '../../../core/ui/ui_feedback.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final ProductService _service = ProductService();

  final _name = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _stock = TextEditingController();
  final _category = TextEditingController();

  bool isSaving = false;

  Future<void> _createProduct() async {
    if (isSaving) return;

    setState(() => isSaving = true);

    try {
      await _service.createProduct(
        name: _name.text,
        description: _description.text,
        price: double.parse(_price.text),
        stock: int.parse(_stock.text),
        category: _category.text,
      );

      if (!mounted) return;

      UIFeedback.success(context, 'Producto creado correctamente');
      Navigator.pop(context, true); // ← IMPORTANTE

    } catch (_) {
      if (!mounted) return;
      UIFeedback.error(context, 'Error al crear producto');
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear producto')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _field(_name, 'Nombre'),
          _field(_description, 'Descripción'),
          _field(_price, 'Precio', TextInputType.number),
          _field(_stock, 'Stock', TextInputType.number),
          _field(_category, 'Categoría'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isSaving ? null : _createProduct,
            child: isSaving
                ? const CircularProgressIndicator(strokeWidth: 2)
                : const Text('Crear producto'),
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
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
