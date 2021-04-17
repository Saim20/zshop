import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:z_shop/uiPages/account.dart';
import 'package:z_shop/uiPages/error.dart';
import 'package:z_shop/uiPages/home.dart';
import 'package:z_shop/uiPages/login.dart';
import 'package:z_shop/uiPages/product.dart';
import 'package:z_shop/uiPages/signup.dart';
import 'package:z_shop/uiPages/splash.dart';

class App extends StatefulWidget {

  static bool addToCart(product){
    if(!App.cartProducts.contains(product))
    {
      App.cartProducts.add(product!);
      return true;
    }
    else
      return false;
  }

  static List<QueryDocumentSnapshot> cartProducts = [];

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {


  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      print(e);
    }
  }

  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zshop',
      routes: {
        '/' : (context) => SplashPage(),
        '/home' : (context) => HomePage(),
        '/account' : (context) => AccountPage(),
        '/details' : (context) => ProductDetailsPage(),
        '/login' : (context) => LoginPage(),
        '/error' : (context) => ErrorPage(),
        '/signup' : (context) => SignupPage(),
      },
    );
  }
}