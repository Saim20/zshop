import 'package:flutter/material.dart';
import 'package:z_shop/data/data.dart';

class CategoryCard extends StatelessWidget {
  CategoryCard({this.category});

  final BorderRadius myRadius = BorderRadius.only(
    topLeft: Radius.circular(50.0),
    topRight: Radius.circular(100.0),
    bottomLeft: Radius.circular(50.0),
    bottomRight: Radius.circular(50.0),
  );
  final String? category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: myRadius,
      onTap: () {
        Navigator.of(context)
            .pushNamed('/products', arguments: {'category': category});
      },
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Card(
          elevation: 30.0,
          shape: RoundedRectangleBorder(
            borderRadius: myRadius,
          ),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: myRadius,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accentColor.withAlpha(200),
                    Colors.purple[400]!,
                  ],
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(20.0),
                      child: Image.asset(
                        'assets/categoryIcons/$category.png',
                        width: 45.0,
                        height: 45.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      category!,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Icon(
                    Icons.arrow_right_alt_rounded,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
