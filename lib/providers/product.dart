import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String manufacturer;
  final String imageUrl;
  final String title;
  final double price;
  bool isFavorite;
  List categories = ['Men', 'Women', 'Shoes', 'Pants'];

  Product({
    required this.id,
    required this.manufacturer,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.categories,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    var oldSatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    var url = Uri.https(
      'clothes-shop-48bcc-default-rtdb.firebaseio.com',
      '/userFavorites/$userId/$id.json',
      {'auth': authToken},
    );
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavorite,
          ));
      if (response.statusCode >= 400) {
        isFavorite = oldSatus;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldSatus;
      notifyListeners();
    }
  }
}
