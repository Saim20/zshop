import 'package:flutter/material.dart';
import 'package:z_shop/appState.dart';

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    App.clearCart();

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            iconTheme: IconThemeData(color: Colors.blue),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
        ),
        body: Container(
          child: Center(
            child: Text(
              'Successfully placed order',
              maxLines: 2,
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.blue,
              ),
            ),
          ),
        ));
  }
}
