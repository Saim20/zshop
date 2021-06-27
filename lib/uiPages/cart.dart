import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:z_shop/appState.dart';
import 'package:z_shop/data/data.dart';
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
          iconTheme: IconThemeData(color: accentColor),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text(
            'Cart',
            style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.w300,
                fontSize: 35.0),
          ),
          actions: [
            if (FirebaseAuth.instance.currentUser != null)
              IconButton(
                tooltip: 'Orders',
                icon: Hero(
                  tag: 'orderHero',
                  child: Icon(
                    orderIcon,
                    color: orderColor,
                    size: 30.0,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/orders');
                },
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: IconButton(
                  icon: Hero(
                    tag: 'accountHero',
                    child: Icon(
                      accountIcon,
                      color: accountColor,
                      size: 30.0,
                    ),
                  ),
                  onPressed: () {
                    if (fromAccount)
                      Navigator.of(context).pushReplacementNamed('/account',
                          arguments: {'fromCart': true});
                    else
                      Navigator.of(context)
                          .pushNamed('/account', arguments: {'fromCart': true});
                  }),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: App.cartProducts.isEmpty
              ? Icon(
                  Icons.remove_shopping_cart_outlined,
                  color: accentColor,
                  size: 100.0,
                )
              : ListView(
                  children: [
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
                    Container(
                      margin: EdgeInsets.all(70.0),
                      height: 50.0,
                      child: ElevatedButton.icon(
                        label: Text('(৳$totalCost) Place Order'),
                        icon: Icon(Icons.subdirectory_arrow_right),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          print(FirebaseAuth.instance.currentUser == null);
                          print(App.isIncompleteSignIn);
                          if (FirebaseAuth.instance.currentUser != null &&
                              !App.isIncompleteSignIn) {
                            var user = FirebaseAuth.instance.currentUser;
                            var doc = await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user!.uid)
                                .get()
                                .then((value) => value);
                            var phone =
                                doc.data() == null ? '' : doc.data()!['phone'];
                            var address = doc.data() == null
                                ? ''
                                : doc.data()!['address'];
                            Order order = Order(
                                userName: user.displayName!,
                                userEmail: user.email!,
                                userId: user.uid,
                                userPhone: phone,
                                userAddress: address,
                                paymentStatus: 'Unpaid',
                                paymentMethod: 'COD',
                                totalCost: totalCost,
                                cartProducts: App.cartProducts);
                            Navigator.of(context).pushNamed('/confirmation',
                                arguments: {
                                  'order': order,
                                  'clearcart': clearCart
                                });
                          } else {
                            Navigator.of(context).pushNamed('/account');
                          }
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
