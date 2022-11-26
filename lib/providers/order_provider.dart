import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/order_model.dart';
import '../models/cart_model.dart';

class OrderProvider with ChangeNotifier {
  final String? authToken;
  final String? userId;
  OrderProvider(this.authToken, this.userId, this._orders);

  List<OrderModel> _orders = [];

  List<OrderModel> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartModel> cartProducts, double total) async {
    var url = Uri.https(
      'clothes-shop-48bcc-default-rtdb.firebaseio.com',
      '/orders/$userId.json',
      {'auth': authToken},
    );
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'cartProducts': cartProducts
                .map(
                  (prod) => {
                    'id': prod.id,
                    'title': prod.title,
                    'storeName': prod.storeName,
                    'price': prod.price,
                    'quantity': prod.quantity,
                    'imageUrl': prod.imageUrl,
                  },
                )
                .toList(),
            'date': timeStamp.toIso8601String(),
            'total': total,
          }));
      _orders.insert(
        0,
        OrderModel(
          json.decode(response.body)['name'],
          cartProducts,
          timeStamp,
          total,
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchOrders() async {
    var url = Uri.https(
      'clothes-shop-48bcc-default-rtdb.firebaseio.com',
      '/orders/$userId.json',
      {'auth': authToken},
    );

    try {
      final response = await http.get(url);
      final List<OrderModel> loadedOrders = [];
      var extractedData = json.decode(response.body) as Map<String, dynamic>;
      //print(extractedData);
      if (extractedData.isEmpty) {
        return;
      }
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderModel(
            orderId,
            (orderData['cartProducts'] as List<dynamic>)
                .map(
                  (prod) => CartModel(
                      prod['id'],
                      prod['title'],
                      prod['storeName'],
                      prod['price'],
                      prod['quantity'],
                      prod['imageUrl']),
                )
                .toList(),
            DateTime.parse(orderData['date']),
            orderData['total'],
          ),
        );
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

//   Future<void> tryRefresh() async {
//     var url = Uri.https('clothes-shop-48bcc-default-rtdb.firebaseio.com',
//         '/orders/$userId.json');
//     final response = await http.get(url);
//     try {
//       final extractedOrders = json.decode(response.body) as List<OrderModel>;
//       if (extractedOrders == orders) {
//         return;
//       }
//       if (extractedOrders.isEmpty) {
//         orders.clear();
//         notifyListeners();
//       } else {
//         await fetchOrders();
//         notifyListeners();
//       }
//     } catch (error) {
//       rethrow;
//     }
//   }
 }
