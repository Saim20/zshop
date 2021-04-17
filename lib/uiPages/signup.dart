import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {

  SignupPage({this.onLoginClick});

  final ValueChanged<bool>? onLoginClick;

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
                padding: const EdgeInsets.fromLTRB(50.0, 100.0, 50.0, 100.0),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.w200,
                      color: Colors.blue[500]),
                ),
              ),
              MyCustomForm(onLoginClick: widget.onLoginClick,),
            ],
          )),
    );
  }
}


class MyCustomForm extends StatefulWidget {

  MyCustomForm({this.onLoginClick});

  final ValueChanged<bool>? onLoginClick;


  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  String? password;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Text(
              'Full Name',
              style: TextStyle(fontSize: 20.0, color: Colors.grey[500]),
            ),
          ),
          // Add TextFormFields and ElevatedButton here.
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Container(
              height: 30.0,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.bottom,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Text(
              'E-mail',
              style: TextStyle(fontSize: 20.0, color: Colors.grey[500]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Container(
              height: 30.0,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.bottom,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter an e-mail';
                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Text(
              'Shipping Address',
              style: TextStyle(fontSize: 20.0, color: Colors.grey[500]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Container(
              height: 30.0,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.bottom,
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
            child: Text(
              'Phone (Optional)',
              style: TextStyle(fontSize: 20.0, color: Colors.grey[500]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Container(
              height: 30.0,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.bottom,
                validator: (value) {
                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Text(
              'Password',
              style: TextStyle(fontSize: 20.0, color: Colors.grey[500]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Container(
              height: 30.0,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.bottom,
                validator: (value) {
                  password = value;
                  if (value == null || value.isEmpty)
                    return 'Please enter a password';
                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Text(
              'Confirm Password',
              style: TextStyle(fontSize: 20.0, color: Colors.grey[500]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            child: Container(
              height: 30.0,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.bottom,
                validator: (value) {
                  if(password != value)
                    return 'Passwords do not match';
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
                          .showSnackBar(SnackBar(content: Text('Logging in')));
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
                    widget.onLoginClick!(true);
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
