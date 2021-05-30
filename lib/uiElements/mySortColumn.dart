import 'package:flutter/material.dart';

class MySortColumn extends StatefulWidget {

  MySortColumn({required this.sort,required this.descending,required this.setDescendingValue,required this.setSortValue});

  String sort;
  bool descending;
  ValueChanged<String> setSortValue;
  ValueChanged<bool> setDescendingValue;

  @override
  _MySortColumnState createState() => _MySortColumnState();
}

class _MySortColumnState extends State<MySortColumn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350.0,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          ListTile(
            title: Text('Name'),
            leading: Radio(
                value: 'name',
                groupValue: widget.sort,
                onChanged: (value) {
                  setState(() {
                    widget.sort = 'name';
                  });
                  widget.setSortValue('name');
                }),
          ),
          ListTile(
            title: Text('Price'),
            leading: Radio(
                value: 'offerPrice',
                groupValue: widget.sort,
                onChanged: (value) {
                  setState(() {
                    widget.sort = 'offerPrice';
                  });
                  widget.setSortValue('offerPrice');
                }),
          ),
          ListTile(
            title: Text('Rating'),
            leading: Radio(
                value: 'rating',
                groupValue: widget.sort,
                onChanged: (value) {
                  setState(() {
                    widget.sort = 'rating';
                  });
                  widget.setSortValue('rating');
                }),
          ),
          SizedBox(
            height: 40.0,
          ),
          ListTile(
            title: Text('Ascending'),
            leading: Radio(
                value: false,
                groupValue: widget.descending,
                onChanged: (value) {
                  setState(() {
                    widget.descending = false;
                  });
                  widget.setDescendingValue(false);
                }),
          ),
          ListTile(
            title: Text('Descending'),
            leading: Radio(
                value: true,
                groupValue: widget.descending,
                onChanged: (value) {
                  setState(() {
                    widget.descending = true;
                  });
                  widget.setDescendingValue(true);
                }),
          ),
        ],
      ),
    );
  }
}
