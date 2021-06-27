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
  ProductDetailsPage({this.product, this.fromCart: false, this.reviews});

  final Product? product;
  final bool fromCart;
  final List<QueryDocumentSnapshot>? reviews;

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  Product? product;
  User? user;

  void updateState(void a) {
    setState(() {});
  }

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (mounted)
        setState(() {
          this.user = user;
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool fromCart;
    product = widget.product;
    fromCart = widget.fromCart;
    bool outOfStock = product!.stock <= 0;

    final BorderRadius myBorderRaidius = BorderRadius.circular(20.0);

    makeDismissable({required Widget child}) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );
    }

    return makeDismissable(
      child: DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
            color: Colors.grey[200],
          ),
          child: Column(
            children: [
              SizedBox(
                height: 15.0,
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  children: [
                    SizedBox(
                      height: 15.0,
                    ),
                    CarouselWithIndicator(product: product!),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              productName(),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 20.0, 20.0),
                                child: TextButton.icon(
                                  onPressed: !outOfStock
                                      ? () {
                                          App.addToCart(product);
                                          Navigator.of(context)
                                              .pushNamed('/cart');
                                        }
                                      : null,
                                  label: Text(
                                    outOfStock ? 'Out of stock' : 'Add to cart',
                                    style: TextStyle(
                                        color: outOfStock
                                            ? Colors.grey
                                            : accentColor),
                                  ),
                                  icon: Icon(
                                    outOfStock
                                        ? Icons.not_interested
                                        : Icons.add_shopping_cart,
                                    color:
                                        outOfStock ? Colors.grey : accentColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Card(
                            elevation: 10.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: myBorderRaidius,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                roundRating(product!.rating, 1)
                                                    .toString()),
                                          ),
                                          RatingBarIndicator(
                                            rating:
                                                roundRating(product!.rating, 1),
                                            itemCount: 5,
                                            itemSize: 20.0,
                                            itemBuilder: (context, index) =>
                                                Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10.0, 10.0, 0),
                                        child: Column(
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
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  color: Colors.red[100]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 10.0, 0.0, 0.0),
                                    child: Text(
                                      'Description',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 10.0, 0.0, 0.0),
                                    child: Text(
                                      product!.description,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  if (user != null && !fromCart)
                                    Reviewer(
                                      product: product!,
                                      updateState: updateState,
                                    ),
                                  if (!(user != null && !fromCart))
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                  Column(
                                    children: widget.reviews!
                                        .map((e) => ReviewCard(review: e))
                                        .toList(),
                                  ),
                                  SizedBox(
                                    height: 50.0,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding productName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 20.0),
      child: Text(
        product!.name,
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
