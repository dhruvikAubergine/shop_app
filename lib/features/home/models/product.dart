class Product {
  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.description,
    this.isFavorite = false,
  });

  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String description;
  bool isFavorite;

  Product copyWith({
    String? id,
    String? title,
    double? price,
    String? imageUrl,
    String? description,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  void toggleFavoriteStatus(String id) {
    isFavorite = !isFavorite;
  }

  
}
