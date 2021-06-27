import 'package:flutter/material.dart';

class DummyGridCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30.0),
      onTap: null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 60.0),
        child: Card(
          color: Colors.grey[100],
          elevation: 30.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Container(
                      height: 150,
                      width: 250,
                      color: Colors.grey[200],
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: Column(
                  children: [
                    Container(
                      height: 10.0,
                      width: 70.0,
                      color: Colors.grey[200],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(3.0, 0.0, 0.0, 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(0.0, 3.0, 10.0, 2.0),
                                height: 9.0,
                                width: 40.0,
                                color: Colors.grey[200],
                              ),
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                                height: 8.0,
                                width: 30.0,
                                color: Colors.grey[200],
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
                            height: 10.0,
                            width: 30.0,
                            color: Colors.grey[200],
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.circle,
                              color: Colors.grey[200],
                            ),
                            onPressed: () {},
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
