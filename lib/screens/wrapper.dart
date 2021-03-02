import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/screens/authenticate/authenticate.dart';
import 'package:brew_crew/screens/home/homeScreen.dart';
import 'package:brew_crew/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loading_view.dart';

class Wrapper extends StatefulWidget {
  String uid;
  Wrapper(this.uid);
  @override
  _WrapperState createState() => _WrapperState(uid: this.uid);
}

class _WrapperState extends State<Wrapper> {
  String uid;
  _WrapperState({this.uid});
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // print(user);
    // return either the Home or Authenticate widget
    return FutureBuilder(
      future: getCurrentUser(),
      builder: (context, snapshot) {
        if (user == null && snapshot.data == null)
          return Authenticate();
        else
          return StreamProvider<User>.value(
            value: DatabaseService(uid: this.uid != null ? this.uid : user.uid)
                .user,
            child: FutureBuilder(
              future:
                  DatabaseService(uid: this.uid != null ? this.uid : user.uid)
                      .getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loading();
                } else {
                  User currentUser = snapshot.data;
                  // print(currentUser.name);
                  return HomeScreen(
                      user != null ? user.uid : snapshot.data.uid);
                }
              },
            ),
          );
      },
    );
    // return FutureBuilder(
    //   future: getCurrentUser(),
    //   builder: (context, snapshot) {
    //     print(snapshot.data);
    //     if (user == null && snapshot.data == null)
    //       return Authenticate();
    //     else
    //       return HomeScreen();
    //   },
    // );
  }

  Future getCurrentUser() async {
    return await Firestore.instance
        .collection('currentUser')
        .document(this.uid)
        .get()
        .then((value) {
      return User(uid: value.data['uid']);
    });
  }
}
