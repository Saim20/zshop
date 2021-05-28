import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignupOptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 100.0, 50.0, 100.0),
            child: Text(
              'Signup Options',
              style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.w200,
                  color: Colors.blue[500]),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 0.0),
            height: 40.0,
            child: SignInButton(
              Buttons.Email,
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/signup');
              },
              text: 'Sign up with E-mail',
            ),
          ),
          TextButton(
            child: Text(
              'Or Login',
              style: TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      )),
    );
  }
}
