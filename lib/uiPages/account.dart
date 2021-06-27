import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:z_shop/appState.dart';
import 'package:z_shop/data/data.dart';
import 'package:z_shop/services/user.dart';
import 'package:z_shop/uiElements/loadingWidget.dart';
import 'package:z_shop/uiPages/login.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  FirebaseAuth authInstance = FirebaseAuth.instance;
  bool? signedIn;
  bool incompleteGoogleSignin = false;
  ZshopUser zuser = ZshopUser();
  DocumentSnapshot? userSnap;

  void signOut() {
    FirebaseAuth.instance.signOut();
    signedIn = false;
    Navigator.of(context).pop();
  }

  void completeSignIn(really) {
    setState(() {
      incompleteGoogleSignin = false;
      signedIn = true;
    });
  }

  Future<bool> setUser(User user) async {
    userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    zuser.name = user.displayName!;
    zuser.email = user.email!;
    if (userSnap!.exists) {
      App.isIncompleteSignIn = false;
      zuser.phone = userSnap!.data()!['phone'];
      zuser.address = userSnap!.data()!['address'];
    } else {
      incompleteGoogleSignin = true;
      App.isIncompleteSignIn = true;
    }
    return true;
  }

  @override
  void initState() {
    authInstance.authStateChanges().listen((user) async {
      if (user == null) {
        if(mounted)
        setState(() {
          signedIn = false;
        });
      } else {
        await setUser(user);
        if(mounted)
        setState(() {
          if (incompleteGoogleSignin) {
            signedIn = false;
          } else
            signedIn = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data;
    if (ModalRoute.of(context)!.settings.arguments != null)
      data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    else
      data = {'fromCart': false};
    bool fromCart = data['fromCart'] ?? false;

    if (signedIn == null) {
      return LoadingWidget();
    }
    return (signedIn! && !incompleteGoogleSignin)
        ? Account(
            signOut: signOut,
            user: zuser,
            fromCart: fromCart,
          )
        : LoginPage(
            isIncomplete: incompleteGoogleSignin,
            completeSignin: completeSignIn);
  }
}

class Account extends StatelessWidget {
  Account({required this.signOut, required this.user, this.fromCart: false});

  final ZshopUser user;
  final Function signOut;
  final bool fromCart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: AppBar(
            iconTheme: IconThemeData(color: accentColor),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text(
              'Account',
              style: TextStyle(
                fontSize: 35.0,
                color: accentColor,
                fontWeight: FontWeight.w300,
              ),
            ),
            actions: [
              IconButton(
                tooltip: 'Cart',
                icon: Icon(
                  cartIcon,
                  color: cartColor,
                  size: 30.0,
                ),
                onPressed: () {
                  if (fromCart)
                    Navigator.of(context).pushReplacementNamed('/cart',
                        arguments: {'fromAccount': true});
                  else
                    Navigator.of(context)
                        .pushNamed('/cart', arguments: {'fromAccount': true});
                },
              ),
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
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: ListView(
        children: [
          SizedBox(
            height: 20.0,
          ),
          Center(
            child: SizedBox(
              height: 150.0,
              width: 150.0,
              child: Hero(
                tag: 'accountHero',
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/user.png'),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
            child: Text(
              user.name,
              style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.w300),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 10.0),
            child: Text(
              user.email,
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 10.0),
            child: Text(
              user.phone,
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 10.0),
            child: Text(
              user.address,
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 10.0),
            child: ElevatedButton.icon(
                onPressed: () {
                  signOut();
                },
                icon: Icon(Icons.logout),
                label: Text('Logout')),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            '/accountedit',
            arguments: {'user': user},
          );
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
