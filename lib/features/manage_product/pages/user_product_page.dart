import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/features/home/provider/product_provider.dart';
import 'package:shop_app/features/manage_product/pages/edit_product_page.dart';
import 'package:shop_app/features/manage_product/widgets/user_product_item.dart';
import 'package:shop_app/widgets/app_drawer.dart';

class UserProductPage extends StatefulWidget {
  const UserProductPage({super.key});
  static const routeName = '/user-product';

  @override
  State<UserProductPage> createState() => _UserProductPageState();
}

class _UserProductPageState extends State<UserProductPage> {
  var _isLoading = false;
  Future<void> onRefresh(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchProducts(true);
  }

  @override
  void didChangeDependencies() {
    setState(() => _isLoading = true);
    Provider.of<ProductProvider>(context,listen: false).fetchProducts(true);
    setState(() => _isLoading = false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final product = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Products'),
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => onRefresh(context),
              child: Consumer<ProductProvider>(
                builder: (context, product, _) => ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: product.items.length,
                  itemBuilder: (context, index) {
                    return UserProductItem(
                      product: product.items[index],
                    );
                  },
                ),
              ),
              // : Center(
              //     child: Image.asset(
              //       'assets/images/No_Product_Found.png',
              //       width: 250,
              //       height: 250,
              //     ),
              //   ),
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
