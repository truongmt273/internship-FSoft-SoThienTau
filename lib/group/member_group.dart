import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'chat_group.dart';
import '../models/contact.dart';
import '../models/group.dart';

class MemberGroup extends StatefulWidget {
  final Group groupp;

  MemberGroup(this.groupp);

  @override
  _MemberGroupState createState() => _MemberGroupState();
}

class _MemberGroupState extends State<MemberGroup> {
  final filestoreInstance = Firestore.instance;
  List<Contact> contacts = [];
  final dbRef = FirebaseDatabase.instance.reference().child("groups");
  List<dynamic> lists = [];
  dynamic _numOfTeamController = TextEditingController();
  var randomMem = Random();
  bool isRandom = false;
  var n;
  List<int> listNumTeam = [];
  List<int> listNumber = [];

  final Group group = new Group(id: '', name: '', contacts: [], avatar: '');

  void _showDialogRandomTeam(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Num of team'),
                keyboardType: TextInputType.number,
                controller: _numOfTeamController,
              ),
              RaisedButton(
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  _handleRandomTeam();
                },
              )
            ],
          );
        });
  }

  Future<List<dynamic>> getListMember() async {
    final List<dynamic> listMems = [];
    await filestoreInstance
        .collection("groups")
        .document(widget.groupp.id)
        .collection("list_member")
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        listMems.add(element);
      });
    });
    return listMems;
  }

  void _handleRandomTeam() {
    listNumber.clear();
    int numTeam = 1;
    int inputNumOfTeam = int.parse(_numOfTeamController.text);
    int lengthOfTeamNum = lists.length;
    n = lengthOfTeamNum / inputNumOfTeam;
    int r = lengthOfTeamNum % inputNumOfTeam;
    if (r == 0) {
      n = n.toInt();
      while (numTeam <= inputNumOfTeam) {
        for (int i = 1; i <= n; i++) {
          listNumTeam.add(numTeam);
        }
        numTeam++;
      }
    } else {
      n = n.toInt() + 1;
      while (numTeam <= inputNumOfTeam) {
        for (int i = 1; i <= n; i++) {
          listNumTeam.add(numTeam);
        }
        numTeam++;
      }
      int range = listNumTeam.length - lengthOfTeamNum;
      for (int k = 1; k <= range; k++) {
        int count = 0;
        int x = randomMem.nextInt(inputNumOfTeam) + 1;
        for (int j = 1; j <= listNumTeam.length; j++) {
          if (listNumTeam[j - 1] == x) {
            count++;
          }
        }
        if (count == n) {
          listNumTeam.remove(x);
        } else {
          range++;
        }
      }
    }
    setState(() {
      isRandom = true;
      listNumber = listNumTeam;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.amberAccent,
          title: Text('Member Group'),
          leading: FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatGroup(group)));
              },
              child: Icon(Icons.group))),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 300,
            child: FutureBuilder(
                future: getListMember(),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    lists.clear();
                    snapshot.data.forEach((element) {
                      lists.add(element);
                      if (isRandom) {
                        lists.shuffle();
                      }
                    });
                    return new ListView.builder(
                        shrinkWrap: true,
                        itemCount: lists.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(
                                lists[index]["name"],
                                style: TextStyle(fontSize: 20),
                              ),
                              trailing: isRandom
                                  ? CircleAvatar(
                                      child: Text('${listNumber[index]}'),
                                    )
                                  : null,
                            ),
                          );
                        });
                  }
                  return CircularProgressIndicator();
                }),
          ),
          RaisedButton(
            child: Text(
              'Random Team',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              _showDialogRandomTeam(context);
            },
          )
        ],
      ),
    );
  }
}
