import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:z_shop/uiElements/categoryCard.dart';
import 'package:z_shop/uiElements/productGridCard.dart';

class CategoryFragment extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<String> categories = [
    'Electronics',
    'Food',
    'Furniture',
    'Crockeries',
    'Tools and Accessories',
    'Others',
    'Pump and Machineries',
    'Gifts and Toys',
    'Bicylce and Tricycle',
    'Fashion'
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(35.0, 20.0, 35.0, 20.0),
          child: Text(
            'Featured',
            style: TextStyle(fontSize: 25.0),
          ),
        ),
        FutureBuilder<QuerySnapshot>(
          future: firestore.collection('products').get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Container(
                height: 320.0,
                child: Center(
                  child: Text('Connection Problem!'),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {

                List<QueryDocumentSnapshot> featured = [];
                for(var prod in snapshot.data!.docs){
                  if(prod.data()['featured']){
                    featured.add(prod);
                  }
                }

                return Container(
                  height: 320,
                  child: GridView(
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1),
                      children: featured
                          .map((e) => ProductGridCard(
                                prod: e,
                              ))
                          .toList()),
                );
              } else {
                return Container(
                    height: 320.0, child: Center(child: Text('Nothing found')));
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
        Padding(
          padding: const EdgeInsets.fromLTRB(35.0, 20.0, 35.0, 20.0),
          child: Text(
            'Categories',
            style: TextStyle(fontSize: 25.0),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: categories.map((e) => CategoryCard(category: e,)).toList(),
        ),
      ],
    );
  }
}
