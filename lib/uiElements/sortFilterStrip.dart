import 'package:flutter/material.dart';
import 'package:z_shop/uiElements/myFilterColumn.dart';

import 'mySortColumn.dart';

class SortFilterStrip extends StatelessWidget {
  SortFilterStrip({
    required this.setDescendingValue,
    required this.setSortValue,
    required this.descending,
    required this.sort,
    required this.range,
    required this.filter,
    required this.setFilterValue,
    required this.setRangeValue,
    required this.min,
    required this.max,
  });

  final String sort;
  final bool descending;
  final ValueChanged<String> setSortValue;
  final ValueChanged<bool> setDescendingValue;
  final bool filter;
  final RangeValues? range;
  final ValueChanged<bool> setFilterValue;
  final ValueChanged<RangeValues> setRangeValue;
  final int min;
  final int max;


  @override
  Widget build(BuildContext context) {

    RangeValues? aRange = RangeValues(0.0, 0.0);

    void setRangeLocal(mrange){
      aRange = mrange;
    }
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
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text('Filter'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          if(aRange != null)
                            setRangeValue(aRange!);
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok')),
                  ],
                  content: MyFilterColumn(
                    filter: filter,
                    range: range!,
                    setFilterValue: setFilterValue,
                    setRangeValue: setRangeLocal,
                    min: min,
                    max: max,
                  ),
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
                  content: MySortColumn(
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
