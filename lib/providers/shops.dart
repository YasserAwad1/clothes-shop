import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../providers/shop.dart';

class Shops with ChangeNotifier {
  final String? authToken;
  Shops(this.authToken, this.shops);

  List<Shop> shops = [
    // Shop(
    //   id: 'a',
    //   name: 'American Eagle',
    //   imageUrl:
    //       'https://besthqwallpapers.com/Uploads/11-7-2021/169224/thumb2-american-eagle-outfitters-logo-gray-creative-background-american-eagle-outfitters-emblem-gray-paper-texture-american-eagle-outfitters.jpg',
    // ),
    // Shop(
    //   id: "b",
    //   name: 'Micheal Kors',
    //   imageUrl:
    //       'https://fsa.zobj.net/crop.php?r=1WCS2hojyuhui7FMpXsydcsXaUAU8xwIn35pXdffnA1xfkA8JS53PWqZrOVuvLVH0AbSvQ6kkyXdoMaBOcD8uZx3IeofxGCDvBEqU4545AK41tt4GKFjM0WSw9Gsf28NPtBtHE3b9S19KJaTZ85qfIgiUp0IRr3LnQmBwj6mzxM4r6vV8GHXIdVldWElJIjp6Xt1BgUZ8X-ocF_q',
    // ),
  ];

  List<Shop> get shopsList {
    return [...shops];
  }

  Shop findById(String id) {
    return shops.firstWhere(
      (shop) => shop.id == id,
    );
  }

  Future<void> addShop(Shop shop) async {
    var url = Uri.https(
      'clothes-shop-48bcc-default-rtdb.firebaseio.com',
      '/shops.json',
      {'auth': authToken},
    );
    try {
      final response = await http.post(url,
          body: json.encode(
            {
              'name': shop.name,
              'imageUrl': shop.imageUrl,
            },
          ));
      final newShop = Shop(
        id: json.decode(response.body)['name'],
        name: shop.name,
        imageUrl: shop.imageUrl,
      );
      shops.add(newShop);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchShops() async {
    var url = Uri.https('clothes-shop-48bcc-default-rtdb.firebaseio.com',
        '/shops.json', {'auth': authToken});
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<Shop> loadedShops = [];
      if (extractedData.isEmpty) {
        return;
      }
      extractedData.forEach((shopId, shopData) {
        loadedShops.add(
          Shop(
            id: shopId,
            name: shopData['name'],
            imageUrl: shopData['imageUrl'],
          ),
        );
      });
      shops = loadedShops;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
