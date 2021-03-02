import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../screens/home/contactsPage.dart';

import 'manage_group.dart';
import '../models/group.dart';

class ChatGroup extends StatefulWidget {
  final Group group;

  ChatGroup(this.group);

  String uid;

  @override
  _ChatGroupState createState() => _ChatGroupState();
}

class _ChatGroupState extends State<ChatGroup> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  final firestoreInstance = Firestore.instance;
  final userCollection = Firestore.instance.collection('groups');

  final ref =
      FirebaseDatabase.instance.reference().child('Groups').child('Group1');
  FirebaseAuth auth = FirebaseAuth.instance;

  final refF = Firestore.instance.document('Groups');

  FirebaseUser user;
  String imageUrl;
  String nameGroup;

//  void s() {
//    firestoreInstance.collection("groups").getDocuments().then((querySnapshot) {
//      querySnapshot.documents.forEach((result) {
//        result.data["image"];
//      });
//    });
//  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: ManageGroup(widget.group),
      ),
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.amberAccent,
        elevation: 0.0,
        title: Row(
          children: <Widget>[
            StreamBuilder(
              stream: Firestore.instance.collection('groups').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //  imageUrl = snapshot.data.documents[0]['image'];
                  firestoreInstance
                      .collection("groups")
                      .getDocuments()
                      .then((querySnapshot) {
                    querySnapshot.documents.forEach((result) {
                      imageUrl = result.data["image"];
                    });
                  });
                }
                return Container(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        print('downloadUrl: $imageUrl');
                      });
                    },
                    child: CircleAvatar(
                        backgroundImage: imageUrl == null
                            ? AssetImage('image/avatar.jpg')
                            : NetworkImage('$imageUrl')),
                  ),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Expanded(
              child: Text(
//                      '$nameGroup',
                widget.group.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        // leading: CupertinoButton(
        //     onPressed: () async {
        //       var authF = await FirebaseAuth.instance.currentUser();
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => ContactsPage(authF.uid)));
        //     },
        //     child: Icon(
        //       Icons.keyboard_backspace,
        //       color: Colors.black,
        //     )),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.phone, color: Colors.black),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.video_call, color: Colors.black),
            onPressed: null,
          ),
          IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                _scaffoldKey.currentState.openEndDrawer();
              }),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            child: FlatButton(
              onPressed: () async {
                user = await FirebaseAuth.instance.currentUser();
                setState(() {
                  userCollection.document(user.uid).setData({
                    'uid': user.uid,
                    'name': 'Group Chat',
                    'member': 'list member',
                  });
                });
              },
              child: Icon(Icons.group_work),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextField(
              style: TextStyle(fontSize: 18, color: Colors.black),
              decoration: InputDecoration(
                  labelText: "Message",
                  prefixIcon:
                      Container(width: 50, child: Icon(Icons.speaker_notes)),
                  suffixIcon: Container(width: 50, child: Icon(Icons.send)),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffCED0D2), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(6)))),
            ),
          ),
        ],
      ),
    );
  }
}
