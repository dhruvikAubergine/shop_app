import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/features/cart/pages/cart_page.dart';
import 'package:shop_app/features/cart/provider/cart_provider.dart';
import 'package:shop_app/features/home/provider/product_provider.dart';
import 'package:shop_app/features/home/widgets/product_grid.dart';
import 'package:shop_app/widgets/app_drawer.dart';

enum FilterOption {
  favorite,
  all,
}

class ProductOverviewPage extends StatefulWidget {
  const ProductOverviewPage({super.key});
  static const routeName = '/product-overview';

  @override
  State<ProductOverviewPage> createState() => _ProductOverviewPageState();
}

class _ProductOverviewPageState extends State<ProductOverviewPage> {
  // final _showFavoriteOnly = false;
  var _isint = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    setState(() {
      _isLoading = true;
    });
    if (_isint) {
      Provider.of<ProductProvider>(context)
          .fetchProducts()
          .then((value) => _isLoading = false);
    }
    setState(() {
      _isLoading = false;
    });
    _isint = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Shop app'),
        actions: [
          // PopupMenuButton(
          //   icon: const Icon(Icons.more_vert_rounded),
          //   onSelected: (FilterOption value) {
          //     if (value == FilterOption.all) {
          //       setState(() => _showFavoriteOnly = false);
          //     } else {
          //       setState(() => _showFavoriteOnly = true);
          //     }
          //   },
          //   itemBuilder: (context) => [
          //     const PopupMenuItem(
          //       value: FilterOption.all,
          //       child: Text('Show all'),
          //     ),
          //     const PopupMenuItem(
          //       value: FilterOption.favorite,
          //       child: Text('Show only favorite'),
          //     ),
          //   ],
          // ),
          Badge(
            badgeColor: Colors.transparent,
            position: BadgePosition.topEnd(
              end: 0,
              top: 0,
            ),
            badgeContent: Text(cart.itemCount.toString()),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CartPage.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          : const ProductGrid(showFavoriteOnly: false),
    );
  }
}
