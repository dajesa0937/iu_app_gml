import 'package:flutter/material.dart';
import '../../products/domain/product_model.dart';
import '../../products/data/product_service.dart';
import '../../products/presentation/create_product_page.dart';
import '../../../core/auth/role_helper.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ProductService _service = ProductService();
  late Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    _products = _service.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos GML'),
        actions: [
          FutureBuilder<bool>(
            future: RoleHelper.isAdmin(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox.shrink();
              }

              if (snapshot.data == true) {
                return IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateProductPage(),
                      ),
                    ).then((_) {
                      setState(() {
                        _products = _service.getProducts();
                      });
                    });
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error al cargar productos'),
            );
          }

          final products = snapshot.data;

          if (products == null || products.isEmpty) {
            return const Center(
              child: Text('No hay productos disponibles'),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  title: Text(product.name),
                  subtitle: Text(product.description),
                  trailing: Text(
                    '\$${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
