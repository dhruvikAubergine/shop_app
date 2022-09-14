import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/features/cart/provider/cart_provider.dart';
import 'package:shop_app/features/home/models/product.dart';
import 'package:shop_app/features/home/widgets/timer_widget.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, required this.product});

  static const routeName = '/product-details';
  final Product product;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.product.title ?? ''),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          SizedBox(
            height: 300,
            child: Image.network(
              widget.product.imageUrl ?? '',
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '\$${widget.product.price}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            widget.product.title ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
          TimerWidget(product: widget.product)
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Provider.of<CartProvider>(context, listen: false).addItem(
                    widget.product.id ?? '',
                    widget.product.price ?? 0,
                    widget.product.title ?? '',
                    widget.product.imageUrl ?? '',
                    widget.product.taxPercentage ?? 0.0,
                  );
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Added item to cart'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColor,
                  ),
                ),
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
