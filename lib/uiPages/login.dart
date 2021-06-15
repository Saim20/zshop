import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:z_shop/data/data.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.isIncomplete, this.completeSignin});

  final bool? isIncomplete;
  final ValueChanged<bool>? completeSignin;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isIncomplete = false;

  @override
  Widget build(BuildContext context) {
    isIncomplete = widget.isIncomplete ?? false;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.blue[100]!,
              Colors.blue[200]!,
              Colors.blue[300]!,
              Colors.blue[400]!,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            SizedBox(height: 100),
            createTitle(isIncomplete),
            SizedBox(height: 100),
            MyCustomForm(
              isIncomplete: isIncomplete,
              completeSignin: widget.completeSignin,
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      )),
    );
  }
}

Widget createTitle(isIncomplete) {
  return Center(
    child: Text(
      isIncomplete ? 'Complete Account' : 'Login',
      style: TextStyle(
          fontSize: 50.0, fontWeight: FontWeight.w200, color: accentColor),
    ),
  );
}

class MyCustomForm extends StatefulWidget {
  MyCustomForm({this.isIncomplete, this.completeSignin});

  final bool? isIncomplete;
  final ValueChanged<bool>? completeSignin;

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  bool userNotFound = false;
  bool passwordIsWrong = false;
  bool emailIsInvalid = false;

  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Container(
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 600
                  : 500,
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailC,
                onChanged: (value) {
                  userNotFound = false;
                  emailIsInvalid = false;
                },
                cursorColor: Colors.grey[800],
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    labelText: widget.isIncomplete! ? 'Phone' : 'E-mail'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return widget.isIncomplete!
                        ? 'Please enter your phone number'
                        : 'Please enter your email';
                  } else if (userNotFound) {
                    return 'No user found with this e-mail';
                  } else if (emailIsInvalid) {
                    return 'Please enter a valid e-mail';
                  }
                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Container(
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 600
                  : 500,
              child: TextFormField(
                obscureText: widget.isIncomplete! ? false : true,
                enableSuggestions: widget.isIncomplete! ? true : false,
                autocorrect: widget.isIncomplete! ? true : false,
                onChanged: (value) {
                  passwordIsWrong = false;
                },
                controller: passC,
                keyboardType: TextInputType.visiblePassword,
                cursorColor: Colors.grey[800],
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    labelText:
                        widget.isIncomplete! ? 'Shipping Address' : 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return widget.isIncomplete!
                        ? 'Please enter your shipping address'
                        : 'Please enter you password';
                  else if (passwordIsWrong) {
                    return 'Wrong password';
                  }
                  return null;
                },
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(accentColor),
                  ),
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      if (!widget.isIncomplete!) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Logging in')));
                        signInWithEmailAndPass(emailC.text, passC.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Completing account')));
                        completeAccount(emailC.text, passC.text);
                      }
                    }
                  },
                  child: Text(
                    widget.isIncomplete! ? 'Submit' : 'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              if (!widget.isIncomplete!)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextButton(
                    child: Text(
                      'Or Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/signupoptions');
                    },
                  ),
                ),
              if (!widget.isIncomplete!)
                Container(
                  margin: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 0.0),
                  child: SignInButton(
                    Buttons.Google,
                    onPressed: () async {
                      await signInWithGoogle();
                    },
                    text: 'Sign in with Google',
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }

  void completeAccount(phone, address) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'phone': phone,
      'address': address,
    });
    widget.completeSignin!(true);
  }

  void signInWithEmailAndPass(email, pass) async {
    String userEmail = email;
    String userPass = pass;

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: userEmail, password: userPass);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login Successful')));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        userNotFound = true;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('User Not Found')));
      } else if (e.code == 'wrong-password') {
        passwordIsWrong = true;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Wrong Password')));
      } else if (e.code == 'invalid-email') {
        emailIsInvalid = true;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('E-mail not valid')));
      } else {
        print(e.code);
      }
      _formKey.currentState!.validate();
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = (await GoogleSignIn().signIn())!;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
