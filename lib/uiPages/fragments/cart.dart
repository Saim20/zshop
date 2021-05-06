import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:z_shop/appState.dart';
import 'package:z_shop/services/order.dart';
import 'package:z_shop/uiElements/cartProductCard.dart';

class CartFragment extends StatefulWidget {
  @override
  _CartFragmentState createState() => _CartFragmentState();
}

class _CartFragmentState extends State<CartFragment> {

  int totalCost = 0;

  void removeProduct(product){
    setState(() {
      App.removeFromCart(product);
    });
  }

  void retrieveProduct(product){
    setState(() {
      App.addToCart(product);
    });
  }

  void calculateTotalCost(bool ok){
    totalCost = 0;
    setState(() {
      App.cartProducts.forEach((element) {
        totalCost += element.offerPrice;
        totalCost += element.setupTaken ? element.setupCost : 0;
        totalCost += element.deliveryTaken ? element.deliveryCost : 0;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    calculateTotalCost(true);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
            child: App.cartProducts.isEmpty
                ? Icon(
                    Icons.remove_shopping_cart_outlined,
                    color: Colors.blue[500],
                    size: 100.0,
                  )
                : ListView(
                    children: [
                      Column(
                      children: App.cartProducts
                          .map((e) => CartProductCard(product: e,productRemover: removeProduct,costCalculator: calculateTotalCost,productRetriever: retrieveProduct,))
                          .toList(),
                      ),
                      SizedBox(height: 50.0,)
                    ]
                  )),
      ),
      floatingActionButton: App.cartProducts.isEmpty ? null :
      FloatingActionButton.extended(
        onPressed: () async {
          if(FirebaseAuth.instance.currentUser != null){
            var user = FirebaseAuth.instance.currentUser;
            var phone = await FirebaseFirestore.instance.collection('users').doc(user!.email).get().then((value) => value.data()!['phone']);
            Order order = Order(userName: user.displayName!, userEmail: user.email!, userPhone: phone, cartProducts: App.cartProducts);
            Navigator.of(context).pushNamed('/confirmation',arguments: {
              'order':order
            });
          } else{
            Navigator.of(context).pushNamed('/login');
          }
        },
        label: Text('Place Order (৳$totalCost)'),
        icon: Icon(
            Icons.subdirectory_arrow_right
        ),
      ),
    );
  }
}
