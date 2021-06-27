import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:z_shop/services/product.dart';

class Reviewer extends StatefulWidget {
  Reviewer({
    required this.product,
    required this.updateState,
  });

  final ValueChanged<void> updateState;
  final Product product;

  @override
  _ReviewerState createState() => _ReviewerState(
        product: product,
      );
}

class _ReviewerState extends State<Reviewer> {
  _ReviewerState({
    required this.product,
  });

  Product product;
  double? userRating;
  String? userReview;
  bool? hasChanged;
  bool? isNotRated;
  double rating = 5.0;

  TextEditingController reviewC = TextEditingController();

  getUserRatingAndReview() async {
    var doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('ratings')
        .doc(product.id)
        .get();

    if (doc.exists) {
      userRating = doc.data()!['rating'];
      rating = userRating ?? 5.0;
      userReview = doc.data()!['review'] ?? '';
    }
    setState(() {
      reviewC.text = userReview!;
      isNotRated = userRating == null;
      checkChanged();
    });
  }

  checkChanged() {
    if (isNotRated ?? true) {
      setState(() {
        hasChanged = true;
      });
      return;
    }
    if (rating != userRating || reviewC.text != userReview)
      setState(() {
        hasChanged = true;
      });
    else
      setState(() {
        hasChanged = false;
      });

    // print('$rating  :: $userRating  :: ${reviewC.text}  :: $userReview');
  }

  @override
  Widget build(BuildContext context) {
    if (isNotRated == null) getUserRatingAndReview();

    return Container(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text((isNotRated ?? true) ? 'Rate the product' : 'Your rating'),
            SizedBox(
              height: 20.0,
            ),
            RatingBar.builder(
              initialRating: (isNotRated ?? true) ? rating : userRating!,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                this.rating = rating;
                checkChanged();
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
              child: Container(
                child: TextFormField(
                  onChanged: (value) {
                    checkChanged();
                  },
                  controller: reviewC,
                  maxLines: 5,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Review'),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: (hasChanged ?? false)
                  ? () async {
                      var rate;
                      if (isNotRated ?? true) {
                        rate =
                            ((product.rating * product.ratingCount) + rating) /
                                (product.ratingCount + 1);

                        await FirebaseFirestore.instance
                            .collection('products')
                            .doc(product.id)
                            .update({
                          'rating': rate,
                          'ratingCount': (product.ratingCount + 1),
                        });

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('ratings')
                            .doc(product.id)
                            .set({
                          'rating': rating,
                          'review': reviewC.text,
                        });

                        await FirebaseFirestore.instance
                            .collection('products')
                            .doc(product.id)
                            .collection('reviews')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .set({
                          'review': reviewC.text,
                          'name':
                              FirebaseAuth.instance.currentUser!.displayName,
                          'rating': rating,
                        });

                        setState(() {
                          userRating = rating;
                          userReview = reviewC.text;
                          product.rating = rate;
                          isNotRated = false;
                          product.ratingCount += 1;
                          checkChanged();
                        });
                        widget.updateState(true);
                      }
                      //Check if is rated
                      else if (!(isNotRated ?? true)) {
                        rate = ((product.rating * product.ratingCount) +
                                (rating - (userRating ?? 0))) /
                            (product.ratingCount);

                        await FirebaseFirestore.instance
                            .collection('products')
                            .doc(product.id)
                            .update({
                          'rating': rate,
                        });

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('ratings')
                            .doc(product.id)
                            .update({
                          'rating': rating,
                          'review': reviewC.text,
                        });
                      }

                      await FirebaseFirestore.instance
                          .collection('products')
                          .doc(product.id)
                          .collection('reviews')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .set({
                        'review': reviewC.text,
                        'name': FirebaseAuth.instance.currentUser!.displayName,
                        'rating': rating,
                      });

                      setState(() {
                        userRating = rating;
                        userReview = reviewC.text;
                        product.rating = rate;
                        isNotRated = false;
                        checkChanged();
                      });
                      widget.updateState(true);

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Rating updated')));
                    }
                  : null,
              child: Text((isNotRated ?? true) ? 'Submit' : 'Change'),
            ),
          ],
        ),
      ),
    );
  }
}
