class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;
  final int restaurantId;
  final List<String> categories;
  final bool isAvailable;
  final double? discount;
  final bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.restaurantId,
    required this.categories,
    this.isAvailable = true,
    this.discount,
    this.isFavorite = false,
  });

  double get finalPrice {
    if (discount != null) {
      return price - (price * discount! / 100);
    }
    return price;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      image: json['image'],
      restaurantId: json['restaurantId'],
      categories: List<String>.from(json['categories']),
      isAvailable: json['isAvailable'] ?? true,
      discount: json['discount']?.toDouble(),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'restaurantId': restaurantId,
      'categories': categories,
      'isAvailable': isAvailable,
      'discount': discount,
      'isFavorite': isFavorite,
    };
  }
}

