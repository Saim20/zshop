import 'package:flutter/material.dart';

import 'myRadioColumn.dart';

class SortFilterStrip extends StatelessWidget {
  SortFilterStrip(
      {required this.setDescendingValue,
      required this.setSortValue,
      required this.descending,
      required this.sort});

  final String sort;
  final bool descending;
  final ValueChanged<String> setSortValue;
  final ValueChanged<bool> setDescendingValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 0.0),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text('Filter'),
                  content: Column(
                    children: [],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok')),
                  ],
                ),
              );
            },
            icon: Icon(Icons.filter_list),
            tooltip: 'Filter',
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text('Sort by'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok')),
                  ],
                  content: MyRadioColumn(
                    sort: sort,
                    descending: descending,
                    setSortValue: setSortValue,
                    setDescendingValue: setDescendingValue,
                  ),
                ),
              );
            },
            icon: Icon(Icons.sort),
            tooltip: 'Sort',
          ),
        ],
      ),
    );
  }
}
