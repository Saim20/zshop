import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:z_shop/data/data.dart';

class SignupOptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.grey[200]!,
              Colors.grey[400]!,
              Colors.grey[500]!,
              Colors.grey[500]!,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            SizedBox(
              height: 100,
            ),
            createTitle(),
            SizedBox(
              height: 100,
            ),
            emailSignupButton(context),
            SizedBox(
              height: 10,
            ),
            googleSignupButton(),
            SizedBox(
              height: 10,
            ),
            loginButton(context),
          ],
        ),
      )),
    );
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

  Widget createTitle() {
    return Center(
      child: Text(
        'Signup Options',
        style: TextStyle(
            fontSize: 50.0, fontWeight: FontWeight.w200, color: Colors.grey),
      ),
    );
  }

  Widget emailSignupButton(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(),
        Container(
          height: 40.0,
          width: 300.0,
          child: SignInButton(
            Buttons.Email,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/signup');
            },
            text: 'Sign up with E-mail',
          ),
        ),
        SizedBox(),
      ],
    );
  }

  Widget googleSignupButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(),
        Container(
          height: 40.0,
          width: 300.0,
          child: SignInButton(
            Buttons.Google,
            onPressed: () async {
              await signInWithGoogle();
            },
            text: 'Sign up with Google',
          ),
        ),
        SizedBox(),
      ],
    );
  }

  Widget loginButton(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(),
        TextButton(
          child: Text(
            'Or Login',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(),
      ],
    );
  }
}
