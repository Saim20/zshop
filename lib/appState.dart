import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:z_shop/services/product.dart';
import 'package:z_shop/uiPages/account.dart';
import 'package:z_shop/uiPages/accountEdit.dart';
import 'package:z_shop/uiPages/cart.dart';
import 'package:z_shop/uiPages/confirmation.dart';
import 'package:z_shop/uiPages/error.dart';
import 'package:z_shop/uiPages/home.dart';
import 'package:z_shop/uiPages/itemList.dart';
import 'package:z_shop/uiPages/login.dart';
import 'package:z_shop/uiPages/orderPage.dart';
import 'package:z_shop/uiPages/orders.dart';
import 'package:z_shop/uiPages/payment.dart';
import 'package:z_shop/uiPages/product.dart';
import 'package:z_shop/uiPages/searchItemList.dart';
import 'package:z_shop/uiPages/signup.dart';
import 'package:z_shop/uiPages/signupOptions.dart';
import 'package:z_shop/uiPages/splash.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

class App extends StatefulWidget {
  static bool isIncompleteSignIn = true;

  static Future<bool> checkIsIncomplete() async {
    var userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (!userSnap.exists) {
      isIncompleteSignIn = true;
      return true;
    }
    isIncompleteSignIn = false;
    return false;
  }

  static bool addToCart(Product? product) {
    bool contains = false;
    for (var cProduct in cartProducts) {
      if (cProduct.id == product!.id) {
        contains = true;
        break;
      }
    }
    if (!contains) {
      if (cartProductsString == '') {
        cartProductsString += product.toString();
      } else {
        cartProductsString += '^' + product.toString();
      }
      App.cartProducts.add(product!);
      App.saveCartProductsToStorage(cartProductsString);
      return true;
    } else
      return false;
  }

  static bool removeFromCart(product) {
    int index = 0;
    for (; index < cartProducts.length; index++) {
      if (cartProducts.elementAt(index).id == product.id) {
        cartProducts.removeAt(index);
        cartProductsString = '';
        for (var prod in cartProducts) {
          if (cartProductsString == '') {
            cartProductsString += prod.toString();
          } else {
            cartProductsString += '^' + prod.toString();
          }
        }
        saveCartProductsToStorage(cartProductsString);
        return true;
      }
    }
    return false;
  }

  static String cartProductsString = '';
  static List<Product> cartProducts = [];

  static void saveCartProductsToStorage(String cartProductsString) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('cartProducts', cartProductsString);
  }

  static void getCartProductsFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('cartProducts') != null &&
        prefs.getString('cartProducts') != '') {
      App.cartProductsString = prefs.getString('cartProducts')!;
      for (var product in prefs
          .getString('cartProducts')!
          .split('^')
          .map((e) => e)
          .toList()) {
        Product prod = Product(productJson: product);
        prod.toProduct();
        App.cartProducts.add(prod);
      }
    }
  }

  static void clearPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static void clearCart() async {
    cartProducts = [];
    cartProductsString = '';
    clearPrefs();
  }

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      await FirebaseAppCheck.instance.activate();
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      print(e);
    }
  }

  @override
  void initState() {
    App.checkIsIncomplete();
    App.getCartProductsFromStorage();
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zshop',
      routes: {
        '/': (context) => SplashPage(),
        '/home': (context) => HomePage(),
        '/account': (context) => AccountPage(),
        '/accountedit': (context) => AccountEditPage(),
        '/details': (context) => ProductDetailsPage(),
        '/products': (context) => ItemListPage(),
        '/search': (context) => SearchItemListPage(),
        '/login': (context) => LoginPage(),
        '/error': (context) => ErrorPage(),
        '/cart': (context) => CartPage(),
        '/orders': (context) => OrdersPage(),
        '/orderpage': (context) => OrderPage(),
        '/signup': (context) => SignupPage(),
        '/payment': (context) => PaymentPage(),
        '/signupoptions': (context) => SignupOptionsPage(),
        '/confirmation': (context) => ConfirmationPage(),
      },
    );
  }
}
