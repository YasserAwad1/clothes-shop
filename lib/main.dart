import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/home_screen.dart';
import '/screens/settings_screen.dart';
import './screens/orders_screen.dart';
import './screens/shop_details_screen.dart';
import './screens/favorites_screen.dart';
import './screens/cart_screen.dart';
import './screens/add_shop_screen.dart';
import './screens/add_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import 'providers/shops.dart';
import '/providers/order_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/products.dart';
import 'providers/auth.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Color gold = const Color.fromRGBO(163, 138, 0, 1);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Shops>(
            create: (_) => Shops('', []),
            update: (ctx, auth, previousShops) => Shops(
              auth.token,
              previousShops == null ? [] : previousShops.shops,
            ),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products('', '', []),
            update: (ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.products,
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, OrderProvider>(
              create: (_) => OrderProvider('', '', []),
              update: (ctx, auth, previousOrders) => OrderProvider(
                  auth.token,
                  auth.userId,
                  previousOrders == null ? [] : previousOrders.orders)),
          ChangeNotifierProvider(
            create: (_) => HomeScreen(),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'clothes shop',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
                  .copyWith(secondary: gold),
            ),
            home: auth.isAuth
                ? HomeScreen()
                : FutureBuilder(
                    future: auth.autoLogin(),
                    builder: (ctx, authDataSnapshot) =>
                        authDataSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? const SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ShopDetailsScreen.routeName: (ctx) => ShopDetailsScreen(),
              HomeScreen.routeName: (ctx) => HomeScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              SettingsScreen.routeName: (ctx) => SettingsScreen(),
              FavoritesScreen.routeName: (ctx) => FavoritesScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              AddShopScreen.routeName: (ctx) => AddShopScreen(),
              AddProductScreen.routeName: (ctx) => AddProductScreen(),
            },
          ),
        ));
  }
}
