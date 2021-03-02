import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'chat_group.dart';
import '../models/group.dart';

class RenameDialog {
  static void showRenameDialog(BuildContext context) {
    final Group group = new Group(id: '', name: '', contacts: [], avatar: '');

    var ref =
        FirebaseDatabase.instance.reference().child('Groups').child('Group1');
    final userCollection = Firestore.instance.collection('groups');
    final refF = Firestore.instance.document('Groups');

    TextEditingController _nameGroupController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Rename',
          style: TextStyle(color: Colors.black),
        ),
        content: TextField(
          controller: _nameGroupController,
          style: TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
              prefixIcon: Container(
                  width: 50,
                  child:
                  Icon(Icons.drag_handle)), //Image.asset("ic_mail.png")),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffCED0D2), width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(6)))),
        ),
        actions: [
          new FlatButton(
            child: Text("OK"),
            onPressed: () async {
              var firebaseUser = await FirebaseAuth.instance.currentUser();
              userCollection
                  .document(firebaseUser.uid)
                  .updateData({'name': '${_nameGroupController.text}'});
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatGroup(group)));
            },
          ),
        ],
      ),
    );
  }
}
