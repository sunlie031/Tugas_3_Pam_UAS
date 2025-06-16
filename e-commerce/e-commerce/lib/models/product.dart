class Product {
  final String id;
  final String name;
  final double price;
  int stock;
  final String description;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.description,
    required this.image,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'price': price,
    "stock": stock,
    'description': description,
    "image": image,
  };

  factory Product.fromMap(Map<String, dynamic> map) => Product(
    id: map['id'],
    name: map['name'],
    price: (map['price'] as num).toDouble(),
    stock: map["stock"],
    description: map['description'],
    image: map["image"],
  );
}

final List<Product> dummyProducts = [
  Product(
    id: '1',
    name: 'Kaos Polos',
    price: 50000,
    stock: 20,
    description: 'Kaos katun nyaman dipakai sehari-hari.',
    image:
        'https://down-id.img.susercontent.com/file/id-11134207-7r992-lxbemuqxv7z25a.webp',
  ),
  Product(
    id: '2',
    name: 'Celana Jeans',
    stock: 15,
    price: 120000,
    description: 'Celana jeans biru slim fit untuk tampil stylish.',
    image:
        'https://down-id.img.susercontent.com/file/97dde8e47ca46f68495746dd808405c0',
  ),
  Product(
    id: '3',
    name: 'Jaket Hoodie',
    price: 150000,
    stock: 10,
    description: 'Jaket hoodie hangat cocok untuk musim hujan.',
    image: 'https://i.ebayimg.com/images/g/brYAAeSwUzRoFjD5/s-l960.webp',
  ),
  Product(
    id: '4',
    name: 'Sepatu Sneakers',
    price: 250000,
    stock: 8,
    description: 'Sepatu ringan dan nyaman untuk aktivitas harian.',
    image:
        'https://down-id.img.susercontent.com/file/id-11134207-7rasm-m4mfaz0psywqa3@resize_w900_nl.webp',
  ),
  Product(
    id: '5',
    name: 'Topi Baseball',
    price: 35000,
    stock: 30,
    description: 'Topi kasual cocok untuk jalan-jalan atau olahraga.',
    image:
        'https://images.tokopedia.net/img/cache/200/VqbcmM/2022/9/13/8abf8a97-4617-486f-984d-a4edb8a534f8.jpg.webp?ect=4g',
  ),
  Product(
    id: '6',
    name: 'Kemeja Flanel',
    price: 100000,
    stock: 12,
    description: 'Kemeja flanel keren dengan motif kotak-kotak.',
    image:
        'https://www.russ.co.id/cdn/shop/files/ginee_20230905170323117_1172060070_1000x.png?v=1739795370',
  ),
  Product(
    id: '7',
    name: 'Jam Tangan',
    price: 180000,
    stock: 6,
    description: 'Jam tangan dengan fitur tanggal dan stopwatch.',
    image:
        'https://images.tokopedia.net/img/cache/500-square/product-1/2018/10/26/4292132/4292132_2f961af0-d4c5-4b6f-bb63-d0a351d4bf50_700_700.jpg.webp?ect=4g',
  ),
  Product(
    id: '8',
    name: 'Tas Ransel',
    price: 200000,
    stock: 9,
    description: 'Tas ransel besar cocok untuk sekolah atau kerja.',
    image:
        'https://down-id.img.susercontent.com/file/id-11134207-7r98p-lngwhfepqv9653.webp',
  ),
];
