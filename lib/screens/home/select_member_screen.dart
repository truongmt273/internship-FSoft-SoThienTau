import 'package:flutter/material.dart';

import '../../models/contact.dart';
import 'list_member.dart';
import '../../group/chat_group.dart';
import '../../models/group.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class SelectMemberScreen extends StatelessWidget {
  final String name;

  SelectMemberScreen(this.name);

  final firestoreInstance = Firestore.instance;
  final List<Contact> _contacts = [];
  final Group group = new Group(id: '', name: '', contacts: [], avatar: '');

  Future<List<dynamic>> getListMember() async {
    var querySnap = await firestoreInstance.collection("users").getDocuments();
    return querySnap.documents.map((snap) => snap.data).toList();
  }

  void _addMemberToGroup(BuildContext ctx) {
    firestoreInstance.collection("groups").add({
      'name': name,
    }).then((value) {
      List<Contact> contacts =
      _contacts.where((element) => element.isSelected).toList();
      contacts.forEach((element) {
        firestoreInstance
            .collection("groups")
            .document(value.documentID)
            .collection("list_member")
            .add({
          'uid': element.id,
          'name': element.name,
        });
      });
      group.id = value.documentID;
      group.name = name;
      group.contacts = contacts;
    });
    Navigator.of(ctx).pop();
    Navigator.push(ctx, MaterialPageRoute(builder: (context) => ChatGroup(group)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Select Member'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () => _addMemberToGroup(context),
            )
          ],
        ),
        body: FutureBuilder(
          future: getListMember(),
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
                child: Text('No data!!'),
              );
            }
          },
        ));
  }
}
