import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/features/home/pages/product_details_page.dart';
import 'package:shop_app/features/cart/provider/cart_provider.dart';
import 'package:shop_app/features/home/provider/product_provider.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
    required this.id,
  });
  final String id;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context).findById(id);
    final cart = Provider.of<CartProvider>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          title: Text.rich(
            TextSpan(
              text: '${product.title} \n',
              style: const TextStyle(color: Colors.white),
              children: [
                TextSpan(
                  text: '\$${product.price}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          backgroundColor: Colors.black54,
          leading: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(
                product.id,
                product.price,
                product.title,
                product.imageUrl,
              );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Added item to cart'),
                  duration: const Duration(seconds: 3),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
          ),
          trailing: Consumer<ProductProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: Icon(
                  product.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                ),
                onPressed: () {
                  provider.toggleFavorite(product.id);
                },
              );
            },
          ),
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              ProductDetailsPage.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(product.imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
