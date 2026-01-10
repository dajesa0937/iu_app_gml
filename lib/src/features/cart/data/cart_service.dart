import '../domain/cart_item.dart';
import '../../products/domain/product_model.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addProduct(Product product) {
    final index =
    _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
  }

  void increase(Product product) {
    final item =
    _items.firstWhere((e) => e.product.id == product.id);
    item.quantity++;
  }

  void decrease(Product product) {
    final index =
    _items.indexWhere((e) => e.product.id == product.id);

    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
    }
  }

  void removeProduct(Product product) {
    _items.removeWhere((e) => e.product.id == product.id);
  }

  double get total =>
      _items.fold(0, (sum, item) => sum + item.subtotal);

  void clear() {
    _items.clear();
  }
}
