// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/features/cart/pages/cart_page.dart';
import 'package:shop_app/features/cart/provider/cart_provider.dart';
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
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MaterialApp(
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
        home: const ProductOverviewPage(),
        routes: {
          ProductDetailsPage.routeName: (context) => const ProductDetailsPage(),
          UserProductPage.routeName: (context) => const UserProductPage(),
          EditProductPage.routeName: (context) => const EditProductPage(),
          OrderPage.routeName: (context) => const OrderPage(),
          CartPage.routeName: (context) => const CartPage(),
        },
      ),
    );
  }
}
