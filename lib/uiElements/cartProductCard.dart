import 'package:flutter/material.dart';
import 'package:z_shop/appState.dart';
import 'package:z_shop/services/product.dart';

class CartProductCard extends StatefulWidget {
  CartProductCard({this.product,this.productRemover,this.costCalculator,this.productRetriever});

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
    TextEditingController controller = TextEditingController(text: '1');
    Product product = widget.product!;

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/details',
            arguments: {'product': product, 'cart': true});
      },
      splashColor: Colors.purpleAccent,
      focusColor: Colors.blue[100],
      hoverColor: Colors.blue[100],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        child: Card(
          color: Colors.grey[100],
          elevation: 15.0,
          shadowColor: Colors.grey[50],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(10.0),
                child: Hero(
                  tag: product.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.network(
                      product.images![0],
                      height: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 170 : 90,
                      width: MediaQuery.of(context).size.width > MediaQuery.of(context).size.height ? 240 : 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: Colors.grey[300]),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 15.0, 5.0, 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 2.0, 10.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                                icon: Icon(Icons.delete,color: Colors.redAccent,),
                                onPressed: () {
                                  setState(() {
                                    var temp = product;
                                    //Remove the product from cart
                                    widget.productRemover!(product);
                                    //Notify the user
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.delete,color: Colors.white,),
                                                  SizedBox(width: 10.0,),
                                                  Text('Product Removed'),
                                                ],
                                              ),
                                              TextButton(onPressed: (){
                                                  widget.productRetriever!(temp);
                                              }, child: Text('undo'))
                                            ],
                                        )
                                      )
                                    );
                                  });
                                })
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
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
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 10.0, 0.0, 0.0),
                                  child: Container(
                                      width: 70.0,
                                      height: 30.0,
                                      child: TextField(
                                        controller: controller,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                            labelText: 'Quantity',
                                            border: OutlineInputBorder()),
                                      )),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Delivery(৳${widget.product!.deliveryCost})',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Switch(
                                        value: widget.product!.deliveryTaken,
                                        onChanged: product.deliveryCost == 0 ? null : (value) {
                                          setState(() {
                                            widget.costCalculator!(true);
                                            App.cartProducts.elementAt(App.cartProducts.indexOf(widget.product!)).deliveryTaken =
                                                !App.cartProducts.elementAt(App.cartProducts.indexOf(widget.product!)).deliveryTaken;
                                          });
                                        }),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Setup(৳${widget.product!.setupCost})',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Switch(
                                        value: widget.product!.setupTaken ,
                                        onChanged: product.setupCost == 0 ? null : (value) {
                                          setState(() {
                                            widget.costCalculator!(true);
                                            App.cartProducts.elementAt(App.cartProducts.indexOf(widget.product!)).setupTaken =
                                            !App.cartProducts.elementAt(App.cartProducts.indexOf(widget.product!)).setupTaken;
                                          });
                                        }),
                                  ],
                                ),
                              ],
                            ),
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
