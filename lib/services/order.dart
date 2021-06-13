import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:z_shop/services/product.dart';

class Order {
  Order({
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.cartProducts,
    required this.userAddress,
    required this.totalCost,
    required this.userId,
    required this.paymentMethod,
    this.paymentStatus: 'Unpaid',
    this.transactionId: '',
    this.paymentTime: '',
  });

  String userName;
  String userPhone;
  String userEmail;
  String userAddress;
  String userId;
  String paymentMethod;
  String paymentStatus;
  String? transactionId;
  String? paymentTime;
  int totalCost;
  List<Product> cartProducts;

  Future<bool> place() async {
    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'name': userName,
        'phone': userPhone,
        'email': userEmail,
        'uid': userId,
        'address': userAddress,
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'transactionId': transactionId,
        'paymentTime': paymentTime,
        'status': 'placed',
      }).then((v) async {
        for (var product in cartProducts) {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(v.id)
              .collection('products')
              .add({
            'name': product.name,
            'price': product.offerPrice,
            'setupCost': product.setupCost,
            'deliveryCost': product.deliveryCost,
            'setupTaken': product.setupTaken,
            'deliveryTaken': product.deliveryTaken,
            'quantity': product.quantity,
            'id': product.id,
          });
        }
      });
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }
}
