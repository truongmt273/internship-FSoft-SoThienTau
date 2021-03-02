import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:brew_crew/voipcall/Call/VoiceCall.dart';
//import 'helperFunctions.dart';

class PhoneButton extends StatelessWidget {
  const PhoneButton({
    Key key,
    @required this.phoneNumbers, this.getPhoneno,
  }) : super(key: key);
  final List<String> getPhoneno;

  final String phoneNumbers;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.phone),
      onPressed: () async {
        makeCall();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VoiceCall(
                  getPhoneno: getPhoneno,
                )));
      },
      //onPhoneButtonPressed(context),
    );
  }
  void makeCall() async{
    var cred = 'ACb9879f7eb2f5bf65e2de66c457850e7f:281e3fa462b506735af0f6c3e12f9d05';
    var bytes = utf8.encode(cred);
    var base64Str = base64.encode(bytes);
    var response = await http.post(
      'https://api.twilio.com/2010-04-01/Accounts/ACb9879f7eb2f5bf65e2de66c457850e7f/Calls.json',
      headers: <String, String>{
        'Authorization': 'Basic $base64Str'
      },
      body: <String, String>{
        'From' : '+17036871850',// twilio number
        'To' : getPhoneno[1],//'To' : '+84961148271' để demo
        'Url': 'http://demo.twilio.com/docs/voice.xml',
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}
