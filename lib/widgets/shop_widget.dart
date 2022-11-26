import 'package:flutter/material.dart';

import '../screens/shop_details_screen.dart';


class ShopWidget extends StatelessWidget {
  ShopWidget({
    required this.id,
    required this.shopName,
    required this.imageUrl,
  });

  final String id;
  final String shopName;
  final String imageUrl;
  
  @override
  Widget build(BuildContext context) {
    Color gold = Theme.of(context).colorScheme.secondary;
    var deviceHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                ShopDetailsScreen.routeName,
                arguments: {
                  'shopId': id,
                  'shopName': shopName,
                },
              ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 3,
                      color: gold,
                    )),
                width: 200,
                height: deviceHeight * 0.58,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: gold,
                          spreadRadius: 2.5,
                          blurRadius: 15,
                        ),
                      ]),
                      width: 200,
                      height: deviceHeight * 0.58,
                      child: ClipRRect(
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        height: 400,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              shopName,
                              style: TextStyle(
                                  color:
                                      gold,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
