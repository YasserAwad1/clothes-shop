import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/order_provider.dart';
import '../models/order_model.dart';

class OrderItem extends StatefulWidget {
  OrderModel order;

  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var isExpanded = false;
  @override
  Widget build(BuildContext context) {
    Color gold = Theme.of(context).colorScheme.secondary;
    return Card(
      shadowColor: gold,
      elevation: 3,
      child: Column(
        children: [
          ListTile(
            title: Text(
              '\$${widget.order.total.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm a').format(widget.order.date),
              style: TextStyle(color: gold),
            ),
            trailing: IconButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                icon: Icon(
                  isExpanded ? Icons.expand_less_rounded :Icons.expand_more_rounded,
                  color: gold,
                )),
          ),
          if (isExpanded)
            SizedBox(
              height: min(widget.order.products.length * 20.0 + 10, 100),
              child: Padding(
                padding: const EdgeInsets.symmetric( horizontal: 15),
                child: ListView(
                  children: widget.order.products
                      .map(
                        (product) => Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(product.title),
                                Text('x ${product.quantity}')
                              ],
                            ),
                            if(widget.order.products.length > 1)
                            Divider(thickness: 1, color: gold,),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
