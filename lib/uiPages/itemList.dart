import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:z_shop/uiElements/floatingSearchBar.dart';
import 'package:z_shop/uiElements/productCard.dart';
import 'package:z_shop/uiElements/sortFilterStrip.dart';

class ItemListPage extends StatefulWidget {
  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  String sort = 'name';
  bool descending = false;
  bool filter = false;
  RangeValues range = RangeValues(0.0, 0.0);
  bool onceFlag = false;
  int min = 0;
  int max = 0;

  setSortValue(value) {
    setState(() {
      sort = value;
    });
  }

  setDescendingValue(value) {
    setState(() {
      descending = value;
    });
  }

  setFilterValue(value) {
    setState(() {
      filter = value;
    });
  }

  setRangeValue(mrange) {
    setState(() {
      range = mrange;
    });
  }

  @override
  Widget build(BuildContext context) {
    var data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String category = data['category'];

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            iconTheme: IconThemeData(color: Colors.blue),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            title: Container(
              margin: const EdgeInsets.fromLTRB(0.0, 30.0, 30.0, 30.0),
              child: Text(
                category,
                style: GoogleFonts.roboto(
                    color: Colors.blue,
                    fontWeight: FontWeight.w300,
                    fontSize: 25.0),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                child: IconButton(
                    icon: Hero(
                      tag: 'cartHero',
                      child: Icon(
                        Icons.shopping_cart,
                        color: Colors.blue,
                        size: 30.0,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/cart');
                    }),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 0.0),
                child: IconButton(
                    icon: Hero(
                      tag: 'accountHero',
                      child: Icon(
                        Icons.account_circle,
                        color: Colors.blue,
                        size: 30.0,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/account');
                    }),
              )
            ],
          ),
        ),
        body: Stack(
          children: [
            FutureBuilder<QuerySnapshot>(
              future: firestore
                  .collection('products')
                  .where('category', isEqualTo: category)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(
                    child: Text('Connection Problem!'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isNotEmpty) {

                      sortDocsForMinMax(snapshot.data!.docs);

                      List<QueryDocumentSnapshot> docs =
                          sortDocs(snapshot.data!.docs);
                      if(filter){
                        docs = filterDocs(docs);
                      }

                      return Container(
                        child: ListView(children: [
                          SortFilterStrip(
                            sort: sort,
                            descending: descending,
                            setSortValue: setSortValue,
                            setDescendingValue: setDescendingValue,
                            filter: filter,
                            range: range,
                            setFilterValue: setFilterValue,
                            setRangeValue: setRangeValue,
                            min: min,
                            max: max,
                          ),
                          Column(
                            children: docs.map((e) {
                              return ProductCard(
                                prod: e,
                              );
                            }).toList(),
                          )
                        ]),
                      );
                    } else
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.remove_shopping_cart,
                              color: Colors.blue,
                              size: 50.0,
                            ),
                          ],
                        ),
                      );
                  }
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80.0,
                      child: SpinKitSquareCircle(
                        color: Colors.blueAccent,
                        size: 50.0,
                      ),
                    ),
                    Text(
                      'Loading',
                      style:
                          TextStyle(fontSize: 25.0, color: Colors.blueAccent),
                    )
                  ],
                );
              },
            ),
            MyFloationgSearchBar(),
          ],
        ));
  }

  List<QueryDocumentSnapshot> sortDocs(List<QueryDocumentSnapshot> docs) {

    List<QueryDocumentSnapshot> sortedDocs = [];

    if (sort == 'name') {
      docs.sort((a, b) => a.data()['name'].toString().compareTo(b.data()['name'].toString()));
      sortedDocs = docs;
    }
    else if (sort == 'offerPrice') {
      docs.sort((a, b) => a.data()['offerPrice'].compareTo(b.data()['offerPrice']));
      sortedDocs = docs;
    }
    else if (sort == 'rating') {}
    if (descending) {
      return sortedDocs.reversed.toList();
    }
    return sortedDocs;
  }
  void sortDocsForMinMax(List<QueryDocumentSnapshot> docs) {
    docs.sort((a, b) => a.data()['offerPrice'].compareTo(b.data()['offerPrice']));
    min = docs.first.data()['offerPrice'];
    max = docs.last.data()['offerPrice'];
    if(!onceFlag){
      onceFlag = true;
      range = RangeValues(min.toDouble(),max.toDouble());
    }
  }
  List<QueryDocumentSnapshot> filterDocs(List<QueryDocumentSnapshot> docs) {
    List<String> ids = [];
    for(var doc in docs){
      if(doc.data()['offerPrice'] < range.start.ceil()){
        ids.add(doc.id);
      }
      if(doc.data()['offerPrice'] > range.end.ceil()){
        ids.add(doc.id);
      }
    }
    for(var id in ids){
      docs.removeWhere((element) => element.id == id);
    }
    return docs;
  }
}
