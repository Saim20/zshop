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

  bool filter;
  RangeValues? range;
  ValueChanged<bool> setFilterValue;
  ValueChanged<RangeValues> setRangeValue;
  int min;
  int max;

  @override
  _MyFilterColumnState createState() => _MyFilterColumnState();
}

class _MyFilterColumnState extends State<MyFilterColumn> {

  @override
  Widget build(BuildContext context) {

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
                  widget.filter = value;
                });
              },
              value: widget.filter,
            ),
            title: Text('By Price'),
          ),
          if (widget.filter)
            RangeSlider(
              values: widget.range!,
              onChanged: (value) {
                setState(() {
                  widget.range = value;
                });
                widget.setRangeValue(widget.range!);
              },
              min: widget.min.toDouble(),
              max: widget.max.toDouble(),
              divisions: (widget.max/10).floor(),
              labels: RangeLabels('${widget.range!.start.ceil()}','${widget.range!.end.ceil()}'),
            ),
          if(widget.filter)
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Min: ' + widget.range!.start.ceil().toString()),
                Text('Max: ' +widget.range!.end.ceil().toString()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
