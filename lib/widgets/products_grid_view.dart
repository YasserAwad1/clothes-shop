import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../providers/product.dart';
import '../widgets/product_item.dart';

class prdouctGridView extends StatelessWidget {
  const prdouctGridView({
    required this.filteredProducts,
  });

  final List<Product> filteredProducts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (filteredProducts.isNotEmpty)
          CarouselSlider.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (ctx, i, e) => Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 2,
                      color: Theme.of(context).colorScheme.secondary,
                    )),
                child: ClipRRect(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      filteredProducts[i].imageUrl,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(10),
                )),
            options: CarouselOptions(
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              autoPlay: true,
            ),
          ),
        const SizedBox(
          height: 15,
        ),
        Expanded(
          child: GridView.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: filteredProducts[i],
              child: ProductItem(),
            ),
            // itemCount: filteredProducts.length,
            // itemBuilder: (ctx, i) => ProductItem(
            //   id: filteredProducts[i].id,
            //   title: filteredProducts[i].title,
            //   imageUrl: filteredProducts[i].imageUrl,
            //   manufacturer: filteredProducts[i].manufacturer,
            //   price: filteredProducts[i].price,
            // ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
            ),
          ),
        ),
      ],
    );
  }
}
