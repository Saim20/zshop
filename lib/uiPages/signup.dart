import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:z_shop/data/data.dart';

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
          child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue[400]!,
              Colors.purple,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(50.0, 70.0, 50.0, 50.0),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.w200,
                      color: Colors.white),
                ),
              ),
            ),
            MyCustomForm(),
          ],
        ),
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

  final BorderRadius myBorderRadius = BorderRadius.circular(40.0);

  bool isEmailAlreadySignedUp = false;
  bool emailIsInvalid = false;
  bool emailAlreadyInUse = false;
  bool showPassword = false;
  bool weakPassword = false;

  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController confirmC = TextEditingController();

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    addressC.dispose();
    phoneC.dispose();
    passC.dispose();
    confirmC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Container(
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 600
                  : 500,
              child: Material(
                borderRadius: myBorderRadius,
                elevation: 30.0,
                child: TextFormField(
                  controller: nameC,
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.grey[800],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
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
                    // labelStyle: TextStyle(color: Colors.grey[600]),
                    // labelText: 'Name *',
                    hintText: 'Name *',
                    icon: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                      child: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Container(
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 600
                  : 500,
              child: Material(
                borderRadius: myBorderRadius,
                elevation: 30.0,
                child: TextFormField(
                  controller: emailC,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    isEmailAlreadySignedUp = false;
                    emailIsInvalid = false;
                    emailAlreadyInUse = false;
                  },
                  cursorColor: Colors.grey[800],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
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
                    // labelStyle: TextStyle(color: Colors.grey[600]),
                    // labelText: 'E-mail *',
                    hintText: 'E-mail *',
                    icon: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                      child: Icon(
                        Icons.alternate_email,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter an e-mail';
                    else if (isEmailAlreadySignedUp) {
                      return 'E-mail is already user for an account';
                    } else if (emailIsInvalid) {
                      return 'Please enter a valid e-mail';
                    } else if (emailAlreadyInUse) {
                      return 'This email is already used';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Container(
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 600
                  : 500,
              child: Material(
                borderRadius: myBorderRadius,
                elevation: 30.0,
                child: TextFormField(
                  controller: addressC,
                  keyboardType: TextInputType.streetAddress,
                  cursorColor: Colors.grey[800],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
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
                    // labelStyle: TextStyle(color: Colors.grey[600]),
                    // labelText: 'Shipping Address *',
                    hintText: 'Shipping Address *',
                    icon: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter your shipping address';
                    return null;
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Container(
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 600
                  : 500,
              child: Material(
                borderRadius: myBorderRadius,
                elevation: 30.0,
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: phoneC,
                  cursorColor: Colors.grey[800],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
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
                    // labelStyle: TextStyle(color: Colors.grey[600]),
                    // labelText: 'Phone',
                    hintText: 'Phone',
                    icon: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                      child: Icon(
                        Icons.phone,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Container(
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 600
                  : 500,
              child: Material(
                borderRadius: myBorderRadius,
                elevation: 30.0,
                child: TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !showPassword,
                  enableSuggestions: showPassword,
                  controller: passC,
                  onChanged: (value) {
                    weakPassword = false;
                  },
                  cursorColor: Colors.grey[800],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
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
                    // labelStyle: TextStyle(
                    //   color: Colors.grey[600],
                    // ),
                    // labelText: 'Password *',
                    hintText: 'Password *',
                    icon: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                      child: Icon(
                        Icons.password,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter a password';
                    if (weakPassword) return 'Password is too weak';
                    return null;
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
            child: Container(
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 600
                  : 500,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: showPassword
                        ? Icon(
                            Icons.visibility_off_rounded,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.visibility_rounded,
                            color: Colors.white,
                          ),
                    label: Text(
                      showPassword ? 'Hide password' : 'Show password',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Container(
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 600
                  : 500,
              child: Material(
                borderRadius: myBorderRadius,
                elevation: 30.0,
                child: TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !showPassword,
                  enableSuggestions: showPassword,
                  controller: confirmC,
                  cursorColor: Colors.grey[800],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
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
                    // labelStyle: TextStyle(color: Colors.grey[600]),
                    // labelText: 'Confirm Password *',
                    hintText: 'Confirm Password *',
                    icon: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                      child: Icon(
                        Icons.password,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (passC.text != value) return 'Passwords do not match';
                    return null;
                  },
                ),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(20.0),
                    backgroundColor: MaterialStateProperty.all(accentColor),
                  ),
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
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 20.0),
                child: TextButton(
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
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: userEmail, password: userPass);
      await FirebaseAuth.instance.currentUser!.updateDisplayName(nameC.text);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'phone': phoneC.text,
        'address': addressC.text,
      });

      FirebaseAuth.instance.signOut();
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);

      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        weakPassword = true;
      } else if (e.code == 'email-already-in-use') {
        isEmailAlreadySignedUp = true;
      } else if (e.code == 'invalid-email') {
        emailIsInvalid = true;
      } else if (e.code == 'email-already-in-use') {
        print(e.code);
        emailAlreadyInUse = true;
      } else {
        print(e.code);
      }
      _formKey.currentState!.validate();
    }
  }
}
