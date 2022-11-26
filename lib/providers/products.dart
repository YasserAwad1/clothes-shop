import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class Products with ChangeNotifier {
  final String? authToken;
  final String? userId;
  Products(this.authToken, this.userId, this._products);

  List<Product> _products = [
    // Product(
    //   id: '1',
    //   manufacturer: 'American Eagle',
    //   imageUrl:
    //       'https://americaneagle.online/wp-content/uploads/2017/07/AE-T-shirt-Front-Mockup-Men-.jpg',
    //   title: 'shirt men',
    //   price: 22.457,
    //   categories: ['Men'],
    // ),
    // Product(
    //   id: '2',
    //   manufacturer: 'Micheal Kors',
    //   imageUrl:
    //       'https://images.ikrix.com/product_images/original/michael-kors-t-shirts-chain-logo-t-shirt-00000237630f00s001.jpg',
    //   title: 'chain logo T-Shirt',
    //   price: 12.54,
    //   categories: ['Women'],
    // ),
    // Product(
    //   id: '3',
    //   manufacturer: 'American Eagle',
    //   imageUrl:
    //       'https://m.media-amazon.com/images/I/61M9K0JF8bL._AC_UX679_.jpg',
    //   title: 'long sleeved shirt',
    //   price: 34.587,
    //   categories: ['Men'],
    // ),
    // Product(
    //   id: '4',
    //   manufacturer: 'American Eagle',
    //   imageUrl:
    //       'https://m.media-amazon.com/images/I/51N6YHeigOS._AC_SY580_.jpg',
    //   title: 'sport pants',
    //   price: 21.55,
    //   categories: ['Pants', 'Men'],
    // ),
    // Product(
    //   id: '5',
    //   manufacturer: 'American Eagle',
    //   imageUrl:
    //       'https://paylessus.vtexassets.com/arquivos/ids/219458-800-800?v=637572182932500000&width=800&height=800&aspect=true.jpg',
    //   title: 'sandals',
    //   price: 55.99,
    //   categories: ['Shoes', 'Women'],
    // ),
    // Product(
    //   id: '6',
    //   manufacturer: 'Micheal Kors',
    //   imageUrl:
    //       'https://cdna.lystit.com/200/250/tr/photos/mainline/be997756/michael-kors-White-Long-Sleeved-Logo-Shirt.jpeg',
    //   title: 'shirt',
    //   price: 45.54,
    //   categories: ['Women'],
    // ),
    // Product(
    //   id: '7',
    //   manufacturer: 'Micheal Kors',
    //   imageUrl:
    //       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT3nyCkAYfdy80a1PFkebFFMIB9EGCD8vHqRg&usqp=CAU',
    //   title: 'Kors',
    //   price: 45.54,
    //   categories: ['Men'],
    // ),
  ];

  List<Product> get products {
    return [..._products];
  }

  Product findByManufacturer(String storeName) {
    return products.firstWhere(
      (product) => product.manufacturer == storeName,
    );
  }

  List<Product> get favoriteItems {
    return _products.where((product) => product.isFavorite).toList();
  }

  Future<void> addProduct(Product product) async {
    var url = Uri.https(
      'clothes-shop-48bcc-default-rtdb.firebaseio.com',
      '/products.json',
      {'auth': authToken},
    );
    try {
      final response = await http.post(url,
          body: json.encode({
            'manufacturer': product.manufacturer,
            'imageUrl': product.imageUrl,
            'title': product.title,
            'price': product.price,
            'categories': product.categories,
          }));
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        manufacturer: product.manufacturer,
        imageUrl: product.imageUrl,
        title: product.title,
        price: product.price,
        categories: product.categories,
      );

      _products.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchProducts() async {
    var url = Uri.https(
      'clothes-shop-48bcc-default-rtdb.firebaseio.com',
      '/products.json',
      {'auth': authToken},
    );
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData.isEmpty) {
        return;
      }
      var userFavoritesUrl = Uri.https(
        'clothes-shop-48bcc-default-rtdb.firebaseio.com',
        '/userFavorites/$userId.json',
        {'auth': authToken},
      );
      final favoritesResponse = await http.get(userFavoritesUrl);
      final favoritesData = json.decode(favoritesResponse.body);
      // print(json.decode(favoritesResponse.body));
      extractedData.forEach(
        (productId, productData) {
          loadedProducts.add(
            Product(
              id: productId,
              manufacturer: productData['manufacturer'],
              imageUrl: productData['imageUrl'],
              title: productData['title'],
              price: productData['price'],
              categories: productData['categories'],
              isFavorite: favoritesData == null
                  ? false
                  : favoritesData[productId] ?? false,
            ),
          );
        },
      );
      _products = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
