import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  Map<String, dynamic> toMap() => {
    'product': product.toMap(),
    'quantity': quantity,
  };

  factory CartItem.fromMap(Map<String, dynamic> map) => CartItem(
    product: Product.fromMap(map['product']),
    quantity: map['quantity'],
  );
}
