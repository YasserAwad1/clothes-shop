import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color gold = Theme.of(context).colorScheme.secondary;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              gold,
              gold.withOpacity(0.2),
              Colors.black,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0, 0.5, 1],
          ),
        ),
        child: const Center(
          child: Text(
            'Loading...',
            style: TextStyle(fontFamily: 'PORKYS_', fontSize: 30),
          ),
        ),
      ),
    );
  }
}
