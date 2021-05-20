import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:z_shop/appState.dart';
import 'package:z_shop/services/product.dart';

class ProductCard extends StatelessWidget {
  ProductCard({this.prod, this.productObject});

  final QueryDocumentSnapshot? prod;
  final Product? productObject;

  @override
  Widget build(BuildContext context) {
    bool confirmation = false;
    Product product;

    if (prod != null) {
      product = Product(
        id: prod!.id,
        name: prod!.data()['name'],
        description: prod!.data()['description'],
        category: prod!.data()['category'],
        price: prod!.data()['price'],
        offerPrice: prod!.data()['offerPrice'],
        stock: prod!.data()['stock'],
        deliveryCost: prod!.data()['deliveryCost'],
        setupCost: prod!.data()['setupCost'],
        imageString: prod!.data()['images'],
      );
      product.convert();
    } else {
      confirmation = true;
      product = productObject!;
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/details', arguments: {'product': product, 'cart': false});
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(10.0),
                child: Hero(
                  tag: product.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.network(
                      product.images![0],
                      height: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 140 : 80,
                      width: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 180 : 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 0.0),
                        child: Text(
                          product.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 0.0, 15.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0.0, 3.0, 10.0, 0.0),
                                    child: Text(
                                      '৳ ${product.offerPrice.toString()}',
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.red[400], fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 2.0),
                                    child: Text(
                                      '৳ ${product.price.toString()}',
                                      style: TextStyle(
                                          color: Colors.red[100],
                                          fontSize: 13.0,
                                          decoration: TextDecoration.lineThrough,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  if(confirmation)
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 2.0),
                                      child: Text(
                                        'Quantity: ${product.quantity.toString()}',
                                        style: TextStyle(
                                            color: Colors.blue[500],
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                ],
                              ),
                              width: 70.0,
                            ),
                            if (confirmation)
                              Column(
                                children: [
                                  Text('Setup: ${product.setupTaken ? 'Yes' : 'No'}'),
                                  Text('Delivery: ${product.deliveryTaken ? 'Yes' : 'No'}')
                                ],
                              ),
                            if (!confirmation) Text('Rating'),
                            if (!confirmation)
                              IconButton(
                                  icon: Icon(Icons.add_shopping_cart),
                                  onPressed: product.stock > 0
                                      ? () {
                                          if (App.addToCart(product)) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(content: Text('Product added to cart')));
                                          } else
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(content: Text('Product already added to cart')));
                                        }
                                      : null)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
