import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product extends Equatable {
  Product({
    this.id,
    this.title,
    this.price,
    this.duration,
    this.imageUrl,
    this.description,
    this.isFavorite = false,
    this.checkSalesAvailability = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return _$ProductFromJson(json);
  }

  void toggleFavoriteStatus(String id) {
    isFavorite = !isFavorite;
  }

  final String? id;
  final String? title;
  final String? imageUrl;
  final String? description;
  double? price;
  bool isFavorite;
  DateTime? duration;
  bool checkSalesAvailability;

  // void startTimer() {
  //   duration = const Duration(minutes: 1);
  //   timer = Timer.periodic(const Duration(seconds: 1), (_) {
  //     addTime();
  //     notifyListeners();
  //   });
  // }

  // String? minute;
  // String? hour;
  // String? second;
  // void addTime() {
  //   final secound = duration.inSeconds - 1;
  //   duration = Duration(seconds: secound);

  //   if (secound <= 0) {
  //     timer?.cancel();
  //   }
  //   log(duration.inSeconds.toString());
  //   second = twoDigits(duration.inSeconds.remainder(60));
  //   minute = twoDigits(duration.inMinutes.remainder(60));
  //   hour = twoDigits(duration.inHours.remainder(60));
  //   notifyListeners();
  // }

  // String twoDigits(int n) {
  //   return n.toString().padLeft(2, '0');
  // }

  // String get minutes => twoDigits(duration.inMinutes.remainder(60));
  // String get seconds => twoDigits(duration.inSeconds.remainder(60));
  // String get hours => twoDigits(duration.inHours.remainder(60));

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  Product copyWith({
    String? id,
    String? title,
    double? price,
    String? imageUrl,
    String? description,
    bool? isFavorite,
    DateTime? duration,
    bool? checkSalesAvailability,
  }) {
    return Product(
      id: id ?? this.id,
      duration: duration ?? this.duration,
      title: title ?? this.title,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      checkSalesAvailability:
          checkSalesAvailability ?? this.checkSalesAvailability,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      title,
      price,
      duration,
      imageUrl,
      description,
      isFavorite,
      checkSalesAvailability
    ];
  }
}
