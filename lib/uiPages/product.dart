import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  ProductDetailsPage({this.product,this.addProduct});

  final QueryDocumentSnapshot? product;
  final ValueChanged<QueryDocumentSnapshot?>? addProduct;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Details',
        style: TextStyle(
          color: Colors.blue
        ),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(
                product!.data()['image'],
                height: MediaQuery.of(context).size.height / 3,
              ),
            ),
          ),
          Divider(
            height: 15.0,
            indent: 10.0,
            endIndent: 10.0,
            color: Theme.of(context).accentColor,
            thickness: 4.0,
          ),
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                  child: Text(
                    product!.data()['name'],
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text('৳ ${product!.data()['offerPrice'].toString()}',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.yellow[800]
                        ),),
                        // Text(
                        //   '৳ ${product!.data()['offerPrice'].toString()}',
                        //   style: TextStyle(
                        //       fontSize: 20.0, color: Colors.yellow[800]),
                        // ),
                        Text(
                          '৳ ${product!.data()['price'].toString()}',
                          style: TextStyle(
                              fontSize: 18.0,
                              decoration: TextDecoration.lineThrough),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Rating'),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  child: Text(
                    'Description',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  child: Text(
                    product!.data()['description'],
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){

        },
        label: Text('Add to cart'),
        icon: Icon(Icons.add_shopping_cart),
        splashColor: Colors.blue[900],
        hoverColor: Colors.blue[800],
        focusColor: Colors.blue[300],
      ),
    );
  }
}
