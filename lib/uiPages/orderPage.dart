import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:z_shop/uiElements/orderProductCard.dart';

class OrderPage extends StatefulWidget {
  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String? localStatus;

  @override
  Widget build(BuildContext context) {
    var order;
    var data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    order = data['order'];

    if (localStatus == null) localStatus = order.data()!['status'];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blue),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Container(
          margin: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
          child: Text(
            'Order page',
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w300,
                fontSize: 30.0),
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(children: [
        SizedBox(
          height: 40.0,
        ),
        FutureBuilder<QuerySnapshot>(
          future: order.reference.collection('products').get(),
          builder:
              ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error'),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'User name: ${order.data()!['name']}',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (localStatus == 'confirmed')
                              Text(
                                ' - Confirmed',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.redAccent),
                              ),
                            if (localStatus == 'shipped')
                              Text(
                                ' - Shipped',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.blueAccent),
                              ),
                            if (localStatus == 'placed')
                              Text(
                                ' - Placed',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.orange),
                              ),
                            if (localStatus == 'complete')
                              Text(
                                ' - Complete',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.green),
                              ),
                          ],
                        ),
                        Text(
                          'Phone number: ${order.data()!['phone']}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Shows the e-mail address of user
                        Text(
                          'E-mail: ${order.data()!['email']}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Address: ${order.data()!['address']}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Payment Method: ${order.data()!['paymentMethod']}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Payment status: ${order.data()!['paymentStatus']}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Transaction ID: ${order.data()!['transactionId']}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Payment Time: ${order.data()!['paymentTime']}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                          child: Text(
                            'Products:',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: snapshot.data!.docs
                        .map((e) => OrderProductCard(
                              e: e,
                            ))
                        .toList(),
                  ),
                ],
              );
            }
            return Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 3 / 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitSquareCircle(
                      color: Colors.blueAccent,
                      size: 50.0,
                    ),
                    Text(
                      'Loading',
                      style:
                          TextStyle(fontSize: 25.0, color: Colors.blueAccent),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ]),
    );
  }
}
