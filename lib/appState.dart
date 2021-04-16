import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:z_shop/uiPages/error.dart';
import 'package:z_shop/uiPages/home.dart';
import 'package:z_shop/uiPages/login.dart';
import 'package:z_shop/uiPages/product.dart';
import 'package:z_shop/uiPages/splash.dart';

class AppState extends StatefulWidget {
  @override
  _AppStateState createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {

  QueryDocumentSnapshot? selectedProduct;
  bool inAccount = false;

  void onSelectProduct(product){
    setState(() {
      selectedProduct = product;
    });
  }
  void onAccountIconClick(accountCheck){
    setState(() {
      inAccount = accountCheck;
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
      // routeInformationParser: VxInformationParser(),
      // routerDelegate: VxNavigator(
      //     notFoundPage: (uri, params) => MaterialPage(
      //       key: ValueKey('not-found-page'),
      //       child: Builder(
      //         builder: (context) => Scaffold(
      //           body: Center(
      //             child: Text('Page ${uri.path} not found'),
      //           ),
      //         ),
      //       ),
      //     ),
      //   routes: {
      //     '/' : (_,__) => !_initialized ? MaterialPage(child: SplashPage()) : MaterialPage(child: HomePage()),
      //     DetailsPath : (_, params) => MaterialPage(child: ProductDetailsPage(product: params,)),
      //     LoginPath : (_, __ ) => MaterialPage(child: LoginPage())
      //   }
      // ),
      home: WillPopScope(
        onWillPop: () async => !await _navigatorKey.currentState!.maybePop(),
        child: Navigator(
          key: _navigatorKey,
          onPopPage: (route, result) {
            if (!route.didPop(result)) return false;
            if(inAccount) inAccount = false;
            else if(selectedProduct != null) selectedProduct = null;
            return true;
          },
          pages: [
            if(!_initialized)
            MaterialPage(key: ValueKey('splash'),child: SplashPage()),
            if(_error)
              MaterialPage(key: ValueKey('error'),child: ErrorPage()),
            if(_initialized)
              MaterialPage(key: ValueKey('home'), child: HomePage(onSelectProduct: onSelectProduct,onAccountIconClick: onAccountIconClick,)),
            if(selectedProduct != null)
              MaterialPage(key: ValueKey('product'), child: ProductDetailsPage(product: selectedProduct,)),
            if(inAccount)
              MaterialPage(key: ValueKey('login'),child: LoginPage()),
          ],
        ),
      ),
    );
  }
}