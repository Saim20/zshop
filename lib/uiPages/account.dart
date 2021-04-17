import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: AppBar(
            iconTheme: IconThemeData(color: Colors.blue),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text(
              'Account',
              style: TextStyle(
                fontSize: 35.0,
                color: Colors.blue,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20.0,
          ),
          Center(
            child: SizedBox(
              height: 150.0,
              width: 150.0,
              child: Hero(
                tag: 'accountHero',
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/user.png'
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
            child: Text(
              'User Name',
              style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.w300),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 10.0),
            child: Text(
              'example@example.exa',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300,color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 10.0),
            child: Text(
              'Address: example street, example town, example city',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300,color: Colors.grey),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {  },
        child: Icon(
          Icons.edit
        ),
      ),
    );
  }
}
