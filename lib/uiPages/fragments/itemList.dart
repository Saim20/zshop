import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:z_shop/uiElements/productCard.dart';

class ItemListFragment extends StatelessWidget {

  ItemListFragment({this.onSelectProduct});

  final ValueChanged<QueryDocumentSnapshot?>? onSelectProduct;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return FutureBuilder<QuerySnapshot>(
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
            return ListView(
                children: snapshot.data!.docs
                    .map((e) => ProductCard(product: e,))
                    .toList());
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
    );
  }
}
