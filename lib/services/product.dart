import 'dart:convert';

class Product {
  String id;
  String name;
  String description;
  String category;
  int quantity;
  int price;
  int offerPrice;
  int stock;
  int deliveryCost;
  int setupCost;
  double rating;
  int ratingCount;
  List<String>? images;
  bool setupTaken;
  bool deliveryTaken;

  String imageString;
  String productJson;

  Product(
      {this.name: '',
      this.description: '',
      this.images,
      this.id: '',
      this.category: '',
      this.imageString: '',
      this.offerPrice: 0,
      this.price: 0,
      this.quantity: 1,
      this.rating: 0.0,
      this.ratingCount: 0,
      this.deliveryCost: 0,
      this.setupCost: 0,
      this.productJson: '',
      this.stock: 0,
      this.setupTaken: false,
      this.deliveryTaken: false});

  void convert() {
    if (this.imageString == '')
      this.imageString = this
          .images
          .toString()
          .substring(1, this.images.toString().length - 2);
    else if (this.imageString != '')
      this.images = imageString.split(',').map((e) => e.trim()).toList();
  }

  String toString() {
    Map<String, String> data = {
      'name': this.name,
      'description': this.description,
      'imageString': this.imageString,
      'id': this.id,
      'rating': this.rating.toString(),
      'quantity': this.quantity.toString(),
      'category': this.category,
      'offerPrice': this.offerPrice.toString(),
      'ratingCount': this.ratingCount.toString(),
      'price': this.price.toString(),
      'deliveryCost': this.deliveryCost.toString(),
      'setupCost': this.setupCost.toString(),
      'stock': this.stock.toString(),
    };
    productJson = jsonEncode(data);
    return productJson;
  }

  bool toProduct() {
    if (productJson != '') {
      Map<String, dynamic> data =
          jsonDecode(productJson) as Map<String, dynamic>;
      this.name = data['name']!;
      this.description = data['description']!;
      this.imageString = data['imageString']!;
      this.id = data['id']!;
      this.quantity = int.parse(data['quantity']!);
      this.category = data['category']!;
      this.offerPrice = int.parse(data['offerPrice']!);
      this.ratingCount = int.parse(data['ratingCount']);
      this.price = int.parse(data['price']!);
      this.rating = double.parse(data['rating']);
      this.deliveryCost = int.parse(data['deliveryCost']!);
      this.setupCost = int.parse(data['setupCost']!);
      this.stock = int.parse(data['stock']!);
      convert();
      return true;
    }
    return false;
  }
}
