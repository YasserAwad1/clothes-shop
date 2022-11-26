import 'package:flutter/material.dart';

import '../screens/favorites_screen.dart';
import '../screens/home_screen.dart';

class MyBottomAppBar extends StatefulWidget {
  bool isHome;
  MyBottomAppBar(this.isHome);
  @override
  State<MyBottomAppBar> createState() => _MyBottomAppBarState();
}

class _MyBottomAppBarState extends State<MyBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        color: Theme.of(context).colorScheme.secondary,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                if(!widget.isHome){
                setState(() {
                  widget.isHome = true;
                });
                  Navigator.of(context).popAndPushNamed(
                    HomeScreen.routeName,
                  );
                }else{
                  null;
                }
                
              },
              icon: widget.isHome
                  ? const Icon(
                      Icons.home,
                      size: 35,
                    )
                  : const Icon(
                      Icons.home_outlined,
                      size: 35,
                    ),
            ),
            IconButton(
                onPressed: () {
                  if(widget.isHome){
                  setState(() {
                    widget.isHome = false;
                  });
                    Navigator.of(context).popAndPushNamed(
                      FavoritesScreen.routeName,
                    );
                  }
                  else{null;}
                },
                icon: widget.isHome
                    ? const Icon(
                        Icons.star_border,
                        size: 35,
                      )
                    : const Icon(
                        Icons.star,
                        size: 35,
                      )),
          ],
        ));
  }
}
