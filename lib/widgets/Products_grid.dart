
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/products_grid_view.dart';
import '../models/category.dart' as myenum;

class ProductsGrid extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final shopName;
  final cat;

  // ignore: use_key_in_widget_constructors
  const ProductsGrid(this.shopName, this.cat);

  @override
  Widget build(BuildContext context) {
    final productsList = Provider.of<Products>(context);
    final filteredProducts = productsList.products.where((product) {
      return product.manufacturer.contains(
        shopName.toString(),
      );
    }).toList();

    if (cat == myenum.Category.all) {
      return prdouctGridView(filteredProducts: filteredProducts);
    } else if (cat == myenum.Category.men) {
      final categoryProducts = filteredProducts.where((product) {
        return product.categories.contains('Men');
      }).toList();
      return prdouctGridView(filteredProducts: categoryProducts);
    } else if (cat == myenum.Category.women) {
      final categoryProducts = filteredProducts.where((product) {
        return product.categories.contains('Women');
      }).toList();
      return prdouctGridView(filteredProducts: categoryProducts);
    } else if (cat == myenum.Category.shoes) {
      final categoryProducts = filteredProducts.where((product) {
        return product.categories.contains('Shoes');
      }).toList();
      return prdouctGridView(filteredProducts: categoryProducts);
    } else if (cat == myenum.Category.pants) {
      final categoryProducts = filteredProducts.where((product) {
        return product.categories.contains('Pants');
      }).toList();
      return prdouctGridView(filteredProducts: categoryProducts);
    } else {
      return const Center(
        child: Text(
          'no items found',
        ),
      );
    }
  }
}
