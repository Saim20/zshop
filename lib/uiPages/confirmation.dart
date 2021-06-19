import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:z_shop/data/data.dart';
import 'package:z_shop/services/order.dart';
import 'package:z_shop/uiElements/productCard.dart';

class ConfirmationPage extends StatefulWidget {
  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  List<String> paymentMethods = ['cod', 'bkash'];
  String selectedMethod = 'cod';
  bool takeFromAccount = true;
  TextEditingController addressC = TextEditingController();
  TextEditingController phoneC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Order order = data['order'];
    Function clearCart = data['clearcart'];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          iconTheme: IconThemeData(color: accentColor),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Container(
            margin: const EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 30.0),
            child: Text(
              'Confirm Order',
              style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.w300,
                  fontSize: 40.0),
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
                Text(
                  'Name: ${order.userName}',
                  style: TextStyle(fontSize: 20.0),
                ),
                Text(
                  'Phone: ${order.userPhone}',
                  style: TextStyle(fontSize: 20.0),
                ),
                Text(
                  'E-mail: ${order.userEmail}',
                  style: TextStyle(fontSize: 20.0),
                ),
                Text(
                  'Shipping address: ${order.userAddress}',
                  style: TextStyle(fontSize: 20.0),
                ),

                SizedBox(
                  height: 20.0,
                ),

                Text(
                  'Total cost: ৳${order.totalCost}',
                  style: TextStyle(fontSize: 20.0),
                ),

                SizedBox(
                  height: 20.0,
                ),

                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                      child: Container(
                        width: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? 600
                            : 500,
                        child: TextFormField(
                          keyboardType: TextInputType.streetAddress,
                          controller: addressC,
                          enabled: !takeFromAccount,
                          cursorColor: Colors.grey[800],
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.grey[600]),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              labelText: 'Shipping address'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                      child: Container(
                        width: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? 600
                            : 500,
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: phoneC,
                          enabled: !takeFromAccount,
                          cursorColor: Colors.grey[800],
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.grey[600]),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              labelText: 'Phone number'),
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Checkbox(
                        value: takeFromAccount,
                        onChanged: (value) {
                          setState(() {
                            takeFromAccount = value!;
                          });
                        }),
                    Text('Take address and phone from account'),
                  ],
                ),

                SizedBox(
                  height: 20.0,
                ),

                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Payment Method',
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text('Cash On Delivery'),
                      leading: Radio(
                        value: paymentMethods.elementAt(0),
                        groupValue: selectedMethod,
                        onChanged: (value) {
                          setState(() {
                            selectedMethod = value.toString();
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text('Bkash Payment'),
                      leading: Radio(
                        value: paymentMethods.elementAt(1),
                        groupValue: selectedMethod,
                        onChanged: (value) {
                          setState(() {
                            selectedMethod = value.toString();
                          });
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 20.0,
                ),

                ElevatedButton(
                    onPressed: () async {
                      if (!takeFromAccount) {
                        order.userAddress = addressC.text;
                        order.userPhone = phoneC.text;
                      }
                      if (selectedMethod == 'cod') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Placing order')));
                        await order.place();
                        Navigator.of(context).pop();
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Order placed'),
                            actions: [
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  clearCart();
                                },
                                label: Text('Ok'),
                                icon: Icon(
                                  Icons.check,
                                ),
                              )
                            ],
                          ),
                        );
                      } else if (selectedMethod == 'bkash') {
                        Navigator.of(context).pushReplacementNamed(
                          '/payment',
                          arguments: {
                            'order': order,
                            'clearCart': clearCart,
                          },
                        );
                      }
                    },
                    child: Text('Confirm order')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
