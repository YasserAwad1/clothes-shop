import 'package:clothes_shop/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:backdrop/backdrop.dart';

import '../screens/add_product_screen.dart';
import '../widgets/Products_grid.dart';
import '../providers/shops.dart';
import '../models/category.dart';

class ShopDetailsScreen extends StatefulWidget {
  static const routeName = 'shop_details_screen';
  String? category;

  @override
  State<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen> {
  Category cat = Category.all;
  String? category = 'All';
  var isLoading = false;
  var isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      if (Provider.of<Products>(context).products.isEmpty) {
        setState(() {
          isLoading = false;
        });
      }
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context).fetchProducts().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final String? shopId = routeArgs['shopId'];
    final String? shopName = routeArgs['shopName'];
    Color gold = Theme.of(context).colorScheme.secondary;
    var deviceHeight = MediaQuery.of(context).size.height;

    final loadedShop = Provider.of<Shops>(
      context,
      listen: false,
    ).findById(shopId!);

    return BackdropScaffold(
      appBar: BackdropAppBar(
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.highlight_off_rounded),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(loadedShop.name),
      ),
      headerHeight: deviceHeight * 0.52,
      backLayer: Container(
        width: double.infinity,
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                setState(
                  () {
                    cat = Category.all;
                    category = 'All';
                  },
                );
                Navigator.of(context).maybePop();
              },
              child: const Text(
                'All',
                style: TextStyle(color: Colors.black),
              ),
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  cat = Category.men;
                  category = 'Men';
                });
                Navigator.of(context).maybePop();
              },
              child: const Text(
                'Men',
                style: TextStyle(color: Colors.black),
              ),
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  cat = Category.women;
                  category = 'Women';
                });
                Navigator.of(context).maybePop();
              },
              child: const Text(
                'women',
                style: TextStyle(color: Colors.black),
              ),
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  cat = Category.shoes;
                  category = 'Shoes';
                });
                Navigator.of(context).maybePop();
              },
              child: const Text(
                'shoes',
                style: TextStyle(color: Colors.black),
              ),
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(
                  () {
                    cat = Category.pants;
                    category = 'Pants';
                  },
                );
                Navigator.of(context).maybePop();
              },
              child: const Text(
                'pants',
                style: TextStyle(color: Colors.black),
              ),
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
            ),
          ],
        ),
      ),
      backLayerBackgroundColor: gold,
      subHeader: Center(
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Text(
            category!,
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: gold),
          ),
        ),
      ),
      frontLayer: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: gold,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProductsGrid(
                shopName,
                cat,
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddProductScreen.routeName,
              arguments: {
                'ShopId': loadedShop.id,
                'ShopName': loadedShop.name
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
