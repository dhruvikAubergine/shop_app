import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/features/order/provider/order_provider.dart';
import 'package:shop_app/features/order/widgets/order_item.dart';
import 'package:shop_app/widgets/app_drawer.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});
  static const routeName = '/orders';

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    Provider.of<OrderProvider>(context, listen: false).fetchOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Your Orders')),
      drawer: const AppDrawer(),
      body: orders.orderitems.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: orders.orderitems.length,
              itemBuilder: (context, index) {
                return OrderItem(
                  order: orders.orderitems[index],
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/order_image.png'),
                  const Text(
                    "You haven't placed any order yet!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
    );
  }
}
