import 'package:flutter/material.dart';

class DummyGridCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      splashColor: Colors.purpleAccent,
      focusColor: Colors.blue[100],
      hoverColor: Colors.blue[100],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 34.0),
        child: Card(
          color: Colors.grey[100],
          elevation: 15.0,
          shadowColor: Colors.grey[50],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      height: 150,
                      width: 250,
                      color: Colors.grey,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 10.0,
                      width: 70.0,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(3.0, 0.0, 0.0, 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0.0, 3.0, 10.0, 2.0),
                                  height: 9.0,
                                  width: 40.0,
                                  color: Colors.grey,
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 2.0),
                                  height: 8.0,
                                  width: 30.0,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            width: 70.0,
                          ),
                          Container(
                            height: 10.0,
                            width: 30.0,
                            color: Colors.grey,
                          ),
                          IconButton(
                              icon: Icon(Icons.check_box_outline_blank,color: Colors.grey,),
                              onPressed:(){},
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
