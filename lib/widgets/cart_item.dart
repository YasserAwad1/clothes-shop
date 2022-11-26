import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  String id;
  String itemId;
  String title;
  String storeName;
  double price;
  int quantity;
  String imageUrl;

  CartItem({
    required this.id,
    required this.itemId,
    required this.title,
    required this.storeName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    Color gold = Theme.of(context).colorScheme.secondary;
    var total = price * quantity;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Dismissible(
        key: ValueKey(id),
        background: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).errorColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.delete,
            size: 40,
            color: Colors.white,
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 15),
          margin: const EdgeInsets.all(6),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) => Provider.of<Cart>(
          context,
          listen: false,
        ).removeItem(itemId),
        confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            titlePadding: const EdgeInsets.all(20),
            title: const Text(
              'Are you sure you want to remove item?',
            ),
            content: const Text(
              'This item will be removed from your cart',
            ),
            actionsPadding: const EdgeInsets.all(5),
            contentPadding: const EdgeInsets.all(20),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text(
                  'yes',
                  style: TextStyle(color: gold),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text(
                  'no',
                  style: TextStyle(color: gold),
                ),
              ),
            ],
          ),
        );
      },
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          elevation: 2,
          shadowColor: gold,
          margin: const EdgeInsets.all(5),
          child: ListTile(
            onLongPress: () {
              showDialog(
                context: context,
                builder: (ctx) => SimpleDialog(
                  children: [
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            leading: CircleAvatar(
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text('\$${total.toStringAsFixed(2)}'),
                ),
              ),
              radius: 25,
              backgroundColor: gold,
              foregroundColor: Colors.white,
            ),
            title: Text(title),
            subtitle: Text(
              storeName,
              style: TextStyle(color: gold),
            ),
            trailing: Text(
              '\$${price.toStringAsFixed(2)} x $quantity ',
            ),
          ),
        ),
      ),
    );
  }
}
