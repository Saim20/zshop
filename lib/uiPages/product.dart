// ignore: import_of_legacy_library_into_null_safe
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:z_shop/appState.dart';
import 'package:z_shop/services/product.dart';

class ProductDetailsPage extends StatefulWidget {
  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  Product? product;

  @override
  Widget build(BuildContext context) {
    bool fromCart;
    Map data = {};
    data = ModalRoute.of(context)!.settings.arguments! as Map<String, dynamic>;
    product = data['product'];
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
          Container(
            height: MediaQuery.of(context).orientation == Orientation.landscape
                ? 300.0
                : null,
            child: Hero(
              tag: product!.id,
              child: CarouselSlider(
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                ),
                items: product!.images!
                    .map((item) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  item,
                                  width: 500.0,
                                  height: 350.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          Divider(
            height: 15.0,
            indent: 15.0,
            endIndent: 15.0,
            color: Colors.transparent,
            thickness: 1.0,
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Rating'),
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
              splashColor: Colors.blue[900],
              hoverColor: Colors.blue[800],
              focusColor: Colors.blue[300],
            ),
    );
  }
}
