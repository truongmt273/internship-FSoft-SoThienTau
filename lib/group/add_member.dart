import 'package:flutter/material.dart';

import 'chat_group.dart';
import '../models/contact.dart';
import '../models/group.dart';
import '../screens/home/list_member.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AddMember extends StatefulWidget {
  final Group group;

  AddMember(this.group);

  @override
  _AddMemberState createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  List<Contact> _contacts = [];
  final firestoreInstance = Firestore.instance;

  Future<List<dynamic>> _getListNoMember() async {
    final List<dynamic> listMems = [];
    await firestoreInstance.collection("users").getDocuments().then((value) {
      value.documents.forEach((element) {
        listMems.add(element);
      });
    });
    await firestoreInstance
        .collection("groups")
        .document(widget.group.id)
        .collection("list_member")
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        listMems.removeWhere((ele) => ele["uid"] == element["uid"]);
      });
    });
    return listMems;
  }

  void _addMemberToGroup(BuildContext ctx) {
    List<Contact> contacts =
    _contacts.where((element) => element.isSelected).toList();
    contacts.forEach((element) {
      firestoreInstance
          .collection("groups")
          .document(widget.group.id)
          .collection("list_member")
          .add({
        'uid': element.id,
        'name': element.name,
      });
    });
    widget.group.contacts = contacts;
    Navigator.of(ctx).pop();
    Navigator.push(ctx, MaterialPageRoute(builder: (context) => ChatGroup(widget.group)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amberAccent,
          title: Text('Add Member'),
          leading: FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatGroup(widget.group)));
              },
              child: Icon(Icons.group)),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.person_add,
                  color: Colors.black,
                ),
                onPressed: () {
                  _addMemberToGroup(context);
                }),
          ],
        ),
        body: FutureBuilder(
          future: _getListNoMember(),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              _contacts.clear();
              snapshot.data.forEach((element) {
                _contacts.add(
                    new Contact(id: element["uid"], name: element["name"]));
              });
              return ListMember(_contacts);
            } else {
              return Center(
                child: Text('Loading...'),
              );
            }
          },
        ));
  }
}
