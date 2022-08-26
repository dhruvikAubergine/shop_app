import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/features/home/provider/product_provider.dart';
import 'package:shop_app/features/manage_product/pages/edit_product_page.dart';
import 'package:shop_app/features/manage_product/widgets/user_product_item.dart';
import 'package:shop_app/widgets/app_drawer.dart';

class UserProductPage extends StatelessWidget {
  const UserProductPage({super.key});
  static const routeName = '/user-product';

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Products'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: product.items.length,
        itemBuilder: (context, index) {
          return UserProductItem(
            product: product.items[index],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Product',
        onPressed: () => Navigator.pushNamed(
          context,
          EditProductPage.routeName,
          arguments: ProductArgument(id: '', isForEdit: false),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}