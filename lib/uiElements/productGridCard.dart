import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:z_shop/appState.dart';
import 'package:z_shop/services/product.dart';

class ProductGridCard extends StatelessWidget {
  ProductGridCard({
    this.prod,
  });

  final QueryDocumentSnapshot? prod;

  @override
  Widget build(BuildContext context) {
    Product product = Product(
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

    bool outOfStock = product.stock <= 0;

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/details',
            arguments: {'product': product, 'cart': false});
      },
      splashColor: Colors.purpleAccent,
      focusColor: Colors.blue[100],
      hoverColor: Colors.blue[100],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 34.0),
        child: Card(
          color: Colors.grey[100],
          elevation: 15.0,
          shadowColor: Colors.grey[50],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: Hero(
                    tag: product.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(
                        product.images![0],
                        height: 150,
                        width: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(3.0, 0.0, 0.0, 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.0, 3.0, 10.0, 0.0),
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
                                      EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 2.0),
                                  child: Text(
                                    '৳ ${product.price.toString()}',
                                    style: TextStyle(
                                        color: Colors.red[100],
                                        fontSize: 13.0,
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            width: 70.0,
                          ),
                          Text('Rating'),
                          IconButton(
                              icon: Icon((outOfStock
                                  ? Icons.not_interested
                                  : Icons.add_shopping_cart)),
                              onPressed: !outOfStock
                                  ? () {
                                      if (App.addToCart(product)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Product added to cart')));
                                      } else
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Product already added to cart')));
                                    }
                                  : null)
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
