import 'package:flutter/material.dart';

class ErrorPage extends StatefulWidget {

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
              //TODO Implement Network error page
      child: Text('Network Error'),
    )));
  }
}
