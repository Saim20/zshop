import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:z_shop/uiElements/productCard.dart';

class ItemListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var data = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    String category = data['category'];

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          iconTheme: IconThemeData(color: Colors.blue),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Container(
            margin: const EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 30.0),
            child: Text(
              'Zshop',
              style: GoogleFonts.roboto(
                  color: Colors.blue,
                  fontWeight: FontWeight.w300,
                  fontSize: 40.0),
            ),
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: firestore.collection('products').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text('Connection Problem!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot?> docs = [];
              for (var product in snapshot.data!.docs) {
                if (product.data()['category'] == category) docs.add(product);
              }
              return Container(
                child: ListView(
                    children: docs.map((e) {
                      return ProductCard(
                        prod: e,
                      );
                    }).toList()),
              );
            } else {
              return Center(child: Text('Nothing found'));
            }
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 80.0,
                child: SpinKitSquareCircle(
                  color: Colors.blueAccent,
                  size: 50.0,
                ),
              ),
              Text(
                'Loading',
                style: TextStyle(fontSize: 25.0, color: Colors.blueAccent),
              )
            ],
          );
        },
      ),
    );
  }
}
