import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:z_shop/appState.dart';
import 'package:z_shop/data/data.dart';
import 'package:z_shop/services/product.dart';
import 'package:z_shop/services/roundDouble.dart';
import 'package:z_shop/uiElements/myCarouselSlider.dart';
import 'package:z_shop/uiElements/reviewCard.dart';
import 'package:z_shop/uiElements/reviewer.dart';

class ProductDetailsPage extends StatefulWidget {
  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  Product? product;

  void updateState(void a) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
            iconTheme: IconThemeData(color: accentColor),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text(
              'Details',
              style: TextStyle(
                fontSize: 35.0,
                color: accentColor,
                fontWeight: FontWeight.w300,
              ),
            ),
            actions: [
              IconButton(
                  tooltip: 'Cart',
                  icon: Hero(
                    tag: 'cartHero',
                    child: Icon(
                      cartIcon,
                      color: cartColor,
                      size: 30.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/cart');
                  }),
              IconButton(
                  tooltip: 'Account',
                  icon: Hero(
                    tag: 'accountHero',
                    child: Icon(
                      accountIcon,
                      color: accountColor,
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
          CarouselWithIndicator(product: product!),
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
                                child: Text(
                                    roundRating(product!.rating, 1).toString()),
                              ),
                              RatingBarIndicator(
                                rating: roundRating(product!.rating, 1),
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
                      if (FirebaseAuth.instance.currentUser != null &&
                          !fromCart)
                        Reviewer(
                          product: product!,
                          updateState: updateState,
                        ),
                      if (!(FirebaseAuth.instance.currentUser != null &&
                          !fromCart))
                        SizedBox(
                          height: 15.0,
                        ),
                      FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('products')
                            .doc(product!.id)
                            .collection('reviews')
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              return Column(
                                children: snapshot.data!.docs
                                    .map((e) => ReviewCard(review: e))
                                    .toList(),
                              );
                            } else {
                              return Container(
                                  height: 320.0,
                                  child: Center(child: Text('Nothing found')));
                            }
                          }
                          return Text('Nothing');
                        },
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
              splashColor: accentColor,
              hoverColor: accentColor.withAlpha(1),
              focusColor: accentColor.withAlpha(2),
            ),
    );
  }
}
