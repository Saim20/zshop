import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:z_shop/uiPages/error.dart';
import 'package:z_shop/uiPages/home.dart';
import 'package:z_shop/uiPages/login.dart';
import 'package:z_shop/uiPages/product.dart';
import 'package:z_shop/uiPages/registration.dart';
import 'package:z_shop/uiPages/splash.dart';

class AppState extends StatefulWidget {
  @override
  _AppStateState createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {

  QueryDocumentSnapshot? selectedProduct;
  List<QueryDocumentSnapshot> cartProducts = [];
  bool accountClicked = false;
  bool registrationClicked = false;

  void onSelectProduct(product){
    setState(() {
      selectedProduct = product;
    });
  }
  void onAccountIconClick(accountCheck){
    setState(() {
      accountClicked = accountCheck;
    });
  }
  void addProductToCart(product){
    setState(() {
      if(!cartProducts.contains(product))
        cartProducts.add(product);
    });
  }
  void onRegistrationClick(really){
    setState(() {
      registrationClicked = really;
    });
  }

  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        print(e);
        _error = true;
      });
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
      home: WillPopScope(
        onWillPop: () async => !await _navigatorKey.currentState!.maybePop(),
        child: Navigator(
          key: _navigatorKey,
          onPopPage: (route, result) {
            if (!route.didPop(result)) return false;
            if(accountClicked) accountClicked = false;
            else if(registrationClicked) registrationClicked = false;
            else if(selectedProduct != null) selectedProduct = null;
            return true;
          },
          pages: [
            if(!_initialized)
            MaterialPage(key: ValueKey('splash'),child: SplashPage()),
            if(_error)
              MaterialPage(key: ValueKey('error'),child: ErrorPage()),
            if(_initialized)
              MaterialPage(key: ValueKey('home'), child: HomePage(onSelectProduct: onSelectProduct,onAccountIconClick: onAccountIconClick,cartProducts: cartProducts,)),
            if(selectedProduct != null)
              MaterialPage(key: ValueKey(selectedProduct!.id), child: ProductDetailsPage(product: selectedProduct,addProduct: addProductToCart,)),
            if(accountClicked)
              MaterialPage(key: ValueKey('login'),child: LoginPage(onRegistrationClick: onRegistrationClick,)),
            if(registrationClicked)
              MaterialPage(key: ValueKey('registration'),child: RegistrationPage())
          ],
        ),
      ),
    );
  }
}