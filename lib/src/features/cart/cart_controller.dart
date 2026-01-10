import 'domain/cart_item.dart';
import '../products/domain/product_model.dart';

class CartController {
  static final CartController _instance = CartController._internal();
  factory CartController() => _instance;
  CartController._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addProduct(Product product) {
    final index = _items.indexWhere(
          (item) => item.product.id == product.id,
    );

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
  }

  void removeProduct(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
  }

  double get total =>
      _items.fold(0, (sum, item) => sum + item.subtotal);

  void clear() => _items.clear();

  bool get isEmpty => _items.isEmpty;
}
