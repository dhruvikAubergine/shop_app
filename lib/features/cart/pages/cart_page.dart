import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/features/cart/provider/cart_provider.dart';
import 'package:shop_app/features/cart/widgets/cart_item.dart';
import 'package:shop_app/features/order/provider/order_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final itemValues = cart.items.values.toList();
    final itemKeys = cart.items.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total'),
                    const Spacer(),
                    Chip(
                      label: Text('\$ ${cart.totalAmount.toStringAsFixed(2)}'),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<OrderProvider>(context, listen: false)
                            .addOrder(
                          cart.items.values.toList(),
                          cart.totalAmount,
                        );
                        cart.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('order placed successfully.'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      },
                      child: const Text('Order now'),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (cart.itemCount > 0)
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    return CartItem(
                      id: itemValues[index].id,
                      price: itemValues[index].price,
                      title: itemValues[index].title,
                      image: itemValues[index].image,
                      quantity: itemValues[index].quantity,
                      productId: itemKeys[index],
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
