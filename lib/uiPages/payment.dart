// import 'dart:html';
// import 'dart:ui' as ui;

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
  WebViewXController? _controller;
  // IFrameElement iFrame = IFrameElement();

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

    // if (kIsWeb) {
    //   iFrame.src = '$paymentUrl?amount=${paymentRequest.amount}';
    //   iFrame.style.border = 'none';

    //   // iFrame.onLoad.listen((event) {
    //   //   String request = '{paymentRequest:$encodedRequest}';
    //   // });
    //   // ignore: undefined_prefixed_name
    //   ui.platformViewRegistry.registerViewFactory(
    //     'webpage',
    //     (int viewId) => iFrame,
    //   );
    // }

    return Container(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body:
            // kIsWeb
            //     ? Directionality(
            //         textDirection: TextDirection.ltr,
            //         child: Center(
            //           child: SizedBox(
            //             width: double.infinity,
            //             height: double.infinity,
            //             child: HtmlElementView(
            //               viewType: 'webpage',
            //             ),
            //           ),
            //         ),
            //       )
            //     :
            Container(
          child: WebViewX(
            javascriptMode: JavascriptMode.unrestricted,
            webSpecificParams: WebSpecificParams(
              webAllowFullscreenContent: true,
              additionalSandboxOptions: ['allow-same-origin'],
            ),
            onWebViewCreated: (WebViewXController controller) {
              _controller = controller;
            },
            // javascriptChannels: [
            //   getData(context, clearCart, order),
            // ].toSet(),
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
      },
    );
  }
}
