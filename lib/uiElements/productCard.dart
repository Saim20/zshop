import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ProductCard extends StatelessWidget {
  ProductCard({this.product,this.onSelectProduct});

  final QueryDocumentSnapshot? product;
  final ValueChanged<QueryDocumentSnapshot?>? onSelectProduct;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onSelectProduct!(product);
      },
      splashColor: Colors.purpleAccent,
      focusColor: Colors.blue[100],
      hoverColor: Colors.blue[100],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        child: Card(
          color: Colors.grey[100],
          elevation: 15.0,
          shadowColor: Colors.grey[50],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    product!.data()['image'],
                    height: 80,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: Colors.grey[300]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(8.0, 2.0, 10.0, 0.0),
                      child: Text(
                        product!.data()['name'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8.0, 0.0, 15.0, 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 3.0, 10.0, 0.0),
                                child: Text(
                                  '৳ ${product!.data()['offerPrice'].toString()}',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.red[400],
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 2.0),
                                child: Text(
                                  '৳ ${product!.data()['price'].toString()}',
                                  style: TextStyle(
                                      color: Colors.red[200],
                                      fontSize: 13.0,
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
