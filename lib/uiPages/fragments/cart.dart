import 'package:flutter/material.dart';
import 'package:z_shop/appState.dart';
import 'package:z_shop/uiElements/cartProductCard.dart';

class CartFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: App.cartProducts.isEmpty
                ? Icon(
                    Icons.remove_shopping_cart_outlined,
                    color: Colors.blue[500],
                    size: 100.0,
                  )
                : ListView(
                    children: App.cartProducts
                        .map((e) => CartProductCard(product: e))
                        .toList(),
                  )),
      ),
      floatingActionButton: App.cartProducts.isEmpty ? null :
      FloatingActionButton.extended(
        onPressed: () {},
        label: Text('Place Order'),
        icon: Icon(
            Icons.subdirectory_arrow_right
        ),
      ),
    );
  }
}
