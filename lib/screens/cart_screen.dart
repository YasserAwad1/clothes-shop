import 'package:clothes_shop/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_item.dart';
import '../providers/cart_provider.dart' show Cart;
import '../providers/order_provider.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart-screen';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var isLoading = false;

  Future<void> onlineAddOrder() async {
    final cartProvider = Provider.of<Cart>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    try {
      await orderProvider
          .addOrder(
            cartProvider.items.values.toList(),
            cartProvider.cartTotal,
          )
          .then((_) => {cartProvider.clearCart()});
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Something went wrong'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  'Okay',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ))
          ],
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final gold = Theme.of(context).colorScheme.secondary;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 30,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                elevation: 5,
                shadowColor: gold,
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Total',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Chip(
                        backgroundColor: gold,
                        label: Text(
                          '\$${cart.cartTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.grey[300]),
                        ),
                        onPressed: () {
                          if (cart.items.isNotEmpty) {
                            onlineAddOrder();
                          } else if (cart.items.isEmpty || isLoading) {
                            showDialog(
                              context: context,
                              builder: (ctx) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AlertDialog(
                                  title: const Text('Your cart is Empty'),
                                  content: const Text(
                                    'Start adding products to your cart!',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'okay',
                                        style: TextStyle(color: gold),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).popAndPushNamed(
                                            HomeScreen.routeName);
                                      },
                                      child: Text(
                                        'Go to shops',
                                        style: TextStyle(color: gold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                        child: isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: gold,
                                ),
                              )
                            : Text(
                                'Order Now',
                                style: TextStyle(color: gold),
                              ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (ctx, i) => CartItem(
                  id: cart.items.values.toList()[i].id,
                  itemId: cart.items.keys.toList()[i],
                  title: cart.items.values.toList()[i].title,
                  storeName: cart.items.values.toList()[i].storeName,
                  price: cart.items.values.toList()[i].price,
                  quantity: cart.items.values.toList()[i].quantity,
                  imageUrl: cart.items.values.toList()[i].imageUrl,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
