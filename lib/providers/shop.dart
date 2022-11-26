import 'package:flutter/cupertino.dart';

class Shop with ChangeNotifier{
  String id;
  String name;
  String imageUrl;

  Shop({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}
