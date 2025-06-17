// models/checkout_item.dart

class CheckoutItem {
  final String productId;
  final String productName;
  final double productPrice;
  final int quantity;
  final String productImage;

  CheckoutItem({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.productImage,
  });

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'productName': productName,
    'productPrice': productPrice,
    'quantity': quantity,
    'productImage': productImage,
  };

  factory CheckoutItem.fromJson(Map<String, dynamic> json) => CheckoutItem(
    productId: json['productId'],
    productName: json['productName'],
    productPrice: (json['productPrice'] as num).toDouble(),
    quantity: json['quantity'],
    productImage: json['productImage'],
  );
}

class Checkout {
  final List<CheckoutItem> items;
  final DateTime timestamp;

  Checkout({required this.items, required this.timestamp});

  factory Checkout.fromJson(Map<String, dynamic> json) {
    return Checkout(
      items:
          (json['items'] as List)
              .map((item) => CheckoutItem.fromJson(item))
              .toList(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items.map((item) => item.toJson()).toList(),
    'timestamp': timestamp.toIso8601String(),
  };
}
