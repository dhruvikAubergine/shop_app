class Cart {
  Cart({
    required this.id,
    required this.price,
    required this.title,
    required this.image,
    required this.quantity,
  });

  final String id;
  final String title;
  final String image;
  final double price;
  final double quantity;
}
