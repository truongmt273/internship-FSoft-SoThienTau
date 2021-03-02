import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/screens/authenticate/register.dart';
import 'package:brew_crew/screens/authenticate/requestCode.dart';
import 'package:brew_crew/screens/wrapper.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _formKeyEmail = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _phone = '';
  String _warning;

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      _phone = internationalizedPhoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _auth.signOut();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('SIGN IN'),
          centerTitle: true,
          backgroundColor: Color(0xFFFFD966),
          bottom: TabBar(
            labelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            tabs: <Widget>[
              Tab(
                text: 'PHONE',
              ),
              Tab(
                text: 'EMAIL',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _displayPhoneSignin(context),
            _displayEmailSignin(context),
          ],
        ),
      ),
    );
  }

  Widget _displayPhoneSignin(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            showAlert(),
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

            TextFormField(
              validator: (val) {
                if (val.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onChanged: (val) {
                this._password = val;
              },
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  )),
            ),
            SizedBox(
              height: 30,
            ),
            _btnPhoneSignin(context),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You don\'t have account?',
                  style:
                      TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RequestCode()));
                  },
                  child: Text(
                    'Sign Up with Phone',
                    style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  //show dialog input sms code and login for Phone login
  Widget showAlert() {
    if (_warning != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(
                _warning,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _warning = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  //button Phone request sms code (Sign in)
  Widget _btnPhoneSignin(BuildContext context) {
    return Container(
      height: 60,
      width: 180,
      child: Material(
        borderRadius: BorderRadius.circular(30),
        color: Color(0xFFFFD966),
        shadowColor: Colors.orangeAccent,
        elevation: 7,
        child: GestureDetector(
          onTap: () async {
            if (_formKey.currentState.validate() || _phone == "") {
              try {
                User user = await _auth.signInWithPhoneandPassword(
                    this._phone, this._password);
                print(user.uid);
                Fluttertoast.showToast(
                  msg: 'Login success',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                );
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Wrapper(user.uid)));
              } catch (e) {
                setState(() {
                  _warning = "Your account was wrong!";
                });
                //print(e.message.toString());
              }
            }
            return null;
          },
          child: Center(
            child: Text(
              'SIGN IN',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  //sign in with email
  Widget _displayEmailSignin(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30.0),
      child: Form(
        key: _formKeyEmail,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              onChanged: (val) {
                this._email = val;
              },
              decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  )),
            ),
            TextFormField(
              onChanged: (val) {
                this._password = val;
              },
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            _btnEmailSignin(context),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You don\'t have account?',
                  style:
                      TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    await _auth.signInwithGoogleAccount(context);
                  },
                  child: Text(
                    'Gmail',
                    style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'or',
                  style:
                      TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
                ),
                SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _btnEmailSignin(BuildContext context) {
    return Container(
      height: 60,
      width: 180,
      child: Material(
        borderRadius: BorderRadius.circular(30),
        color: Color(0xFFFFD966),
        shadowColor: Colors.orangeAccent,
        elevation: 7,
        child: GestureDetector(
          onTap: () async {
            if (_formKeyEmail.currentState.validate()) {
              try {
                await _auth.signInWithEmailAndPassword(_email, _password);
                Fluttertoast.showToast(
                  msg: 'Login success',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                );
              } catch (e) {
                print(e.message.toString());
              }
            }
            return null;
          },
          child: Center(
            child: Text(
              'SIGN IN',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
