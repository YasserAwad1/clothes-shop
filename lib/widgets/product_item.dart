import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/product.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // final String manufacturer;
  // final double price;
  // final bool isFavorite;

  // ProductItem({
  //   required this.id,
  //   required this.title,
  //   required this.imageUrl,
  //   required this.manufacturer,
  //   required this.price,
  //   this.isFavorite = false,
  // });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context);
    final snackBar = SnackBar(
      duration: const Duration(seconds: 2),
      content: const Text('Item added successfully!'),
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: () => cart.removeSingleItem(product.id),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1.5, color: Theme.of(context).colorScheme.secondary),
              borderRadius: BorderRadius.circular(17)),
          child: GridTile(
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.contain,
            ),
            header: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black87,
              leading: Consumer<Product>(
                builder: (ctx, product, _) => IconButton(
                  onPressed: () {
                    product.toggleFavoriteStatus(
                      authData.token!,
                      authData.userId!,
                    );
                  },
                  icon: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              title: Text(product.title),
              trailing: IconButton(
                icon: Icon(Icons.shopping_cart,
                    color: Theme.of(context).colorScheme.secondary),
                onPressed: () {
                  cart.addItem(
                    product.id,
                    product.title,
                    product.manufacturer,
                    product.price,
                    product.imageUrl,
                  );
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
