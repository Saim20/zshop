import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:z_shop/data/data.dart';
import 'package:z_shop/uiElements/floatingSearchBar.dart';
import 'package:z_shop/uiElements/productCard.dart';
import 'package:z_shop/uiElements/sortFilterStrip.dart';

class SearchItemListPage extends StatefulWidget {
  @override
  State<SearchItemListPage> createState() => _SearchItemListPageState();
}

class _SearchItemListPageState extends State<SearchItemListPage> {
  String sort = 'name';
  bool descending = false;
  bool filter = false;
  RangeValues range = RangeValues(0.0, 0.0);
  int min = 0;
  int max = 0;
  bool onceFlag = false;

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
    String name = data['term'];

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          iconTheme: IconThemeData(color: accentColor),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Container(
            margin: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
            child: Text(
              name,
              style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.w300,
                  fontSize: 35.0),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
              child: IconButton(
                  icon: Hero(
                    tag: 'cartHero',
                    child: Icon(
                      cartIcon,
                      color: cartColor,
                      size: 30.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/cart');
                  }),
            ),
            if (FirebaseAuth.instance.currentUser != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                child: IconButton(
                  tooltip: 'Orders',
                  icon: Hero(
                    tag: 'orderHero',
                    child: Icon(
                      orderIcon,
                      color: orderColor,
                      size: 30.0,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/orders');
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 0.0),
              child: IconButton(
                  icon: Hero(
                    tag: 'accountHero',
                    child: Icon(
                      accountIcon,
                      color: accountColor,
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
                .orderBy(sort, descending: descending)
                .get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return Center(
                  child: Text('Connection Problem!'),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    List<QueryDocumentSnapshot> docs = [];
                    for (var each in snapshot.data!.docs) {
                      if (each
                          .data()['name']
                          .toString()
                          .toUpperCase()
                          .contains(name.toUpperCase())) {
                        docs.add(each);
                      }
                    }

                    if (docs.isNotEmpty) {
                      sortDocsForMinMax(snapshot.data!.docs);

                      if (filter) {
                        docs = filterDocs(docs);
                      }

                      return Column(children: [
                        SortFilterStrip(
                          sort: sort,
                          descending: descending,
                          setSortValue: setSortValue,
                          setDescendingValue: setDescendingValue,
                          filter: filter,
                          range: range,
                          setRangeValue: setRangeValue,
                          setFilterValue: setFilterValue,
                          min: min,
                          max: max,
                        ),
                        Expanded(
                          child: ListView(
                            children: docs.map((e) {
                              return ProductCard(
                                prod: e,
                              );
                            }).toList(),
                          ),
                        ),
                      ]);
                    } else
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.remove_shopping_cart,
                              color: accentColor,
                              size: 50.0,
                            ),
                          ],
                        ),
                      );
                  }
                }
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80.0,
                    child: SpinKitSquareCircle(
                      color: accentColor,
                      size: 50.0,
                    ),
                  ),
                  Text(
                    'Loading',
                    style: TextStyle(fontSize: 25.0, color: accentColor),
                  ),
                ],
              );
            },
          ),
          MyFloationgSearchBar(),
        ],
      ),
    );
  }

  void sortDocsForMinMax(List<QueryDocumentSnapshot> docs) {
    docs.sort(
        (a, b) => a.data()['offerPrice'].compareTo(b.data()['offerPrice']));
    min = docs.first.data()['offerPrice'];
    max = docs.last.data()['offerPrice'];
    if (!onceFlag) {
      onceFlag = true;
      range = RangeValues(min.toDouble(), max.toDouble());
    }
  }

  List<QueryDocumentSnapshot> filterDocs(List<QueryDocumentSnapshot> docs) {
    List<String> ids = [];
    for (var doc in docs) {
      if (doc.data()['offerPrice'] < range.start.ceil()) {
        ids.add(doc.id);
      }
      if (doc.data()['offerPrice'] > range.end.ceil()) {
        ids.add(doc.id);
      }
    }
    for (var id in ids) {
      docs.removeWhere((element) => element.id == id);
    }
    return docs;
  }
}
