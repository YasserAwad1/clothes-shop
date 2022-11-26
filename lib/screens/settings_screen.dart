import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings-screen';
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          leading: IconButton(
            icon: const Icon(Icons.clear_all_rounded),
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
          )),
      drawer: AppDrawer(),
      body: Center(child: Text('add your settings')),
    );
  }
}
