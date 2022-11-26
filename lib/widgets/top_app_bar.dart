import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';
import '../providers/cart_provider.dart';
import '../widgets/badge.dart';

class TopAppBar extends StatelessWidget {
  var scaffoldKey;
  TopAppBar(this.scaffoldKey);

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    final gold = Theme.of(context).colorScheme.secondary;

    return SizedBox(
      height: deviceHeight * 0.06,
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                },
                icon: Icon(
                  Icons.clear_all_rounded,
                  color: gold,
                  size: 40,
                )),
            Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                  child: ch!, value: cart.itemCount.toString(), color: gold),
              child: IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(CartScreen.routeName),
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.black,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
