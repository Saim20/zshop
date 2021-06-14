// ignore: unused_import
// import 'dart:html' as html;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';
import 'package:z_shop/data/data.dart';
import 'package:z_shop/services/order.dart';
import 'package:z_shop/services/paymentRequest.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int totalCost = 0;

  @override
  Widget build(BuildContext context) {
    var data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Order order = data['order'];
    Function clearCart = data['clearCart'];
    totalCost = order.totalCost;

    PaymentRequest paymentRequest =
        PaymentRequest(amount: totalCost, intent: 'sale');
    String encodedRequest = paymentRequest.toString();

    //TODO Uncomment for web build

//     if (kIsWeb) {
//       html.WindowBase _popupWin;

// // Our current app URL
//       final currentUri = Uri.base;

// // Generate the URL redirection to our receiver.html page
//       final redirectUri = Uri(
//         host: currentUri.host,
//         scheme: currentUri.scheme,
//         port: currentUri.port,
//         path: '/receiver.html',
//       );

// // Full target URL with parameters
//       final requestUrl = '$paymentUrl?amount=${paymentRequest.amount}';

// // Open window
//       _popupWin = html.window.open(
//           requestUrl, "Bkash Payment", "width=800, height=900, scrollbars=yes");

//       /// Listen to message send with `postMessage`.
//       html.window.onMessage.listen((event) {
//         _popupWin.close();
//         processData(event.data, order, clearCart);
//       });
//     }

    return Container(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: kIsWeb
            ? Center(
                child: Container(
                  child: Column(children: [
                    
                  ],),
                ),
              )
            : Container(
                child: WebViewX(
                  javascriptMode: JavascriptMode.unrestricted,
                  dartCallBacks: {
                    getData(context, clearCart, order),
                  },
                  initialContent: '$paymentUrl?amount=${paymentRequest.amount}',
                  initialSourceType: SourceType.URL,
                ),
              ),
      ),
    );
  }

  DartCallback getData(BuildContext context, Function clearCart, Order order) {
    return DartCallback(
      name: 'getResponse',
      callBack: (response) async {
        processData(response, order, clearCart);
      },
    );
  }

  processData(response, order, clearCart) async {
    print(response);
    var data = jsonDecode(response);
    order.paymentMethod = 'Bkash';
    order.transactionId = data['trxID'];
    order.paymentStatus = 'Paid';
    order.paymentTime = data['updateTime'];
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
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
