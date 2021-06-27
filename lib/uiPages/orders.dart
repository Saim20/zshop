import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:z_shop/data/data.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
            child: Center(
              child: Hero(
                tag: 'orderHero',
                child: Icon(
                  orderIcon,
                  size: 200.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              'Orders',
              style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.w200,
                  color: Colors.white),
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    return Column(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot order) {
                        return Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10.0),
                            onTap: () {
                              Navigator.of(context).pushNamed('/orderpage',
                                  arguments: {'order': order});
                            },
                            child: Card(
                              elevation: 30.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          order.data()!['name'],
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                        if (order.data()!['status'] ==
                                            'confirmed')
                                          Text(
                                            ' - Confirmed',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.redAccent),
                                          ),
                                        if (order.data()!['status'] == 'placed')
                                          Text(
                                            ' - Placed',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.orange),
                                          ),
                                        if (order.data()!['status'] ==
                                            'shipped')
                                          Text(
                                            ' - Shipped',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.blueAccent),
                                          ),
                                        if (order.data()!['status'] ==
                                            'complete')
                                          Text(
                                            ' - Complete',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.green),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(order.data()!['phone']),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.remove_shopping_cart_outlined,
                              size: 40.0,
                              color: Colors.blue,
                            ),
                            Text(
                              'No Orders',
                              style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                }
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100.0,
                      child: SpinKitSquareCircle(
                        color: Colors.blueAccent,
                        size: 50.0,
                      ),
                    ),
                    Text(
                      'Loading',
                      style:
                          TextStyle(fontSize: 25.0, color: Colors.blueAccent),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
