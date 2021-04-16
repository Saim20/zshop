import 'package:flutter/material.dart';

class MessagesFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Center(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
            child: Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
          Divider(
            height: 20.0,
            thickness: 1.0,
            indent: 50.0,
            endIndent: 50.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  TextButton.icon(onPressed: () {}, icon: Icon(
                    Icons.phone
                  ), label: Text('Call us'))
                ],
              ),
              Column(
                children: [
                  TextButton.icon(onPressed: () {}, icon: Icon(
                      Icons.alternate_email
                  ), label: Text('Mail us'))
                ],
              )
            ],
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'We are here to answer all your questions. If you are unable to find the answer to your problem in our faq section, feel free to contact us',
            ),
          )
        ],
      ),
    );
  }
}
