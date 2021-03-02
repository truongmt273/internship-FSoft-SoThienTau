import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:international_phone_input/international_phone_input.dart';

class RequestCode extends StatefulWidget {
  final Function toggleView;
  RequestCode({this.toggleView});
  @override
  _RequestCodeState createState() => _RequestCodeState();
}

class _RequestCodeState extends State<RequestCode> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String _phone = '';
  // ignore: unused_field
  String _warning;

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      _phone = internationalizedPhoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFD966),
        elevation: 0.0,
        title: Text('Sign Up with Phone'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // SizedBox(
              //   height: 180,
              // ),
              InternationalPhoneInput(
                  decoration: InputDecoration(
                      labelText: 'Your Phone Number',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      )),
                  onPhoneNumberChange: onPhoneNumberChange,
                  initialPhoneNumber: _phone,
                  initialSelection: 'VN',
                  showCountryCodes: true),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      if (_formKey.currentState.validate() || _phone == "") {
                        try {
                          await _auth.requestSMSCodeUsingPhoneNumber(
                              this._phone, context);
                        } catch (e) {
                          setState(() {
                            _warning =
                                "Your phone number could not be validated";
                          });
                          //print(e.message.toString());
                        }
                      }
                      return null;
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(
                          color: Colors.orange,
                          // fontWeight: FontWeight.bold,
                          fontSize: 20,
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
