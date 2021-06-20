import 'package:flutter/material.dart';

class InitPage extends StatelessWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
