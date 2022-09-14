import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/features/cart/provider/cart_provider.dart';
import 'package:shop_app/features/cart/widgets/cart_item.dart';
import 'package:shop_app/features/cart/widgets/order_price_widget.dart';
import 'package:shop_app/features/order/provider/order_provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  static const routeName = '/cart';

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final itemValues = cart.items.values.toList();
    final itemKeys = cart.items.keys.toList();
    final deliveryCharge = cart.totalAmount * 0.05;

    final grandTotal = cart.totalAmount + deliveryCharge + cart.totalTax;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Your Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: cart.items.isNotEmpty
                  ? ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        return CartItem(
                          id: itemValues[index].id ?? '',
                          price: itemValues[index].price ?? 0.0,
                          title: itemValues[index].title ?? '',
                          image: itemValues[index].image ?? '',
                          quantity: itemValues[index].quantity ?? 0.0,
                          productId: itemKeys[index],
                          taxPercentage: itemValues[index].taxPercentage ?? 0.0,
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/order.png'),
                          const Text(
                            'Your Cart Is Currently Empty',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
            ),
            if (cart.items.isNotEmpty)
              OrderPriceWidget(
                amount: cart.totalAmount,
                deliveryCharge: deliveryCharge,
                tax: cart.totalTax,
                grandTotal: grandTotal,
              )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: cart.totalAmount <= 0
                ? null
                : () async {
                    await Provider.of<OrderProvider>(
                      context,
                      listen: false,
                    ).addOrder(
                      itemValues,
                      grandTotal,
                      deliveryCharge,
                      cart.totalTax,
                    );
                    log('${cart.items}');
                    cart.clear();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('order placed successfully.'),
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
              'Order Now',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
