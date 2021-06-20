import 'package:flutter/material.dart';
import 'package:z_shop/appState.dart';

class SplashPage extends StatelessWidget {
  void goHome(context) async {
    await Future.delayed(Duration(seconds: 1)).then((value) {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    App.getCartProductsFromStorage();
    goHome(context);

    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Image.asset(
          'assets/images/zshop_logo.png',
          height: 100.0,
        ),
      ),
    ));
  }
}
