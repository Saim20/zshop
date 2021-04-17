import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {

  LoginPage({this.onRegistrationClick});

  final ValueChanged<bool>? onRegistrationClick;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              'Login',
              style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.w200,
                  color: Colors.blue[500]),
            ),
          ),
          MyCustomForm(onRegistrationClick: widget.onRegistrationClick,),
        ],
      )),
    );
  }
}

class MyCustomForm extends StatefulWidget {

  MyCustomForm({this.onRegistrationClick});

  final ValueChanged<bool>? onRegistrationClick;


  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

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
              'Username/Phone/E-mail',
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
                    return 'Please enter your username';
                  }
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
                  if (value == null || value.isEmpty)
                    return 'Please enter you password';
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
                    'Login',
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
                    'Or Sign Up',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onPressed: () {
                    widget.onRegistrationClick!(true);
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
