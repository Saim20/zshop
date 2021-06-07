import 'package:flutter/material.dart';

class MySortColumn extends StatefulWidget {
  MySortColumn(
      {required this.sort,
      required this.descending,
      required this.setDescendingValue,
      required this.setSortValue});

  final String sort;
  final bool descending;
  final ValueChanged<String> setSortValue;
  final ValueChanged<bool> setDescendingValue;

  @override
  _MySortColumnState createState() => _MySortColumnState(
    sort: sort,
    descending: descending,
  );
}

class _MySortColumnState extends State<MySortColumn> {
  _MySortColumnState({
    required this.sort,
    required this.descending,
  });

  String sort;
  bool descending;

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
                groupValue: sort,
                onChanged: (value) {
                  setState(() {
                    sort = 'name';
                  });
                  widget.setSortValue('name');
                }),
          ),
          ListTile(
            title: Text('Price'),
            leading: Radio(
                value: 'offerPrice',
                groupValue: sort,
                onChanged: (value) {
                  setState(() {
                    sort = 'offerPrice';
                  });
                  widget.setSortValue('offerPrice');
                }),
          ),
          ListTile(
            title: Text('Rating'),
            leading: Radio(
                value: 'rating',
                groupValue: sort,
                onChanged: (value) {
                  setState(() {
                    sort = 'rating';
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
                groupValue: descending,
                onChanged: (value) {
                  setState(() {
                    descending = false;
                  });
                  widget.setDescendingValue(false);
                }),
          ),
          ListTile(
            title: Text('Descending'),
            leading: Radio(
                value: true,
                groupValue: descending,
                onChanged: (value) {
                  setState(() {
                    descending = true;
                  });
                  widget.setDescendingValue(true);
                }),
          ),
        ],
      ),
    );
  }
}
