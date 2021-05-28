import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 70.0, 50.0, 50.0),
            child: Text(
              'Sign Up',
              style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.w200,
                  color: Colors.blue[500]),
            ),
          ),
          MyCustomForm(),
        ],
      )),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  bool isEmailAlreadySignedUp = false;
  bool emailIsInvalid = false;
  bool showPassword = false;

  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController confirmC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Container(
              child: TextFormField(
                controller: nameC,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
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
                controller: emailC,
                onChanged: (value) {
                  setState(() {
                    isEmailAlreadySignedUp = false;
                    emailIsInvalid = false;
                  });
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'E-mail'),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter an e-mail';
                  else if (isEmailAlreadySignedUp) {
                    return 'E-mail is already user for an account';
                  }
                  else if(emailIsInvalid){
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
                controller: addressC,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Shipping Address'),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter your shipping address';
                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Container(
              child: TextFormField(
                keyboardType: TextInputType.phone,
                controller: phoneC,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Phone'),
                validator: (value) {
                  if (value == null) {
                    return 'Please enter a phone number';
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
                obscureText: !showPassword,
                enableSuggestions: showPassword,
                controller: passC,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter a password';
                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Container(
              child: TextButton(
                onPressed: (){
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                child: Text(showPassword ? 'Hide password' : 'Show password'),
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Container(
              child: TextFormField(
                obscureText: !showPassword,
                enableSuggestions: showPassword,
                controller: confirmC,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password'),
                validator: (value) {
                  if (passC.text != value) return 'Passwords do not match';
                  return null;
                },
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 30.0, 0.0, 0.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Signing up')));
                      signUpWithEmailAndPass(emailC.text, passC.text);
                    }
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                child: TextButton(
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
              ),
            ],
          )
        ],
      ),
    );
  }

  void signUpWithEmailAndPass(email, pass) async {
    String userEmail = email;
    String userPass = pass;

    try {
      await FirebaseFirestore.instance.collection('users').doc(emailC.text).set({
        'phone': phoneC.text,
        'address': addressC.text,
      });
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: userEmail, password: userPass);
      await FirebaseAuth.instance.currentUser!.updateProfile(displayName: nameC.text);
      FirebaseAuth.instance.signOut();
      FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);

      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
          isEmailAlreadySignedUp = true;
      }
      else if (e.code == 'invalid-email') {
        emailIsInvalid = true;
      }
      else{
        print(e);
      }
      _formKey.currentState!.validate();
    }
  }
}
