import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/pages/edit_product_page.dart';
import 'package:shop_app/providers/product_provider.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(product.title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(product.imageUrl),
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                tooltip: 'Edit Prodiuct',
                icon: const Icon(Icons.edit),
                color: Theme.of(context).primaryColor,
                onPressed: () => Navigator.pushNamed(
                  context,
                  EditProductPage.routeName,
                  arguments: ProductArgument(id: product.id, isForEdit: true),
                ),
              ),
              IconButton(
                tooltip: 'Delete Product',
                color: Colors.red[300],
                icon: const Icon(Icons.delete_forever_rounded),
                onPressed: () {
                  showDialogBox(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showDialogBox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'Do you want to remove the product?',
          ),
          actions: [
            ElevatedButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: const Text('Yes'),
              onPressed: () {
                Provider.of<ProductProvider>(
                  context,
                  listen: false,
                ).deleteProduct(product.id);
                Navigator.of(context).pop(true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product is deleted.'),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class ProductArgument {
  ProductArgument({required this.id, required this.isForEdit});

  final String id;
  final bool isForEdit;
}
