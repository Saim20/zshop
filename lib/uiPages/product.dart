// ignore: import_of_legacy_library_into_null_safe
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:z_shop/appState.dart';
import 'package:z_shop/services/product.dart';
import 'package:z_shop/uiElements/myCarouselSlider.dart';

class ProductDetailsPage extends StatefulWidget {
  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  Product? product;
  double? userRating;
  bool? isNotRated;
  double rating = 0.0;

  getUserRating() async {
    var user = await FirebaseAuth.instance.currentUser;
    userRating = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.email)
        .collection('ratings')
        .doc(product!.id)
        .get()
        .then((value) {
      if (value.data() == null) {
        return null;
      } else {
        return value.data()!['rating'];
      }
    });
    setState(() {
      isNotRated = userRating == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isNotRated == null) getUserRating();

    bool fromCart;
    Map data = {};
    data = ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>;
    if (product == null) product = data['product'];
    bool outOfStock = product!.stock <= 0;
    fromCart = data['cart'];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: AppBar(
            iconTheme: IconThemeData(color: Colors.blue),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text(
              'Details',
              style: TextStyle(
                fontSize: 35.0,
                color: Colors.blue,
                fontWeight: FontWeight.w300,
              ),
            ),
            actions: [
              IconButton(
                  icon: Hero(
                    tag: 'cartHero',
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.blue,
                      size: 30.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/cart');
                  }),
              IconButton(
                  icon: Hero(
                    tag: 'accountHero',
                    child: Icon(
                      Icons.account_circle,
                      color: Colors.blue,
                      size: 30.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/account');
                  }),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          Hero(
            tag: product!.id,
            child: CarouselWithIndicator(product: product!),
          ),
          SizedBox(
            height: 15.0,
          ),
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                  child: Text(
                    product!.name,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                '৳ ${product!.offerPrice.toString()}',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red[400]),
                              ),
                              Text(
                                '৳ ${product!.price.toString()}',
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red[100]),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(product!.rating.toString()),
                              ),
                              RatingBarIndicator(
                                rating: product!.rating,
                                itemCount: 5,
                                itemSize: 20.0,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        child: Text(
                          'Description',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        child: Text(
                          product!.description,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text((isNotRated ?? true)
                                ? 'Rate the product'
                                : 'Your rating'),
                            SizedBox(
                              height: 20.0,
                            ),
                            RatingBar.builder(
                              initialRating: (isNotRated ?? true)
                                  ? 5
                                  : userRating == null
                                      ? 0.0
                                      : userRating!,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                this.rating = rating;
                                print(rating);
                              },
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                //TODO Implement rating
                                var rate = product!.rating;
                                rate =
                                    ((product!.rating * product!.ratingCount) +
                                            rating) /
                                        (product!.ratingCount + 1);

                                await FirebaseFirestore.instance
                                    .collection('products')
                                    .doc(product!.id)
                                    .update({
                                  'rating': rate,
                                });
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.email)
                                      .collection('ratings')
                                      .doc(product!.id)
                                      .update({
                                    'rating': rating,
                                  });
                                } catch (e) {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.email)
                                      .collection('ratings')
                                      .doc(product!.id)
                                      .set({
                                    'rating': rating,
                                  });
                                }

                                setState(() {
                                  userRating = rating;
                                  product!.rating = rate;
                                  isNotRated = false;
                                });
                              },
                              child: Text(
                                  (isNotRated ?? true) ? 'Submit' : 'Change'),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: fromCart
          ? null
          : FloatingActionButton.extended(
              onPressed: !outOfStock
                  ? () {
                      if (App.addToCart(product)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Product added to cart')));
                      } else
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Product already added to cart')));
                    }
                  : null,
              label: Text(outOfStock ? 'Out of stock ' : 'Add to cart'),
              icon: Icon(
                  outOfStock ? Icons.not_interested : Icons.add_shopping_cart),
              tooltip: 'Add to cart',
              splashColor: Colors.blue[900],
              hoverColor: Colors.blue[800],
              focusColor: Colors.blue[300],
            ),
    );
  }
}
