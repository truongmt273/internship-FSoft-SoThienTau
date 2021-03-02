import 'package:brew_crew/screens/home/addgroupScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'smsButton.dart';
import 'phoneButton.dart';
import '../../group/chat_group.dart';
import '../../models/group.dart';

class GroupListScreen extends StatefulWidget {
  @override
  _GroupListScreenState createState() => new _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
  @override
  void initState() {
//    Firestore.instance.collection('mountains').document()
//        .setData({ 'title': 'Mount Baker', 'type': 'volcano' });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new GroupList(),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddGroupScreen()));
        },
      ),
    );
  }
}

class GroupList extends StatelessWidget {
  final Group group = new Group(id: '', name: '', contacts: [], avatar: '');
  final List<Group> _groups = [];

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: Firestore.instance.collection('groups').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        _groups.clear();
        snapshot.data.documents.forEach((element) {
          _groups.add(Group(
              id: element.documentID,
              name: element['name'],
              contacts: element["list_member"],
              avatar: ''));
        });
        return new ListView.builder(
            itemCount: _groups.length,
            itemBuilder: (ctx, index) {
              return new ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                leading: Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                    left: 15,
                  ),
                ),
                title: GestureDetector(
                  child: Text(_groups[index].name),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatGroup(_groups[index])));
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[PhoneButton(), SmsButton()],
                ),
              );
            });
      },
    );
  }
}
