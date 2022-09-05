import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/features/authentication/providers/auth_provider.dart';
import 'package:shop_app/features/home/pages/product_details_page.dart';
import 'package:shop_app/features/home/provider/product_provider.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    super.key,
    required this.id,
  });
  final String id;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context).findById(widget.id);
    final auth = Provider.of<AuthProvider>(context);
    // final cart = Provider.of<CartProvider>(context);
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
          trailing: Consumer<ProductProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: Icon(
                  product.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                ),
                onPressed: () {
                  setState(() {
                    provider.toggleFavorite(product.id!, auth.userId);
                  });
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
              arguments: product,
            );
          },
          child: Image.network(product.imageUrl ?? '', fit: BoxFit.cover),
        ),
      ),
    );
  }
}
