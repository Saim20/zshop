import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:z_shop/services/product.dart';

class Order {
  Order({required this.userName, required this.userEmail, required this.userPhone, required this.cartProducts});

  String userName;
  String userPhone;
  String userEmail;
  List<Product> cartProducts;

  Future<bool> place() async {
    try {
      bool exists = false;
      await FirebaseFirestore.instance.collection('orders').doc(userEmail).get().then((doc) {
        if (doc.exists)
          exists = true;
        else
          exists = false;
      });

      if(exists){
        await FirebaseFirestore.instance.collection('orders').doc(userEmail).update({
          'name': userName,
          'phone': userPhone,
        }).then((v) async {
          for (var product in cartProducts) {
            await FirebaseFirestore.instance.collection('orders').doc(userEmail).collection('products').add({
              'name': product.name,
              'price': product.offerPrice,
              'setupCost': product.setupCost,
              'deliveryCost': product.deliveryCost,
              'setupTaken': product.setupTaken,
              'deliveryTaken': product.deliveryTaken,
            });
          }
        });
      }else{
        await FirebaseFirestore.instance.collection('orders').doc(userEmail).set({
          'name': userName,
          'phone': userPhone,
        }).then((v) async {
          for (var product in cartProducts) {
            await FirebaseFirestore.instance.collection('orders').doc(userEmail).collection('products').add({
              'name': product.name,
              'price': product.offerPrice,
              'setupCost': product.setupCost,
              'deliveryCost': product.deliveryCost,
              'setupTaken': product.setupTaken,
              'deliveryTaken': product.deliveryTaken,
            });
          }
        });
      }

      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }
}
