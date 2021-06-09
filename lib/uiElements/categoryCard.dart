import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  CategoryCard({this.category});

  final String? category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.0),
      onTap: () {
        Navigator.of(context)
            .pushNamed('/products', arguments: {'category': category});
      },
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.all(15.0),
                child: Image.asset(
                  'assets/categoryIcons/$category.png',
                  width: 45.0,
                  height: 45.0,
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                category!,
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
