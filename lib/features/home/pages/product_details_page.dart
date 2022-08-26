import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/features/home/provider/product_provider.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key});

  static const routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments! as String;
    final loadedProduct = Provider.of<ProductProvider>(context, listen: false)
        .findById(productId);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(loadedProduct.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          SizedBox(
            height: 300,
            child: Image.network(
              loadedProduct.imageUrl,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '\$${loadedProduct.price}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            loadedProduct.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}
