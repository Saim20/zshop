import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:z_shop/services/fragmentInitialization.dart';
import 'package:z_shop/uiPages/fragments/itemList.dart';

class HomePage extends StatefulWidget {

  HomePage({this.onSelectProduct,this.onAccountIconClick});

  final ValueChanged<bool?>? onAccountIconClick;
  final ValueChanged<QueryDocumentSnapshot?>? onSelectProduct;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedItem = 0;

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
              padding: const EdgeInsets.fromLTRB(0.0, 15.0, 20.0, 0.0),
              child: IconButton(
                  icon: Icon(
                    Icons.account_circle,
                    color: Colors.blue,
                    size: 30.0,
                  ),
                  onPressed: () {
                    widget.onAccountIconClick!(true);
                  }),
            )
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: selectedItem == 0 ? ItemListFragment(onSelectProduct: widget.onSelectProduct) : fragments.elementAt(selectedItem),
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Products',
                backgroundColor: Colors.blue[100]),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
                backgroundColor: Colors.green[100]),
          ],
          unselectedItemColor: Colors.grey,
          currentIndex: selectedItem,
          selectedItemColor: Colors.blue[500],
          showUnselectedLabels: false,
          type: BottomNavigationBarType.shifting,
          onTap: (index) {
            setState(() {
              selectedItem = index;
            });
          }),
    );
  }
}
