// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/features/authentication/pages/authentication_page.dart';
import 'package:shop_app/features/authentication/providers/auth_provider.dart';
import 'package:shop_app/features/cart/pages/cart_page.dart';
import 'package:shop_app/features/cart/provider/cart_provider.dart';
import 'package:shop_app/features/favorite_product/pages/favorite_product_page%20.dart';
import 'package:shop_app/features/home/pages/product_details_page.dart';
import 'package:shop_app/features/home/pages/product_overview_page.dart';
import 'package:shop_app/features/home/provider/product_provider.dart';
import 'package:shop_app/features/manage_product/pages/edit_product_page.dart';
import 'package:shop_app/features/manage_product/pages/user_product_page.dart';
import 'package:shop_app/features/order/pages/order_page.dart';
import 'package:shop_app/features/order/provider/order_provider.dart';
import 'package:shop_app/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          create: (context) => ProductProvider(
            Provider.of<AuthProvider>(context, listen: false).token,
            Provider.of<AuthProvider>(context, listen: false).userId,
            [],
          ),
          update: (context, auth, previousProducts) => ProductProvider(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          update: (context, auth, previousOrders) => OrderProvider(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orderitems,
          ),
          create: (context) => OrderProvider(
            Provider.of<AuthProvider>(context, listen: false).token,
            Provider.of<AuthProvider>(context, listen: false).userId,
            [],
          ),
        ),
        ChangeNotifierProvider.value(value: CartProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
              colorScheme: ColorScheme.fromSwatch(
                accentColor: const Color(0xFF13B9FF),
              ),
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: auth.isAuth
                ? const ProductOverviewPage()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : const AuthenticationPage();
                    },
                  ),
            routes: {
              CartPage.routeName: (context) => const CartPage(),
              OrderPage.routeName: (context) => const OrderPage(),
              UserProductPage.routeName: (context) => const UserProductPage(),
              EditProductPage.routeName: (context) => const EditProductPage(),
              ProductDetailsPage.routeName: (context) =>
                  const ProductDetailsPage(),
              FavoriteProductPage.routeName: (context) =>
                  const FavoriteProductPage(),
              ProductOverviewPage.routeName: (context) =>
                  const ProductOverviewPage(),
            },
          );
        },
      ),
    );
  }
}
