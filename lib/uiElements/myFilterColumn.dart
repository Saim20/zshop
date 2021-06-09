import 'package:flutter/material.dart';

class MyFilterColumn extends StatefulWidget {
  MyFilterColumn({
    required this.filter,
    required this.range,
    required this.setFilterValue,
    required this.setRangeValue,
    required this.min,
    required this.max,
  });

  final bool filter;
  final RangeValues range;
  final ValueChanged<bool> setFilterValue;
  final ValueChanged<RangeValues> setRangeValue;
  final int min;
  final int max;

  @override
  _MyFilterColumnState createState() => _MyFilterColumnState(
        filter: filter,
        range: range,
        min: min,
        max: max,
      );
}

class _MyFilterColumnState extends State<MyFilterColumn> {
  _MyFilterColumnState(
      {required this.filter,
      required this.range,
      required this.min,
      required this.max});

  bool filter;
  bool once = true;
  RangeValues range;
  int min;
  int max;

  @override
  Widget build(BuildContext context) {
    if (once) {
      widget.setRangeValue(range);
      once = false;
    }
    return Container(
      height: 350.0,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          ListTile(
            leading: Checkbox(
              onChanged: (value) {
                widget.setFilterValue(value!);
                setState(() {
                  filter = value;
                });
              },
              value: filter,
            ),
            title: Text('By Price'),
          ),
          if (filter)
            RangeSlider(
              values: range,
              onChanged: (value) {
                setState(() {
                  range = value;
                });
                widget.setRangeValue(range);
              },
              min: min.toDouble(),
              max: max.toDouble(),
              divisions: (max / 10).floor(),
              labels:
                  RangeLabels('${range.start.ceil()}', '${range.end.ceil()}'),
            ),
          if (filter)
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Min: ' + range.start.ceil().toString()),
                  Text('Max: ' + range.end.ceil().toString()),
                ],
              ),
            )
        ],
      ),
    );
  }
}
