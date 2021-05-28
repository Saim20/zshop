import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:z_shop/services/order.dart';
import 'package:z_shop/uiElements/productCard.dart';

class ConfirmationPage extends StatefulWidget {
  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Order order = data['order'];
    Function clearCart = data['clearcart'];

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            iconTheme: IconThemeData(color: Colors.blue),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            title: Container(
              margin: const EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 30.0),
              child: Text(
                'Confirm Order',
                style: GoogleFonts.roboto(color: Colors.blue, fontWeight: FontWeight.w300, fontSize: 40.0),
              ),
            ),
          ),
        ),
        body: ListView(
            children: [
          Column(
            children: order.cartProducts
                .map((e) => ProductCard(
                      productObject: e,
                    ))
                .toList(),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Show user info
                Text('Name: ${order.userName}',style: TextStyle(fontSize: 20.0),),
                Text('Phone: ${order.userPhone}',style: TextStyle(fontSize: 20.0),),
                Text('E-mail: ${order.userEmail}',style: TextStyle(fontSize: 20.0),),

                SizedBox(height: 20.0,),

                Text('Total cost: ৳${order.totalCost}',style: TextStyle(fontSize: 20.0),),

                SizedBox(height: 20.0,),

                ElevatedButton(
                    onPressed: () async {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Placing order')));
                      await order.place();
                      Navigator.of(context).pop();
                      showDialog(context: context, builder: (context) => AlertDialog(
                        title: Text('Order placed'),
                        content: Icon(Icons.markunread_mailbox_rounded),
                        actions: [
                          TextButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                              clearCart();
                            },
                            child: Text('Ok'),
                          )
                        ],
                      ));
                    },
                    child: Text('Confirm order')),
              ],
            ),
          )
        ]));
  }
}
