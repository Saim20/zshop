import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  CategoryCard({this.category});

  final String? category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed('/products', arguments: {'category': category});
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
        child: Card(
          child: ListTile(
            title: Text(category!),
            leading: Container(
              child: Image.asset(
                'assets/categoryIcons/$category.png',
                width: 30.0,
                height: 30.0,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
