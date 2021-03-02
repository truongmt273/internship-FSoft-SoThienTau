import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/models/user_provider.dart';
import 'package:brew_crew/models/user_state.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth.dart';
import '../wrapper.dart';
import 'contactsPage.dart';
import 'groupListScreen.dart';
import 'package:flutter/scheduler.dart';

class HomeScreen extends StatefulWidget {
  final String uid;
  HomeScreen(this.uid);
  @override
  _HomeScreen createState() => _HomeScreen(this.uid);
}

class _HomeScreen extends State<HomeScreen> with WidgetsBindingObserver {
  String uid;
  _HomeScreen(this.uid);
  final AuthService _authMethods = AuthService();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<User>(context);

      _authMethods.setUserState(
        userId: userProvider.uid,
        userState: UserState.Online,
      );
      //print(userProvider.uid);
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId = this.uid;
    print(this.uid);
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Online)
            : print("resume state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Waiting)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("detached state");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _authMethods = AuthService();
    final currentUser = Provider.of<User>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('HOME'),
          centerTitle: true,
          backgroundColor: Color(0xFFFFD966),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await AuthService().signOut(currentUser.uid);
                _authMethods.setUserState(
                    userId: currentUser.uid, userState: UserState.Offline);
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Wrapper(null)));
              },
            )
          ],
          bottom: TabBar(
            labelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            tabs: <Widget>[
              Tab(
                text: 'USER',
              ),
              Tab(
                text: 'GROUP',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _displayUser(context),
            _displayGroup(context),
          ],
        ),
      ),
    );
  }

  Widget _displayUser(BuildContext context) {
    return ContactsPage();
  }

  Widget _displayGroup(BuildContext context) {
    return GroupListScreen();
  }
}
