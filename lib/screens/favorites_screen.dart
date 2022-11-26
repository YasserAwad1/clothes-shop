import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/bottom_app_bar.dart';
import '../widgets/top_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart_provider.dart';
import '../providers/auth.dart';
import '../screens/home_screen.dart';

class FavoritesScreen extends StatefulWidget {
  static const routeName = '/favorites-screen';

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final isHome = false;
  var isExpanded = false;

  @override
  Widget build(BuildContext context) {
    Color gold = Theme.of(context).colorScheme.secondary;
    final deviceHeight = MediaQuery.of(context).size.height;
    final scKey = Provider.of<HomeScreen>(context).scaffoldKey;
    final favoriteProducts = Provider.of<Products>(context).favoriteItems;
    final cart = Provider.of<Cart>(context);
    final authData = Provider.of<Auth>(context);
    const snackBar = SnackBar(
      duration: Duration(seconds: 2),
      content: Text('Item added successfully!'),
    );

    return SafeArea(
      child: Scaffold(
        key: scKey,
        drawer: AppDrawer(),
        body: Column(
          children: [
            TopAppBar(scKey),
            SizedBox(
              height: deviceHeight * 0.02,
            ),
            favoriteProducts.isEmpty
                ? SizedBox(
                    height: deviceHeight * 0.7,
                    child: const Center(
                      child: Text('No favorites yet, start adding some!'),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: favoriteProducts.length,
                      itemBuilder: (ctx, i) => Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          shadowColor: gold,
                          elevation: 3,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(5),
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: Image.network(
                                favoriteProducts[i].imageUrl,
                              ),
                            ),
                            title: Text(
                              favoriteProducts[i].manufacturer,
                              style: TextStyle(
                                color: gold,
                              ),
                            ),
                            subtitle: Text(
                              favoriteProducts[i].title,
                              style: const TextStyle(color: Colors.black),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    cart.addItem(
                                      favoriteProducts[i].id,
                                      favoriteProducts[i].title,
                                      favoriteProducts[i].manufacturer,
                                      favoriteProducts[i].price,
                                      favoriteProducts[i].imageUrl,
                                    );
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                  icon: Icon(
                                    Icons.shopping_cart_rounded,
                                    color: gold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      favoriteProducts[i].toggleFavoriteStatus(
                                        authData.token!,
                                        authData.userId!,
                                      );
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                  ),
                                  color: Theme.of(context).errorColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: deviceHeight * 0.068,
          child: MyBottomAppBar(isHome),
        ),
      ),
    );
  }
}
