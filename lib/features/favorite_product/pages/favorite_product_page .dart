import 'package:flutter/material.dart';
import 'package:shop_app/features/home/widgets/product_grid.dart';
import 'package:shop_app/widgets/app_drawer.dart';

class FavoriteProductPage extends StatelessWidget {
  const FavoriteProductPage({super.key});
  static const routeName = '/favorite-product';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Favorite'),
      ),
      drawer: const AppDrawer(),
      body: const ProductGrid(showFavoriteOnly: true),
    );
  }
}
