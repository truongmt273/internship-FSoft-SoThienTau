import 'package:brew_crew/group/remove_member.dart';
import 'package:brew_crew/group/rename_group.dart';
import 'package:flutter/material.dart';

import 'add_member.dart';
import 'change_avatar_group.dart';
import 'google_map.dart';
import 'member_group.dart';
import '../models/group.dart';

class ManageGroup extends StatefulWidget {
  final Group group;
  ManageGroup(this.group);

  @override
  _ManageGroupState createState() => _ManageGroupState();
}

class _ManageGroupState extends State<ManageGroup> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
            leading: Icon(Icons.person),
            title: Text(
              "Member",
              style: TextStyle(fontSize: 18, color: Color(0xff323643)),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MemberGroup(widget.group)));
            }),
        ListTile(
            leading: Icon(Icons.person_add),
            title: Text(
              "Add Member",
              style: TextStyle(fontSize: 18, color: Color(0xff323643)),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddMember(widget.group)));
            }),
        ListTile(
            leading: Icon(Icons.delete),
            title: Text(
              "Remove Member",
              style: TextStyle(fontSize: 18, color: Color(0xff323643)),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RemoveMember(widget.group)));
            }),
        ListTile(
            leading: Image.asset('image/rename.png',width: 20,height: 20,color: Colors.black54 ),//Icon(Icons.wrap_text),
            title: Text(
              "Rename Group",
              style: TextStyle(fontSize: 18, color: Color(0xff323643)),
            ),
            onTap: () {
              setState(() {
                RenameDialog.showRenameDialog(context);
              });
            }),
        ListTile(
            leading: Icon(Icons.person_pin),
            title: Text(
              "Change Avatar",
              style: TextStyle(fontSize: 18, color: Color(0xff323643)),
            ),
            onTap: () {
              setState(() {
                ChangeAvatarDialog.showChoiceDialog(context);
              });
            }),
//        ListTile(
//            leading: Icon(Icons.person_pin),
//            title: Text(
//              "Google Map",
//              style: TextStyle(fontSize: 18, color: Color(0xff323643)),
//            ),
//            onTap: () {
//              Navigator.push(context,
//                  MaterialPageRoute(builder: (context) => GoogleMap()));
//            })
      ],
    );
  }
}
