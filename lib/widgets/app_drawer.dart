import 'package:flutter/material.dart';
import 'package:shop_app/pages/order_page.dart';
import 'package:shop_app/pages/user_product_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Shop App'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            title: const Text('Shop'),
            leading: const Icon(Icons.shop_rounded),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Orders'),
            leading: const Icon(Icons.payment_rounded),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderPage.routeName);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Manage Products'),
            leading: const Icon(Icons.edit),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductPage.routeName);
            },
          ),
        ],
      ),
    );
  }
}
