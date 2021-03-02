import 'package:brew_crew/group/chat_group.dart';
import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/screens/wrapper.dart';
import 'package:brew_crew/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/screens/home/user_list.dart';
import 'package:flutter/scheduler.dart';
import 'package:brew_crew/models/user_state.dart';

class ContactsPage extends StatefulWidget {
  ContactsPage();
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with WidgetsBindingObserver {
  _ContactsPageState();
  //final AuthService _authMethods = AuthService();
  User userProvider;
  // String uid;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final currentUser = Provider.of<User>(context);
    print(currentUser.uid);
    // setState(() {
    //   userProvider = currentUser;
    // });
    // print(userProvider.name);

    return StreamProvider<User>.value(
        value: DatabaseService(uid: currentUser.uid).user,
        child: FutureBuilder(
          future: DatabaseService(uid: currentUser.uid).getUserData(),
          builder: (context, snapshot) {
            return Scaffold(
              appBar: AppBar(
                title: (Text(
                  snapshot.data.name,
                  //userProvider.uid,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                )),
                backgroundColor: Colors.grey[300],
              ),
              body: StreamProvider<List<User>>.value(
                  value: DatabaseService().users,
                  child: Scaffold(
                    body: UserList(),
                  )),
            );
          },
        ));
  }
}

// @override
// Widget build(BuildContext context) {
//   final user = Provider.of<User>(context);
//   return StreamProvider<User>.value(
//     value: DatabaseService(uid: this.uid).user,
//     child: FutureBuilder(
//       future: DatabaseService(uid: user.uid).getUserData(),
//       builder: (context, snapshot) {
//         return Scaffold(
//           appBar: AppBar(
//             title: (Text(snapshot.data.name)),
//             actions: <Widget>[
//               FlatButton.icon(
//                 icon: Icon(Icons.person),
//                 label: Text('logout'),
//                 onPressed: () async {
//                   await AuthService().signOut(this.uid);
//                   _authMethods.setUserState(
//                       userId: this.uid, userState: UserState.Offline);
//                   Navigator.pop(context);
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => Wrapper(null)));
//                 },
//               )
//             ],
//           ),
// body: StreamProvider<List<User>>.value(
//     value: DatabaseService().users,
//     child: Scaffold(
//       body: UserList(),
//     )),
//         );
//       },
//     ),
