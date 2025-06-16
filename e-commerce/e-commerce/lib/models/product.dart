class Product {
  final String id;
  final String name;
  final double price;
  int stock;
  final String description;
  final String image;
  final List<String> subImage;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.description,
    required this.image,
    required this.subImage,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'price': price,
    "stock": stock,
    'description': description,
    "image": image,
    "subImage": subImage,
  };

  factory Product.fromMap(Map<String, dynamic> map) => Product(
    id: map['id'],
    name: map['name'],
    price: (map['price'] as num).toDouble(),
    stock: map["stock"],
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
    description: 'Kaos katun nyaman dipakai sehari-hari.',
    image:
        'https://down-id.img.susercontent.com/file/id-11134207-7r992-lxbemuqxv7z25a.webp',
    subImage: [
      "https://down-id.img.susercontent.com/file/id-11134207-7r992-lxbemuqxv7z25a.webp",
      "https://down-id.img.susercontent.com/file/id-11134207-7r98x-lnrry2jlpad685",
      "https://berducdn.com/img/800/bsoai4w7bsoau5pwec_2/Cdu5iPv08TOBLsTcCdDC8vj16xpfI6QvScgUPXyf37uA.jpg",
      "https://id-test-11.slatic.net/p/06ebd11e46e17a536f575f9cac26ab43.jpg",
    ],
  ),
  Product(
    id: '2',
    name: 'Celana Jeans',
    stock: 15,
    price: 120000,
    description: 'Celana jeans biru slim fit untuk tampil stylish.',
    image:
        'https://down-id.img.susercontent.com/file/97dde8e47ca46f68495746dd808405c0',
    subImage: [
      "https://down-id.img.susercontent.com/file/97dde8e47ca46f68495746dd808405c0",
      "https://triplejeans.id/cdn/shop/products/94Z858BWD_1.jpg?v=1679647346",
      "https://www.russ.co.id/cdn/shop/files/ginee_20230418181545139_4787190287_800x.jpg?v=1739795745",
      "https://media.karousell.com/media/photos/products/2022/7/12/celana_jeans_denim_wanita_cokl_1657614762_16dec64c_progressive",
    ],
  ),
  Product(
    id: '3',
    name: 'Jaket Hoodie',
    price: 150000,
    stock: 10,
    description: 'Jaket hoodie hangat cocok untuk musim hujan.',
    image: 'https://i.ebayimg.com/images/g/brYAAeSwUzRoFjD5/s-l960.webp',
    subImage: [
      'https://i.ebayimg.com/images/g/brYAAeSwUzRoFjD5/s-l960.webp',
      'https://d29c1z66frfv6c.cloudfront.net/pub/media/catalog/product/zoom/7e374c605e9aa9bc8a3b41559f9be79aa3e10d69_xxl-1.jpg',
      "https://id-test-11.slatic.net/p/ba28687375c2f93ddef5652510fad308.jpg",
      "https://images.tokopedia.net/img/cache/700/VqbcmM/2022/10/15/20c5e9b1-d220-4226-bae0-884522c7519c.jpg",
    ],
  ),
  Product(
    id: '4',
    name: 'Sepatu Sneakers',
    price: 250000,
    stock: 8,
    description: 'Sepatu ringan dan nyaman untuk aktivitas harian.',
    image:
        'https://down-id.img.susercontent.com/file/sg-11134201-7rffb-m9sa2jeauzak53@resize_w900_nl.webp',
    subImage: [
      'https://down-id.img.susercontent.com/file/sg-11134201-7rffb-m9sa2jeauzak53@resize_w900_nl.webp',
      "https://down-id.img.susercontent.com/file/sg-11134201-7rbl6-lof5uac16f3wdd.webp",
      "https://down-id.img.susercontent.com/file/sg-11134201-7rbmd-lof5ubt0zg3ha8.webp",
      "https://down-id.img.susercontent.com/file/sg-11134201-7rbka-lof5ualgsm67f7.webp",
    ],
  ),
  Product(
    id: '5',
    name: 'Topi Unisex',
    price: 35000,
    stock: 30,
    description: 'Topi kasual cocok untuk jalan-jalan atau olahraga.',
    image:
        'https://down-id.img.susercontent.com/file/019b044ca37483d08b104bf8d8466b4d.webp',
    subImage: [
      "https://down-id.img.susercontent.com/file/019b044ca37483d08b104bf8d8466b4d.webp",
      'https://down-id.img.susercontent.com/file/id-11134207-7qukx-lf0ua1cfd38t2e.webp',
      "https://down-id.img.susercontent.com/file/id-11134207-7qukx-lf0ua1cfbood29.webp",
      "https://down-id.img.susercontent.com/file/dcc9e0c756865f2e1765aa7693bffa3e.webp",
    ],
  ),
  Product(
    id: '6',
    name: 'Kemeja Flanel',
    price: 100000,
    stock: 12,
    description: 'Kemeja flanel keren dengan motif kotak-kotak.',
    image:
        'https://matahari.com/cdn/shop/files/18207942_1.jpg?v=1741834663&width=720',
    subImage: [
      "https://matahari.com/cdn/shop/files/18207942_1.jpg?v=1741834663&width=720",
      "https://matahari.com/cdn/shop/files/18207942_2.jpg?v=1741834665&width=720",
      "https://matahari.com/cdn/shop/files/18207942_3.jpg?v=1741834666&width=720",
      "https://matahari.com/cdn/shop/files/18207942_4.jpg?v=1741834668&width=720",
    ],
  ),
  Product(
    id: '7',
    name: 'Jam Tangan',
    price: 180000,
    stock: 6,
    description: 'Jam tangan dengan fitur tanggal dan stopwatch.',
    image:
        'https://down-id.img.susercontent.com/file/654d6f64f8551ad90eab1248699ea856.webp',
    subImage: [
      'https://down-id.img.susercontent.com/file/654d6f64f8551ad90eab1248699ea856.webp',
      "https://down-id.img.susercontent.com/file/3c2042ff6292e563b7a57654b6a37be3.webp",
      "https://down-id.img.susercontent.com/file/374af2fd9ecceed7fdaee05692dacde7.webp",
      "https://down-id.img.susercontent.com/file/c9d798cd955a63a49a29f6f43220b07c.webp",
    ],
  ),
  Product(
    id: '8',
    name: 'Tas Ransel',
    price: 200000,
    stock: 9,
    description: 'Tas ransel besar cocok untuk sekolah atau kerja.',
    image:
        'https://down-id.img.susercontent.com/file/id-11134207-7r98p-lngwhfepqv9653.webp',
    subImage: [
      'https://down-id.img.susercontent.com/file/id-11134207-7r98p-lngwhfepqv9653.webp',
      "https://down-id.img.susercontent.com/file/id-11134207-7qul9-lh47kneo95c331.webp",
      "https://down-id.img.susercontent.com/file/id-11134207-7qukw-lh47kneo6c772f.webp",
      "https://down-id.img.susercontent.com/file/id-11134207-7qul8-lh47kneo4xmr11.webp",
    ],
  ),
];
