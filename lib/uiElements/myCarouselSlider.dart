import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:z_shop/services/product.dart';

class CarouselWithIndicator extends StatefulWidget {
  CarouselWithIndicator({required this.product});

  final Product product;

  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CarouselSlider(
        items: widget.product.images!
            .map((item) => Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    child: Center(
                      child: widget.product.images![0] == item
                          ? Hero(
                              tag: item,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  item,
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                item,
                                // width: 500.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                ))
            .toList(),
        options: CarouselOptions(
            height: 300.0,
            autoPlay: true,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.product.images!.map((url) {
          int index = widget.product.images!.indexOf(url);
          return Container(
            width: 8.0,
            height: 8.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _current == index
                  ? Color.fromRGBO(0, 0, 0, 0.9)
                  : Color.fromRGBO(0, 0, 0, 0.4),
            ),
          );
        }).toList(),
      ),
    ]);
  }
}
