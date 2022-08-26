import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/features/home/models/product.dart';
import 'package:shop_app/features/home/provider/product_provider.dart';
import 'package:shop_app/features/manage_product/widgets/user_product_item.dart';

import '../widgets/user_product_item.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({super.key});
  static const routeName = '/edit-product';

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();

  final bool _isInit = true;
  String productId = '';

  void _onSave() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    _formKey.currentState?.save();
    final product = Product(
      id: productId == '' ? DateTime.now().toString() : productId,
      title: _titleController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      imageUrl: _imageUrlController.text,
    );
    if (productId == '') {
      Provider.of<ProductProvider>(context, listen: false).addProduct(product);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product is added.'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      Provider.of<ProductProvider>(context, listen: false)
          .updateProduct(product.id, product);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product is updated.'),
          duration: Duration(seconds: 3),
        ),
      );
    }

    // log(product.title);
    // log(product.price.toString());
    // log(product.description);
    // log(product.imageUrl);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productArguments =
          ModalRoute.of(context)!.settings.arguments! as ProductArgument;
      if (productArguments.isForEdit == true) {
        productId = productArguments.id;
        final editedProduct =
            Provider.of<ProductProvider>(context).findById(productArguments.id);
        _titleController.text = editedProduct.title;
        _priceController.text = editedProduct.price.toString();
        _descriptionController.text = editedProduct.description;
        _imageUrlController.text = editedProduct.imageUrl;
      } else {
        _titleController.text = '';
        _priceController.text = '';
        _descriptionController.text = '';
        _imageUrlController.text = '';
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit Product'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            TextFormField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              validator: (value) {
                final title = value?.trim() ?? '';
                if (title.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _priceController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              validator: (value) {
                final price = double.tryParse(value ?? '') ?? 0;
                if (price.isNegative || price.isNaN || price == 0) {
                  return 'Please enter a valid price';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              maxLines: 2,
              // textInputAction: TextInputAction.next,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              validator: (value) {
                final title = value?.trim() ?? '';
                if (title.isEmpty) {
                  return 'Please enter a description';
                }
                if (title.length < 10) {
                  return 'Should be at least 10 characters long';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: _imageUrlController.text.isEmpty
                      ? const Icon(
                          Icons.shopping_bag_rounded,
                          size: 40,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            _imageUrlController.text,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Image URL',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      final url = value?.trim() ?? '';
                      if (url.isEmpty) {
                        return 'Please enter an Image URL';
                      }
                      if (!url.startsWith('http') && !url.startsWith('https')) {
                        return 'Please enter a valid URL';
                      }
                      // if (!Uri.parse(url).isAbsolute) {
                      //   return 'Please enter a valid URL';
                      // }
                      return null;
                    },
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    controller: _imageUrlController,
                    onEditingComplete: () {
                      setState(() {});
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _onSave,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColor,
                  ),
                ),
                child: const Text(
                  'Save',
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
