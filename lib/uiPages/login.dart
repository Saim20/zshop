import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.isIncomplete,this.completeSignin});

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
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 70.0, 50.0, 50.0),
            child: Text(
              isIncomplete ? 'Complete Account' : 'Login',
              style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.w200,
                  color: Colors.blue[500]),
            ),
          ),
          MyCustomForm(
            isIncomplete: isIncomplete,
          ),
        ],
      )),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  MyCustomForm({this.isIncomplete,this.completeSignin});

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
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Container(
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailC,
                onChanged: (value) {
                  userNotFound = false;
                  emailIsInvalid = false;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
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
              child: TextFormField(
                obscureText: widget.isIncomplete! ? false : true,
                enableSuggestions:  widget.isIncomplete! ? true :false,
                autocorrect:  widget.isIncomplete! ? true : false,
                onChanged: (value) {
                  passwordIsWrong = false;
                },
                controller: passC,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
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
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) if (!widget
                        .isIncomplete!) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Logging in')));
                      signInWithEmailAndPass(emailC.text, passC.text);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Completing account')));
                      completeAccount(emailC.text, passC.text);
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
                TextButton(
                  child: Text(
                    'Or Sign Up',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/signupoptions');
                  },
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
        .doc(FirebaseAuth.instance.currentUser!.email)
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
