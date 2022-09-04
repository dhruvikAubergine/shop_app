import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/features/home/models/new_product.dart';
import 'package:shop_app/features/home/provider/product_provider.dart';
import 'package:shop_app/features/manage_product/widgets/user_product_item.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({super.key});
  static const routeName = '/edit-product';

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  static const String urlRegexPattern =
      r'((http|https)://)(www.)+[a-zA-Z0-9@:%._\\+~#?&//=]{2,256}\\.[a-z]+{2,6}\\b([-a-zA-Z0-9@:%._\\+~#?&//=]*)';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();

  bool _isUrlValid = true;
  String productId = '';

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    _formKey.currentState?.save();
    final product = NewProduct(
      id: productId == '' ? DateTime.now().toString() : productId,
      title: _titleController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      imageUrl: _isUrlValid ? _imageUrlController.text : '',
    );
    if (productId == '') {
      try {
        await Provider.of<ProductProvider>(context, listen: false)
            .addProduct(product);

        if (!mounted) return;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product is added.'),
            duration: Duration(seconds: 3),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong, please try again!'),
          ),
        );
      }
    } else {
      await Provider.of<ProductProvider>(context, listen: false)
          .updateProduct(product.id ?? '', product);

      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product is updated.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    final productArguments =
        ModalRoute.of(context)!.settings.arguments! as ProductArgument;
    if (productArguments.isForEdit == true) {
      productId = productArguments.id;
      final editedProduct =
          Provider.of<ProductProvider>(context).findById(productArguments.id);
      _titleController.text = editedProduct.title ?? '';
      _priceController.text = editedProduct.price.toString();
      _descriptionController.text = editedProduct.description ?? '';
      _imageUrlController.text = editedProduct.imageUrl ?? '';
    } else {
      _titleController.text = '';
      _priceController.text = '';
      _descriptionController.text = '';
      _imageUrlController.text = '';
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Please enter a price';
                final price = double.tryParse(value ?? '') ?? 0;
                if (price.isNegative || price.isNaN || price == 0) {
                  return 'Please enter a valid price';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              maxLines: 2,
              controller: _descriptionController,
              keyboardType: TextInputType.multiline,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              validator: (value) {
                final desc = value?.trim() ?? '';
                if (desc.isEmpty) {
                  return 'Please enter a description';
                } else if (desc.length < 10) {
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
                  child:
                      _isUrlValid == false || _imageUrlController.text.isEmpty
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
                    keyboardType: TextInputType.url,
                    controller: _imageUrlController,
                    textInputAction: TextInputAction.done,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onEditingComplete: () {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      labelText: 'Image URL',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      final url = value?.trim() ?? '';
                      if (url.isEmpty) {
                        _isUrlValid = false;
                        return 'Please enter an Image URL';
                      } else if (!url.startsWith('http') &&
                          !url.startsWith('https')) {
                        _isUrlValid = false;

                        return 'Please enter a valid URL';
                      }
                      // else if (!RegExp(urlRegexPattern).hasMatch(url)) {
                      //   _isUrlValid = false;

                      //   return 'Please enter a valid URL';
                      // }
                      _isUrlValid = true;
                      return null;
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
