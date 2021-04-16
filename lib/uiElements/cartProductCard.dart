import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class CartProductCard extends StatefulWidget {
  CartProductCard({this.product,this.onSelectProduct});

  final QueryDocumentSnapshot? product;
  final ValueChanged<QueryDocumentSnapshot?>? onSelectProduct;

  @override
  _CartProductCardState createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {

  bool isDeliveryEnabled = false;
  bool isSetupEnabled = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onSelectProduct!(widget.product);
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
                    widget.product!.data()['image'],
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
                        widget.product!.data()['name'],
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
                          Row(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0.0, 3.0, 10.0, 0.0),
                                    child: Text(
                                      '৳ ${widget.product!.data()['offerPrice'].toString()}',
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
                                      '৳ ${widget.product!.data()['price'].toString()}',
                                      style: TextStyle(
                                          color: Colors.red[200],
                                          fontSize: 13.0,
                                          decoration: TextDecoration.lineThrough,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20.0,10.0,5.0,0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Delivery',style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w300
                                        ),),
                                        Switch(value: isDeliveryEnabled, onChanged: (value){
                                          setState(() {
                                            isDeliveryEnabled = !isDeliveryEnabled;
                                          });
                                        }),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Setup',style: TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w300
                                        ),),
                                        Switch(value: isSetupEnabled, onChanged: (value){
                                          setState(() {
                                            isSetupEnabled = !isSetupEnabled;
                                          });
                                        }),
                                      ],
                                    ),
                                  ],
                                ),
                              )
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
