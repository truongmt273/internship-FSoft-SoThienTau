import 'package:flutter/material.dart';

import 'chat_group.dart';
import '../models/contact.dart';
import '../models/group.dart';
import '../screens/home/list_member.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class RemoveMember extends StatefulWidget {
  final Group group;

  RemoveMember(this.group);

  @override
  _RemoveMemberState createState() => _RemoveMemberState();
}

class _RemoveMemberState extends State<RemoveMember> {
  List<Contact> _contacts = [];
  final firestoreInstance = Firestore.instance;

  Future<List<dynamic>> getListMember() async {
    final List<dynamic> listMems = [];
    await firestoreInstance
        .collection("groups")
        .document(widget.group.id)
        .collection("list_member")
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        listMems.add(element);
      });
    });
    return listMems;
  }

  void _removeMember(BuildContext ctx){
    List<Contact> contacts =
    _contacts.where((element) => element.isSelected).toList();
    contacts.forEach((element) {
      firestoreInstance
          .collection("groups")
          .document(widget.group.id)
          .collection("list_member")
          .getDocuments().then((value) {
         value.documentChanges.removeWhere((ele) => element.id == ele.document.data["uid"]);
      });
    });
//    widget.group.contacts = contacts;
    Navigator.of(ctx).pop();
    Navigator.push(ctx, MaterialPageRoute(builder: (context) => ChatGroup(widget.group)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amberAccent,
          title: Text('Remove Member'),
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
                  Icons.delete,
                  color: Colors.black,
                ),
                onPressed: () {
                  _removeMember(context);
                }),
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
                child: Text('Loading...'),
              );
            }
          },
        ));
  }
}
