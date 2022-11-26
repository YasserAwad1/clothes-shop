import 'package:clothes_shop/providers/order_provider.dart';
import 'package:clothes_shop/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/cart_provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders-screen';

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var isLoading = false;
  var isInit = true;

  // Future<void> refresh(BuildContext ctx) async {
  //   Provider.of<OrderProvider>(ctx, listen: false).tryRefresh();
  // }

  @override
  Widget build(BuildContext context) {
    Color gold = Theme.of(context).colorScheme.secondary;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: gold,
        title: const Text('My Orders'),
        leading: IconButton(
          icon: const Icon(Icons.clear_all_rounded),
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future:
            Provider.of<OrderProvider>(context, listen: false).fetchOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            );
          } else if (Provider.of<OrderProvider>(context).orders.isEmpty) {
            return const Center(
              child: Text('No orders yet!'),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<OrderProvider>(
                builder: (ctx, orderProvider, chlid) => ListView.builder(
                      itemCount: orderProvider.orders.length,
                      itemBuilder: (ctx, i) => OrderItem(
                        orderProvider.orders[i],
                      ),
                    )),
          );
        },
      ),
    );
  }
}
