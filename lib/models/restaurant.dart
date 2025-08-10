class Restaurant {
  final int id;
  final String name;
  final String image;
  final double rating;
  final String deliveryTime;
  final String deliveryFee;
  final List<String> categories;
  final bool isNew;
  final bool isFavorite;
  final int reviews;
  final bool isOpen;
  final String? distance;

  Restaurant({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.categories,
    this.isNew = false,
    this.isFavorite = false,
    this.reviews = 0,
    this.isOpen = true,
    this.distance,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      rating: json['rating'].toDouble(),
      deliveryTime: json['deliveryTime'],
      deliveryFee: json['deliveryFee'],
      categories: List<String>.from(json['categories']),
      isNew: json['isNew'] ?? false,
      isFavorite: json["isFavorite"] ?? false,
      reviews: json["reviews"] ?? 0,
      isOpen: json["isOpen"] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'rating': rating,
      'deliveryTime': deliveryTime,
      'deliveryFee': deliveryFee,
      'categories': categories,
      'isNew': isNew,
      'isFavorite': isFavorite,
    };
  }
}
