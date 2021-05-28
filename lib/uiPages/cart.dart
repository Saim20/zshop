import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:z_shop/appState.dart';
import 'package:z_shop/services/order.dart';
import 'package:z_shop/uiElements/cartProductCard.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int totalCost = 0;

  void removeProduct(product) {
    setState(() {
      App.removeFromCart(product);
    });
  }

  void retrieveProduct(product) {
    setState(() {
      App.addToCart(product);
    });
  }

  void calculateTotalCost(bool ok) {
    totalCost = 0;
    setState(() {
      App.cartProducts.forEach((element) {
        totalCost += element.offerPrice;
        totalCost += element.setupTaken ? element.setupCost : 0;
        totalCost += element.deliveryTaken ? element.deliveryCost : 0;
        totalCost *= element.quantity;
      });
    });
  }

  void clearCart() {
    setState(() {
      App.clearCart();
    });
  }

  @override
  Widget build(BuildContext context) {

    var data;
    if (ModalRoute.of(context)!.settings.arguments != null)
      data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    else
      data = {'fromAccount': false};
    bool fromAccount = data['fromAccount'] ?? false;

    calculateTotalCost(true);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          iconTheme: IconThemeData(color: Colors.blue),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text(
            'Cart',
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w300,
                fontSize: 35.0),
          ),
          actions: [
            IconButton(
                icon: Hero(
                  tag: 'accountHero',
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.blue,
                    size: 30.0,
                  ),
                ),
                onPressed: () {
                  if(fromAccount)
                  Navigator.of(context)
                      .pushReplacementNamed('/account', arguments: {'fromCart': true});
                  else
                    Navigator.of(context)
                        .pushNamed('/account', arguments: {'fromCart': true});
                })
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
            child: App.cartProducts.isEmpty
                ? Icon(
                    Icons.remove_shopping_cart_outlined,
                    color: Colors.blue[500],
                    size: 100.0,
                  )
                : ListView(children: [
                    Column(
                      children: App.cartProducts
                          .map((e) => CartProductCard(
                                product: e,
                                productRemover: removeProduct,
                                costCalculator: calculateTotalCost,
                                productRetriever: retrieveProduct,
                              ))
                          .toList(),
                    ),
                    SizedBox(
                      height: 50.0,
                    )
                  ])),
      ),
      floatingActionButton: App.cartProducts.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () async {
                if (FirebaseAuth.instance.currentUser != null) {
                  var user = FirebaseAuth.instance.currentUser;
                  var phone = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.email)
                      .get()
                      .then((value) => value.data()!['phone']);
                  var address = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.email)
                      .get()
                      .then((value) => value.data()!['address']);
                  Order order = Order(
                      userName: user.displayName!,
                      userEmail: user.email!,
                      userPhone: phone,
                      userAddress: address,
                      totalCost: totalCost,
                      cartProducts: App.cartProducts);
                  Navigator.of(context).pushNamed('/confirmation',
                      arguments: {'order': order, 'clearcart': clearCart});
                } else {
                  Navigator.of(context).pushNamed('/login');
                }
              },
              label: Text('Place Order (৳$totalCost)'),
              icon: Icon(Icons.subdirectory_arrow_right),
            ),
    );
  }
}
