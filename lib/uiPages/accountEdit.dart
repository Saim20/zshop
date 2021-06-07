import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:z_shop/data/data.dart';
import 'package:z_shop/services/user.dart';

class AccountEditPage extends StatefulWidget {
  @override
  _AccountEditPageState createState() => _AccountEditPageState();
}

class _AccountEditPageState extends State<AccountEditPage> {
  ZshopUser? user;

  @override
  Widget build(BuildContext context) {
    var data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    user = data['user'];

    return Container(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: AppBar(
              iconTheme: IconThemeData(color: accentColor),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              title: Text(
                'Edit',
                style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.w300,
                    fontSize: 35.0),
              ),
            ),
          ),
        ),
        body: ListView(
          children: [
            MyAccountForm(
              user: user!,
            ),
          ],
        ),
      ),
    );
  }
}

class MyAccountForm extends StatefulWidget {
  MyAccountForm({
    required this.user,
  });

  final ZshopUser user;

  @override
  _MyAccountFormState createState() => _MyAccountFormState(user: user);
}

class _MyAccountFormState extends State<MyAccountForm> {
  _MyAccountFormState({
    required this.user,
  });

  final _formKey = GlobalKey<FormState>();

  ZshopUser user;

  bool emailIsInvalid = false;
  bool isEmailAlreadySignedUp = false;
  bool showPassword = false;
  bool hasChanged = false;
  bool wrongPasswordEntered = false;

  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController addressC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController newPassC = TextEditingController();
  TextEditingController oldPassC = TextEditingController();

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    addressC.dispose();
    phoneC.dispose();
    newPassC.dispose();
    oldPassC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!hasChanged) {
      nameC.text = user.name;
      phoneC.text = user.phone;
      emailC.text = user.email;
      addressC.text = user.address;
      newPassC.text = '';
      oldPassC.text = '';
    }

    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
              child: Container(
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      checkChanged();
                    });
                  },
                  controller: nameC,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
              child: Container(
                child: TextFormField(
                  controller: emailC,
                  onChanged: (value) {
                    setState(() {
                      checkChanged();
                      emailIsInvalid = false;
                      isEmailAlreadySignedUp = false;
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'E-mail'),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter an e-mail';
                    else if (emailIsInvalid) {
                      return 'Please enter a valid e-mail';
                    } else if (isEmailAlreadySignedUp) {
                      return 'E-mail is already used';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
              child: Container(
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      checkChanged();
                    });
                  },
                  controller: addressC,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Shipping Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter your shipping address';
                    return null;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
              child: Container(
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      checkChanged();
                    });
                  },
                  keyboardType: TextInputType.phone,
                  controller: phoneC,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Phone'),
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 10.0, 10.0, 0.0),
              child: Text('Only enter if you want to change password'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
              child: Container(
                child: TextFormField(
                  enableSuggestions: false,
                  onChanged: (value) {
                    setState(() {
                      wrongPasswordEntered = false;
                      checkChanged();
                      _formKey.currentState!.validate();
                    });
                  },
                  controller: oldPassC,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Previous password'),
                  validator: (value) {
                    if (wrongPasswordEntered) {
                      return 'Wrong password';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
              child: Container(
                child: TextFormField(
                  enableSuggestions: false,
                  onChanged: (value) {
                    setState(() {
                      checkChanged();
                    });
                  },
                  controller: newPassC,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Change password'),
                  validator: (value) {
                    return null;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 30.0, 0.0, 0.0),
              child: ElevatedButton(
                onPressed: hasChanged
                    ? () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('Saving')));

                          // Change password
                          if (newPassC.text.isNotEmpty) {
                            if (await changePassword()) {
                              updateAccount();
                            }
                          } else {
                            updateAccount();
                          }
                        }
                      }
                    : null,
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  checkChanged() {
    hasChanged = false;
    if (user.name != nameC.text) {
      hasChanged = true;
    }
    if (user.email != emailC.text) {
      hasChanged = true;
    }
    if (user.phone != phoneC.text) {
      hasChanged = true;
    }
    if (user.address != addressC.text) {
      hasChanged = true;
    }
    if (newPassC.text != '') {
      hasChanged = true;
    }
    if (oldPassC.text != '') {
      hasChanged = true;
    }
  }

  Future<bool> validatePassword() async {
    var authCredential = EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email!,
        password: oldPassC.text);
    try {
      var authResult = await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(authCredential);
      return authResult.user != null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changePassword() async {
    try {
      if (await validatePassword()) {
        await FirebaseAuth.instance.currentUser!.updatePassword(newPassC.text);
        newPassC.clear();
        oldPassC.clear();
        return true;
      } else {
        setState(() {
          wrongPasswordEntered = true;
          _formKey.currentState!.validate();
        });
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  updateAccount() async {
    try {
      await FirebaseAuth.instance.currentUser!.updateEmail(emailC.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        setState(() {
          emailIsInvalid = true;
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          isEmailAlreadySignedUp = true;
        });
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update')));
      print(e);
      return;
    }
    try {
      await FirebaseAuth.instance.currentUser!.updateDisplayName(nameC.text);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'phone': phoneC.text,
        'address': addressC.text,
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update')));
      print(e);
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Successfully saved')));
  }
}
