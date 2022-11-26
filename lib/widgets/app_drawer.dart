import 'package:clothes_shop/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/home_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/settings_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color gold = Theme.of(context).colorScheme.secondary;
    final auth = Provider.of<Auth>(context, listen: false);

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: gold,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.black87,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  'https://st2.depositphotos.com/1006318/5909/v/950/depositphotos_59095529-stock-illustration-profile-icon-male-avatar.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            accountName: Text(auth.authUserName!),
            accountEmail: Text(auth.userEmail!),
          ),
          ListTile(
            leading: Icon(
              Icons.home_outlined,
              color: gold,
            ),
            title: const Text('Home'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(HomeScreen.routeName),
          ),
          const Divider(thickness: 2),
          ListTile(
            leading: Icon(
              Icons.shopping_bag_outlined,
              color: gold,
            ),
            title: const Text('My Orders'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routeName),
          ),
          const Divider(thickness: 2),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: gold,
            ),
            title: const Text('Settings'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(SettingsScreen.routeName),
          ),
          const Divider(thickness: 2),
          const Spacer(),
          ListTile(
            leading: Icon(
              Icons.logout_rounded,
              color: Theme.of(context).errorColor,
            ),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              auth.logout();
            },
          ),
        ],
      ),
    );
  }
}
