import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/features/home/provider/product_provider.dart';
import 'package:shop_app/features/home/widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.showFavoriteOnly,
  });
  final bool showFavoriteOnly;

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductProvider>(context);
    final products =
        showFavoriteOnly ? productData.favoriteItem : productData.items;
    // products.add(
    //   Product(
    //     id: 'p9',
    //     title: 'A Pan',
    //     description: 'Prepare any meal you want.',
    //     price: 49.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //   ),
    // );
    // Provider.of<ProductProvider>(context).displayFavorite();
    // for (final item in products) {
    //   log(item.isFavorite.toString());
    // }

    return GridView.builder(
      itemCount: products.length,
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) => ProductItem(id: products[index].id),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        childAspectRatio: 3 / 2,
        mainAxisSpacing: 10,
      ),
    );
  }
}
