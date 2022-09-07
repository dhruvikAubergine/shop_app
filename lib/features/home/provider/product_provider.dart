import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/features/home/models/product.dart';
import 'package:shop_app/features/manage_product/modals/http_exception.dart';

class ProductProvider with ChangeNotifier {
  ProductProvider(
    this.authToken,
    this.userId,
    this._items,
  );
  List<Product> _items = [];

  final String authToken;
  final String userId;

  List<Product> get items {
    return _items;
  }

  List<Product> get favoriteItem {
    return _items.where((element) => element.isFavorite == true).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((productId) => productId.id == id);
  }

  Future<void> toggleFavorite(String id, String userId) async {
    final oldFavorite =
        _items.firstWhere((productId) => productId.id == id).isFavorite;

    _items
        .firstWhere((productId) => productId.id == id)
        .toggleFavoriteStatus(id);

    // _items
    //     .firstWhere((productId) => productId.id == id)
    //     .copyWith(isFavorite: !oldFavorite);

    // notifyListeners();

    final url = Uri.parse(
      'https://personal-expenses-e3eac-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken',
    );
    try {
      final response = await http.put(
        url,
        body: json.encode(!oldFavorite),
      );
      if (response.statusCode >= 400) {
        _items
            .firstWhere((productId) => productId.id == id)
            .copyWith(isFavorite: oldFavorite);
        notifyListeners();
      }
    } catch (error) {
      _items
          .firstWhere((productId) => productId.id == id)
          .copyWith(isFavorite: !oldFavorite);
      notifyListeners();
    }
  }

  // void startTimer(Product product) {
  //   product.startTimer();
  //   // notifyListeners();
  // }

  // String? minutes;
  // String? seconds;
  // String? hours;

  // void getMinutes(Product product) {
  //   minutes = product.minutes;
  // }

  // void getHours(Product product) {
  //   hours = product.hours;
  // }

  // void getSeconds(Product product) {
  //   seconds = product.seconds;
  // }

  // String? hours;
  // String? minutes;
  // String? seconds;

  // Duration duration = const Duration();
  // void startTimer(Product product) {
  //   duration = const Duration(minutes: 10);
  //   product.timer = Timer.periodic(const Duration(seconds: 1), (_) {
  //     final secound = duration.inSeconds - 1;
  //     duration = Duration(seconds: secound);

  //     if (secound <= 0) {
  //       product.timer?.cancel();
  //     }
  //     log(duration.inSeconds.toString());
  //     seconds = twoDigits(duration.inSeconds.remainder(60));
  //     hours = twoDigits(duration.inHours.remainder(60));
  //     minutes = twoDigits(duration.inMinutes.remainder(60));
  //   });
  //   notifyListeners();
  // }

  // String twoDigits(int n) {
  //   return n.toString().padLeft(2, '0');
  // }

  // String get getSeconds => seconds ?? '00';
  // String get getHours => hours ?? '00';
  // String get getMinutes => minutes ?? '00';

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      final url = Uri.parse(
        'https://personal-expenses-e3eac-default-rtdb.firebaseio.com//products/$id.json?auth=$authToken',
      );
      try {
        await http.patch(
          url,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            'isFavorite': newProduct.isFavorite,
            'description': newProduct.description,
          }),
        );
      } catch (error) {
        log(error.toString());
        rethrow;
      }
      _items[productIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
      'https://personal-expenses-e3eac-default-rtdb.firebaseio.com//products/$id?auth=$authToken',
    );

    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    final existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    // existingProduct = null;
    notifyListeners();
  }

  void setDurationForItem(String id, DateTime duration) {
    try {
      _items.firstWhere((element) {
        if (element.id == id) {
          element.duration = duration;
          notifyListeners();
          return true;
        }
        notifyListeners();
        return false;
      });
    } catch (error) {
      log(error.toString());
    }
  }

  

  // bool isSaleOn = true;
  // bool checkSalesAvailability(String id) {
  //   checkDuration(id);
  //   return isSaleOn;
  // }

  // void checkDuration(String id) {
  //   final index = _items.indexWhere((element) => element.id == id);
  //   if (_items[index].duration == null) {
  //     isSaleOn = true;
  //     notifyListeners();
  //     return;
  //   }
  //   if (_items[index].duration!.isBefore(DateTime.now())) {
  //     isSaleOn = true;
  //     notifyListeners();
  //     return;
  //   }
  //   isSaleOn = false;
  //   notifyListeners();
  //   return;
//}
  // _items.firstWhere((element) {
  //   if (element.id == id) {
  //     if (element.duration != null &&
  //         element.duration!.isBefore(DateTime.now())) {
  //       return true;
  //     }
  //     return false;
  //   }
  //   return false;
  // });

  Future<void> fetchProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="userId"&equalTo="$userId"' : '';
    final url = Uri.parse(
      'https://personal-expenses-e3eac-default-rtdb.firebaseio.com//products.json?auth=$authToken&$filterString',
    );
    try {
      final response = await http.get(url);
      // final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // final loadedProduct = <NewProduct>[];
      // if (extractedData.isEmpty) return;
      // extractedData.forEach((productId, product) {
      //   loadedProduct.add(
      //     NewProduct(
      //       id: productId,
      //       title: product['title'] as String,
      //       price: product['price'] as double,
      //       imageUrl: product['imageUrl'] as String,
      //       description: product['description'] as String,
      //       isFavorite: product['isFavorite'] as bool,
      //     ),
      //   );
      //   _items = loadedProduct;
      //   log(jsonEncode(loadedProduct));
      //   notifyListeners();
      // });
      // log(jsonEncode(response.body));
      // log(json.decode(response.body).toString());

      if (jsonDecode(response.body) == null) return;
      log(response.body);

      final favoriteUrl = Uri.parse(
        'https://personal-expenses-e3eac-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken',
      );
      final favoriteResponse = await http.get(favoriteUrl);
      final favoriteData = jsonDecode(favoriteResponse.body);
      final loadedProduct = <Product>[];
      (jsonDecode(response.body) as Map<String, dynamic>).forEach((key, value) {
        (value as Map<String, dynamic>).putIfAbsent('id', () => key);
        value.putIfAbsent(
          'isFavorite',
          () => favoriteData == null ? false : favoriteData[key] ?? false,
        );

        
        loadedProduct.add(Product.fromJson(value));
        
      });

      _items = loadedProduct;
      notifyListeners();

      log(jsonEncode(response.body));
    } catch (error) {
      log(error.toString());
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
      'https://personal-expenses-e3eac-default-rtdb.firebaseio.com//products.json?auth=$authToken',
    );
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'description': product.description,
          'userId': userId,
        }),
      );

      log(json.decode(response.body).toString());
      final newProduct = Product(
        id: json.decode(response.body)['name'].toString(),
        title: product.title,
        price: product.price,
        imageUrl: product.imageUrl,
        description: product.description,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      log(error.toString());
      rethrow;
    }
  }
}
