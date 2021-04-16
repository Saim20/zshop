import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:z_shop/uiElements/cartProductCard.dart';

class CartFragment extends StatelessWidget {

  CartFragment({this.cartProducts,this.onSelectProduct});

  final ValueChanged<QueryDocumentSnapshot?>? onSelectProduct;
  final List<QueryDocumentSnapshot>? cartProducts;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: cartProducts!.isEmpty? Icon(
          Icons.remove_shopping_cart_outlined,
          color: Colors.blue[500],
          size: 100.0,
        )
              :
            ListView(
              children: cartProducts!.map((e) => CartProductCard(product: e,onSelectProduct: onSelectProduct,)).toList(),
            )
      ),
    );
  }
}