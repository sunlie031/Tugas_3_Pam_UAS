class Product {
  final String id;
  final String name;
  final double price;
  int stock;
  final double rating;
  int sales;
  final String description;
  final String image;
  final List<String> subImage;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.rating,
    required this.sales,
    required this.description,
    required this.image,
    required this.subImage,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'price': price,
    "stock": stock,
    "rating": rating,
    "sales": sales,
    'description': description,
    "image": image,
    "subImage": subImage,
  };

  factory Product.fromMap(Map<String, dynamic> map) => Product(
    id: map['id'],
    name: map['name'],
    price: (map['price'] as num).toDouble(),
    stock: map["stock"],
    rating: map["rating"],
    sales: map["sales"],
    description: map['description'],
    image: map["image"],
    subImage: List<String>.from(map["subImage"] ?? []),
  );
}

final List<Product> dummyProducts = [
  Product(
    id: '1',
    name: 'Kaos Polos',
    price: 50000,
    stock: 20,
    rating: 4.3,
    sales: 120,
    description: 'Kaos polos berbahan katun premium yang lembut dan adem...',
    image: 'asset/baju1.webp',
    subImage: [
      'asset/baju1.webp',
      'asset/baju2.jpg',
      'asset/baju3.jpg',
      'asset/baju4.jpg',
    ],
  ),
  Product(
    id: '2',
    name: 'Celana Jeans',
    price: 120000,
    stock: 15,
    rating: 4.5,
    sales: 69,
    description: 'Celana jeans biru slim fit dengan bahan denim...',
    image: 'asset/celana1.jpg',
    subImage: [
      'asset/celana1.jpg',
      'asset/celana2.webp',
      'asset/celana3.webp',
      'asset/celana4.jpg',
    ],
  ),
  Product(
    id: '3',
    name: 'Jaket Hoodie',
    price: 150000,
    stock: 10,
    rating: 4.6,
    sales: 86,
    description: 'Jaket hoodie berbahan fleece tebal yang hangat...',
    image: 'asset/jaket1.webp',
    subImage: [
      'asset/jaket1.webp',
      'asset/jaket2.jpg',
      'asset/jaket3.jpg',
      'asset/jaket4.jpg',
    ],
  ),
  Product(
    id: '4',
    name: 'Sepatu Sneakers',
    price: 250000,
    stock: 8,
    rating: 4.7,
    sales: 31,
    description: 'Sneakers ringan dengan sol empuk dan bahan breathable...',
    image: 'asset/sepatu1.webp',
    subImage: [
      'asset/sepatu1.webp',
      'asset/sepatu2.webp',
      'asset/sepatu3.webp',
      'asset/sepatu4.webp',
    ],
  ),
  Product(
    id: '5',
    name: 'Topi Unisex',
    price: 35000,
    stock: 30,
    rating: 4.4,
    sales: 100,
    description: 'Topi kasual unisex berbahan katun twill...',
    image: 'asset/topi1.webp',
    subImage: [
      'asset/topi1.webp',
      'asset/topi2.webp',
      'asset/topi3.webp',
      'asset/topi4.webp',
    ],
  ),
  Product(
    id: '6',
    name: 'Kemeja Flanel',
    price: 100000,
    stock: 12,
    rating: 4.1,
    sales: 45,
    description: 'Kemeja flanel pria dengan motif kotak-kotak klasik...',
    image: 'asset/kemeja1.webp',
    subImage: [
      'asset/kemeja1.webp',
      'asset/kemeja2.webp',
      'asset/kemeja3.webp',
      'asset/kemeja4.webp',
    ],
  ),
  Product(
    id: '7',
    name: 'Jam Tangan',
    price: 180000,
    stock: 6,
    rating: 4.9,
    sales: 25,
    description: 'Jam tangan analog modern dengan fitur tambahan...',
    image: 'asset/jam1.webp',
    subImage: [
      'asset/jam1.webp',
      'asset/jam2.webp',
      'asset/jam3.webp',
      'asset/jam4.webp',
    ],
  ),
  Product(
    id: '8',
    name: 'Tas Ransel',
    price: 200000,
    stock: 9,
    rating: 4.0,
    sales: 78,
    description: 'Tas ransel berkapasitas besar dengan banyak kompartemen...',
    image: 'asset/tas1.webp',
    subImage: [
      'asset/tas1.webp',
      'asset/tas2.webp',
      'asset/tas3.webp',
      'asset/tas4.webp',
    ],
  ),
];
