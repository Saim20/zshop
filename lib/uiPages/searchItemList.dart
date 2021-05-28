import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
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
          iconTheme: IconThemeData(color: Colors.blue),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Container(
            margin: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
            child: Text(
              name,
              style: GoogleFonts.roboto(
                  color: Colors.blue,
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
                .orderBy(sort, descending: descending)
                .get(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

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
                    if (docs.isNotEmpty)
                      return Container(
                        child: ListView(
                          children: [
                            SortFilterStrip(
                              sort: sort,
                              descending: descending,
                              setSortValue: setSortValue,
                              setDescendingValue: setDescendingValue,
                            ),
                            Column(
                              children: docs.map((e) {
                                return ProductCard(
                                  prod: e,
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      );
                    else
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
                    style: TextStyle(fontSize: 25.0, color: Colors.blueAccent),
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
}
