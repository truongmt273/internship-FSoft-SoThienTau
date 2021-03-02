import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Call/VoiceCall.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _toController, _fromController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Name'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.call),
              tooltip: 'call',
              onPressed: null,
//              onPressed: () async {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(builder: (context) => VoiceCallPage()),
//                );
//              },
            ),
            IconButton(
              icon: Icon(Icons.video_call),
              tooltip: 'call',
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.more_horiz),
              tooltip: 'more',
              onPressed: () {},
            )
          ],
        ),
        body: Center(
          child: Text(
            'Chat box',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
