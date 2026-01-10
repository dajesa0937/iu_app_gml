import 'package:flutter/material.dart';
import '../../../core/auth/session_guard.dart';
import '../../../core/ui/empty_state.dart';
import '../../../core/ui/error_state.dart';
import '../../../core/ui/loading_view.dart';
import '../../../core/auth/role_helper.dart';

import '../../products/domain/product_model.dart';
import '../../products/data/product_service.dart';
import '../../products/presentation/product_card.dart';
import '../../products/presentation/create_product_page.dart';

// 🛒 IMPORT DEL CARRITO
import '../../cart/presentation/cart_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ProductService _service = ProductService();

  late Future<List<Product>> _productsFuture;
  late Future<bool> _isAdminFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _productsFuture = _service.getProducts();
    _isAdminFuture = RoleHelper.isAdmin();
  }

  Future<void> _reloadProducts() async {
    setState(() {
      _productsFuture = _service.getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos GML'),
        actions: [
          // 🛒 BOTÓN DEL CARRITO (CLIENTE)
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CartPage(),
                ),
              );
            },
          ),

          // ➕ BOTÓN CREAR PRODUCTO (SOLO ADMIN)
          FutureBuilder<bool>(
            future: _isAdminFuture,
            builder: (_, snapshot) {
              if (snapshot.data == true) {
                return IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    final created = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateProductPage(),
                      ),
                    );

                    if (created == true) {
                      await _reloadProducts();
                    }
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          // ⏳ Cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView(
              message: 'Cargando productos...',
            );
          }

          // ❌ Error
          if (snapshot.hasError) {
            final error = snapshot.error.toString();

            if (error.contains('SESSION_EXPIRED')) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                SessionGuard.handleSessionExpired(context);
              });

              return const EmptyState(
                icon: Icons.lock_outline,
                title: 'Sesión expirada',
                subtitle: 'Vuelve a iniciar sesión',
              );
            }

            if (error.contains('FORBIDDEN')) {
              return const EmptyState(
                icon: Icons.block,
                title: 'Acceso denegado',
                subtitle: 'No tienes permisos para esta acción',
              );
            }

            return ErrorState(
              message: 'Error al cargar productos',
              onRetry: _reloadProducts,
            );
          }

          // 📦 Datos
          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return const EmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'Sin productos',
              subtitle: 'No hay productos registrados',
            );
          }

          // ✅ Lista de productos
          return FutureBuilder<bool>(
            future: _isAdminFuture,
            builder: (_, adminSnapshot) {
              final isAdmin = adminSnapshot.data ?? false;

              return RefreshIndicator(
                onRefresh: _reloadProducts,
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (_, i) {
                    return ProductCard(
                      product: products[i],
                      isAdmin: isAdmin,
                      onRefresh: _reloadProducts,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
