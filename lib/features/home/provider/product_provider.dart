import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/features/home/models/new_product.dart';
import 'package:shop_app/features/manage_product/modals/http_exception.dart';

class ProductProvider with ChangeNotifier {
  ProductProvider(
    this.authToken,
    this.userId,
    this._items,
  );
  List<NewProduct> _items = [];

  final String authToken;
  final String userId;

  List<NewProduct> get items {
    return _items;
  }

  List<NewProduct> get favoriteItem {
    return _items.where((element) => element.isFavorite == true).toList();
  }

  NewProduct findById(String id) {
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

    notifyListeners();

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

  Future<void> updateProduct(String id, NewProduct newProduct) async {
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
      final loadedProduct = <NewProduct>[];
      (jsonDecode(response.body) as Map<String, dynamic>).forEach((key, value) {
        (value as Map<String, dynamic>).putIfAbsent('id', () => key);
        value.putIfAbsent(
          'isFavorite',
          () => favoriteData == null ? false : favoriteData[key] ?? false,
        );
        loadedProduct.add(NewProduct.fromJson(value));
      });

      _items = loadedProduct;

      notifyListeners();

      log(jsonEncode(response.body));
    } catch (error) {
      log(error.toString());
      rethrow;
    }
  }

  Future<void> addProduct(NewProduct product) async {
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
      final newProduct = NewProduct(
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
