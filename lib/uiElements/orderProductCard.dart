import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderProductCard extends StatelessWidget {
  OrderProductCard({this.e});

  final DocumentSnapshot? e;

  @override
  Widget build(BuildContext context) {
    int total = 0;
    total += e!.data()!['price'] as int;
    total += e!.data()!['setupTaken'] ? e!.data()!['setupCost'] as int : 0;
    total +=
        e!.data()!['deliveryTaken'] ? e!.data()!['deliveryCost'] as int : 0;
    total *= e!.data()!['quantity'] as int;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Product name: ${e!.data()!['name']}',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Price: ৳${e!.data()!['price'].toString()}',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Amount ordered: ${e!.data()!['quantity']}',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (e!.data()!['deliveryTaken'])
                Row(
                  children: [
                    Text(
                      'Delivery taken: ৳${e!.data()!['deliveryCost'].toString()}',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              if (e!.data()!['setupTaken'])
                Row(
                  children: [
                    Text(
                      'Setup taken: ৳${e!.data()!['setupCost'].toString()}',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Total bill: ৳$total',
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
