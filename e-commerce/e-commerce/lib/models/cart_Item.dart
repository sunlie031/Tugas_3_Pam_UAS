import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  Map<String, dynamic> toMap() {
    return {'product': product.toMap(), 'quantity': quantity};
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: Product.fromMap(map['product']),
      quantity: map['quantity'],
    );
  }
}
