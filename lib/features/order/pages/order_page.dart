import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/features/order/provider/order_provider.dart';
import 'package:shop_app/features/order/widgets/order_item.dart';
import 'package:shop_app/widgets/app_drawer.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Your Orders')),
      drawer: const AppDrawer(),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: orders.orderitems.length,
        itemBuilder: (context, index) {
          return OrderItem(
            order: orders.orderitems[index],
          );
        },
      ),
    );
  }
}
