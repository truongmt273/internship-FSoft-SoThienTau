import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/screens/home/online_dot_indicator.dart';
import 'smsButton.dart';
import 'phoneButton.dart';
import 'package:brew_crew/group/chat_group.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<User>(context);
    final users = Provider.of<List<User>>(context);
    print(currentUser.name);
    return ListView.builder(
      itemCount: users?.length ?? 0,
      itemBuilder: (context, index) {
        //Contact contact = _contacts?.elementAt(index);
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 18,
          ),
          leading:
              (users[index].avatar != null && users[index].avatar.isNotEmpty)
                  ? CircleAvatar(
                      //backgroundImage: MemoryImage(contact.avatar),
                      )
                  : CircleAvatar(
                      //child: Text(contact.initials()),
                      backgroundColor: Theme.of(context).accentColor,
                    ),
//                          title: Text(contact.displayName ?? ''),
          title: InkWell(
            child: Text(users[index].name ?? ''),
            onTap: null,
          ),
          //This can be further expanded to showing contacts detail
          // onPressed().
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              PhoneButton(
                getPhoneno: [
                  currentUser.phoneNo,
                  users[index].phoneNo,
                  users[index].name,
                  users[index].avatar
                ],
              ),
              SmsButton(
                listName: [
                  currentUser.name,
                  users[index].name,
                  getChatRoomId(currentUser.name, users[index].name)
                ],
              ),
              OnlineDotIndicator(uid: users[index].uid)
            ],
          ),
        );
      },
    );
  }

  getChatRoomId(String a, String b) {
    int lenA = a.length;
    int lenB = b.length;
    List<String> aArray = new List();
    List<String> bArray = new List();
    aArray = a.split('');
    bArray = b.split('');
    if (lenA != lenB) {
      if (lenA > lenB) {
        return "$b\_$a";
      } else {
        return "$a\_$b";
      }
    } else {
      int num = 0;
      if (a.compareTo(b) == 0) {
        return "$a\_$b";
      } else {
        while (num < lenA) {
          if (aArray[num].codeUnitAt(0) == bArray[num].codeUnitAt(0)) {
            num = num + 1;
          } else {
            if (aArray[num].codeUnitAt(0) < bArray[num].codeUnitAt(0)) {
              return "$a\_$b";
            } else {
              return "$b\_$a";
            }
          }
        }
      }
    }
  }
}
