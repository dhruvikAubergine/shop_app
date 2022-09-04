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

    return products.isNotEmpty
        ? GridView.builder(
            itemCount: products.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) =>
                ProductItem(id: products[index].id ?? ''),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 3 / 2,
            ),
          )
        : Center(
            child: Image.asset(
              'assets/images/No_Product_Found.png',
              width: 250,
              height: 250,
            ),
          );
  }
}
