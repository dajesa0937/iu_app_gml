import '../../products/domain/product_model.dart';
import '../domain/cart_item.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // ➕ Agregar producto
  void addProduct(Product product) {
    final index = _items.indexWhere(
          (item) => item.product.id == product.id,
    );

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product, quantity: 1));
    }
  }

  // ➕ Aumentar cantidad
  void increase(Product product) {
    final index = _items.indexWhere(
          (item) => item.product.id == product.id,
    );

    if (index >= 0) {
      _items[index].quantity++;
    }
  }

  // ➖ Disminuir cantidad
  void decrease(Product product) {
    final index = _items.indexWhere(
          (item) => item.product.id == product.id,
    );

    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
    }
  }

  // ❌ Eliminar producto
  void removeProduct(Product product) {
    _items.removeWhere(
          (item) => item.product.id == product.id,
    );
  }

  // 🧹 Vaciar carrito
  void clear() {
    _items.clear();
  }

  // 💰 Total
  double get total {
    return _items.fold(
      0,
          (sum, item) => sum + item.subtotal,
    );
  }
}
