import 'package:flutter/material.dart';
import 'package:z_shop/appState.dart';
import 'package:z_shop/data/data.dart';
import 'package:z_shop/services/product.dart';

class CartProductCard extends StatefulWidget {
  CartProductCard(
      {this.product,
      this.productRemover,
      this.costCalculator,
      this.productRetriever});

  final Product? product;
  final ValueChanged<bool>? costCalculator;
  final ValueChanged<Product>? productRemover;
  final ValueChanged<Product>? productRetriever;

  @override
  _CartProductCardState createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {
  @override
  Widget build(BuildContext context) {
    Product product = widget.product!;
    TextEditingController controller =
        TextEditingController(text: product.quantity.toString());

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/details',
            arguments: {'product': product, 'cart': true});
      },
      splashColor: accountColor,
      focusColor: accentColor,
      hoverColor: accentColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        child: Card(
          color: Colors.grey[100],
          elevation: 15.0,
          shadowColor: Colors.grey[50],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            children: [
              // Top Row
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                              ? 170
                              : 90,
                          width: MediaQuery.of(context).size.width >
                                  MediaQuery.of(context).size.height
                              ? 240
                              : 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        color: Colors.grey[300]),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                              child: Text(
                                product.name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () {
                                  setState(() {
                                    var temp = product;
                                    //Remove the product from cart
                                    widget.productRemover!(product);
                                    //Notify the user
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Text('Product Removed'),
                                          ],
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              widget.productRetriever!(temp);
                                            },
                                            child: Text('undo'))
                                      ],
                                    )));
                                  });
                                })
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 3.0, 10.0, 0.0),
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
                                  EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 2.0),
                              child: Text(
                                '৳ ${product.price.toString()}',
                                style: TextStyle(
                                    color: Colors.red[200],
                                    fontSize: 13.0,
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Bottom Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                      width: 100.0,
                      height: 70.0,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: controller,
                        onChanged: (value) {
                          product.quantity = int.parse(value);
                        },
                        onEditingComplete: () {
                          widget.costCalculator!(true);
                        },
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            labelText: 'Quantity',
                            border: OutlineInputBorder()),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 30.0,
                          child: Row(
                            children: [
                              Text(
                                'Delivery(৳${widget.product!.deliveryCost})',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w300),
                              ),
                              Switch(
                                  value: widget.product!.deliveryTaken,
                                  onChanged: product.deliveryCost == 0
                                      ? null
                                      : (value) {
                                          setState(() {
                                            widget.costCalculator!(true);
                                            App.cartProducts
                                                    .elementAt(
                                                        App.cartProducts
                                                            .indexOf(widget
                                                                .product!))
                                                    .deliveryTaken =
                                                !App.cartProducts
                                                    .elementAt(App.cartProducts
                                                        .indexOf(
                                                            widget.product!))
                                                    .deliveryTaken;
                                            if (!widget
                                                .product!.deliveryTaken) {
                                              App.cartProducts
                                                  .elementAt(App.cartProducts
                                                      .indexOf(widget.product!))
                                                  .setupTaken = false;
                                              widget.product!.setupTaken =
                                                  false;
                                            }
                                          });
                                        }),
                            ],
                          ),
                        ),
                        if (widget.product!.deliveryTaken)
                          Container(
                            height: 30.0,
                            child: Row(
                              children: [
                                Text(
                                  'Setup(৳${widget.product!.setupCost})',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w300),
                                ),
                                Switch(
                                    value: widget.product!.setupTaken,
                                    onChanged: product.setupCost == 0
                                        ? null
                                        : (value) {
                                            setState(() {
                                              widget.costCalculator!(true);
                                              App.cartProducts
                                                      .elementAt(
                                                          App.cartProducts
                                                              .indexOf(widget
                                                                  .product!))
                                                      .setupTaken =
                                                  !App.cartProducts
                                                      .elementAt(App
                                                          .cartProducts
                                                          .indexOf(
                                                              widget.product!))
                                                      .setupTaken;
                                            });
                                          }),
                              ],
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
