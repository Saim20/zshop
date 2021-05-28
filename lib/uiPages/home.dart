import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:z_shop/uiElements/categoryCard.dart';
import 'package:z_shop/uiElements/dummyGridCard.dart';
import 'package:z_shop/uiElements/floatingSearchBar.dart';
import 'package:z_shop/uiElements/productGridCard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
              'Zshop',
              style: GoogleFonts.roboto(
                  color: Colors.blue,
                  fontWeight: FontWeight.w300,
                  fontSize: 40.0),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
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
              padding: const EdgeInsets.fromLTRB(0.0, 15.0, 10.0, 0.0),
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
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Stack(
        fit: StackFit.expand,
        children: [
          buildListView(),
          MyFloationgSearchBar(),
        ],
      ),
    );
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final List<String> categories = [
    'Electronics',
    'Food',
    'Furniture',
    'Crockeries',
    'Tools and Accessories',
    'Others',
    'Pump and Machineries',
    'Gifts and Toys',
    'Bicylce and Tricycle',
    'Fashion'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildListView() {
    return ListView(
      children: [
        SizedBox(height:60.0,),
        FutureBuilder<QuerySnapshot>(
          future: firestore.collection('products').get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<QueryDocumentSnapshot> featured = [];
                for (var prod in snapshot.data!.docs) {
                  if (prod.data()['featured']) {
                    featured.add(prod);
                  }
                }

                return Container(
                  height: 320,
                  child: GridView(
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1),
                      children: featured
                          .map((e) => ProductGridCard(
                                prod: e,
                              ))
                          .toList()),
                );
              } else {
                return Container(
                    height: 320.0, child: Center(child: Text('Nothing found')));
              }
            }
            List<DummyGridCard> dummies = [];
            for (int i = 0; i < 5; i++) {
              dummies.add(new DummyGridCard());
            }
            return Container(
              height: 320,
              child: GridView(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1),
                  children: dummies
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(35.0, 20.0, 35.0, 20.0),
          child: Text(
            'Categories',
            style: TextStyle(fontSize: 25.0),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: categories
              .map((e) => CategoryCard(
                    category: e,
                  ))
              .toList(),
        ),
      ],
    );
  }
}
