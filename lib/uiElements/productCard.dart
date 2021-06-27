import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:z_shop/appState.dart';
import 'package:z_shop/data/data.dart';
import 'package:z_shop/services/product.dart';
import 'package:z_shop/services/roundDouble.dart';
import 'package:z_shop/uiPages/product.dart';

class ProductCard extends StatelessWidget {
  ProductCard({this.prod, this.productObject});

  final QueryDocumentSnapshot? prod;
  final Product? productObject;

  @override
  Widget build(BuildContext context) {
    bool confirmation = false;
    Product product;

    bool outOfStock = false;

    if (prod != null) {
      product = Product(
        id: prod!.id,
        name: prod!.data()['name'],
        description: prod!.data()['description'],
        category: prod!.data()['category'],
        price: prod!.data()['price'],
        offerPrice: prod!.data()['offerPrice'],
        rating: prod!.data()['rating'] == null
            ? 0.0
            : prod!.data()['rating'].toDouble(),
        ratingCount: prod!.data()['ratingCount'] ?? 0,
        stock: prod!.data()['stock'],
        deliveryCost: prod!.data()['deliveryCost'],
        setupCost: prod!.data()['setupCost'],
        imageString: prod!.data()['images'],
      );
      product.convert();

      outOfStock = product.stock <= 0;
    } else {
      confirmation = true;
      product = productObject!;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(20.0),
      onTap: () async {
        QuerySnapshot reviewSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .doc(product.id)
            .collection('reviews')
            .get();
        List<QueryDocumentSnapshot> reviews = reviewSnapshot.docs;
        showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return ProductDetailsPage(
                product: product,
                fromCart: false,
                reviews: reviews,
              );
            });
      },
      splashColor: accentColor,
      focusColor: accentColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        child: Card(
          color: Colors.grey[100],
          elevation: 20.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(10.0),
                child: Hero(
                  tag: product.images![0],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.network(
                      product.images![0],
                      height: MediaQuery.of(context).size.width >
                              MediaQuery.of(context).size.height
                          ? 140
                          : 80,
                      width: MediaQuery.of(context).size.width >
                              MediaQuery.of(context).size.height
                          ? 180
                          : 100,
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
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 0.0, 10.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 0.0),
                                    child: Text(
                                      '৳ ${product.offerPrice.toString()}',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.red[400],
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 2.0),
                                    child: Text(
                                      '৳ ${product.price.toString()}',
                                      style: TextStyle(
                                          color: Colors.red[100],
                                          fontSize: 13.0,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  if (confirmation)
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0.0, 0.0, 10.0, 2.0),
                                      child: Text(
                                        'Quantity: ${product.quantity.toString()}',
                                        style: TextStyle(
                                            color: accentColor,
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                ],
                              ),
                              width: 70.0,
                            ),
                            if (confirmation)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 0.0, 10.0, 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Setup: ${product.setupTaken ? 'Yes' : 'No'}',
                                      style: TextStyle(
                                          color: product.setupTaken
                                              ? Colors.green
                                              : Colors.red),
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      'Delivery: ${product.deliveryTaken ? 'Yes' : 'No'}',
                                      style: TextStyle(
                                          color: product.deliveryTaken
                                              ? Colors.green
                                              : Colors.red),
                                    )
                                  ],
                                ),
                              ),
                            if (!confirmation)
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 0.0, 8.0, 0.0),
                                    child: Text(roundRating(product.rating, 1)
                                        .toString()),
                                  ),
                                  RatingBarIndicator(
                                    rating: roundRating(product.rating, 1),
                                    itemCount: 5,
                                    itemSize: 12.0,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                            if (!confirmation)
                              IconButton(
                                  icon: Icon(outOfStock
                                      ? Icons.not_interested
                                      : Icons.add_shopping_cart),
                                  tooltip: 'Add to cart',
                                  onPressed: !outOfStock
                                      ? () {
                                          App.addToCart(product);
                                          Navigator.of(context)
                                              .pushNamed('/cart');
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
