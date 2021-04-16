import 'package:flutter/material.dart';

class CartFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Icon(
          Icons.shopping_cart,
          color: Colors.blue[500],
          size: 100.0,
        ),
      ),
    );
  }
}