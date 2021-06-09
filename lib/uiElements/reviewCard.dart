import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewCard extends StatelessWidget {
  ReviewCard({required this.review});

  final DocumentSnapshot review;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      review.data()!['name'],
                      maxLines: 2,
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  RatingBarIndicator(
                    rating: review.data()!['rating'],
                    itemCount: 5,
                    itemSize: 15.0,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      review.data()!['review'],
                      maxLines: 10,
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
