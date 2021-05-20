import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  void goHome(context) async {
    await Future.delayed(Duration(seconds: 1))
        .then((value) {Navigator.pushReplacementNamed(context, '/home');});
  }

  @override
  Widget build(BuildContext context) {
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
