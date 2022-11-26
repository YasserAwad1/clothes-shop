import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/shop_widget.dart';
import '../widgets/bottom_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/top_app_bar.dart';
import '../providers/shops.dart';
import '../screens/add_shop_screen.dart';
import '../providers/auth.dart';

class HomeScreen extends StatefulWidget with ChangeNotifier {
  static const routeName = '/home-screen';
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final isHome = true;
  var isInit = true;
  var isLoading = false;

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Auth>(context).fetchUserName();
      Provider.of<Shops>(context).fetchShops().then((_) {
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
    final shopsData = Provider.of<Shops>(context, listen: false);
    final shops = shopsData.shopsList;
    var deviceHeight = MediaQuery.of(context).size.height;
    Color gold = Theme.of(context).colorScheme.secondary;
    return SafeArea(
      child: Scaffold(
        key: widget.scaffoldKey,
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: gold,
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child:
                    Column(
                  children: [
                    TopAppBar(widget.scaffoldKey),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: deviceHeight * 0.18,
                          child: const Text(
                            'Pick your favorite shop!',
                            style: TextStyle(
                              fontSize: 48,
                              fontFamily: 'PORKYS_',
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: SizedBox(
                        height: deviceHeight * 0.61,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: shops.length,
                          itemBuilder: (ctx, i) => ShopWidget(
                            id: shops[i].id,
                            shopName: shops[i].name,
                            imageUrl: shops[i].imageUrl,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        drawer: AppDrawer(),
        floatingActionButton: Tooltip(
          message: 'Add a new shop ',
          child: FloatingActionButton(
            child: const Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(AddShopScreen.routeName);
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: SizedBox(
          height: deviceHeight * 0.068,
          child: MyBottomAppBar(isHome),
        ),
      ),
    );
  }
}
