import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/screens/wrapper.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String _email = '';
  String _password = '';
  String _phoneNo = '';
  String _name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFD966),
        elevation: 0.0,
        title: Text('SIGN UP'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Please enter your Email';
                  }
                  return null;
                },
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
              SizedBox(height: 20.0),
              TextFormField(
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Please enter your Name';
                  }
                  return null;
                },
                onChanged: (val) {
                  this._name = val;
                },
                decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    )),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Please enter your PhoneNo';
                  }
                  return null;
                },
                onChanged: (val) {
                  this._phoneNo = val;
                },
                decoration: InputDecoration(
                    labelText: 'PhoneNo',
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    )),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Please enter your Password';
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
              SizedBox(height: 20.0),
              TextFormField(
                validator: (val) {
                  if (val.isEmpty) {
                    return 'Please enter your confirm Password';
                  } else if (val != _password) {
                    return 'Your confirm password isn\'t same password';
                  }
                  return null;
                },
                onChanged: (val) {},
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    )),
              ),
              SizedBox(height: 70.0),
              Container(
                height: 60,
                width: 180,
                child: Material(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xFFFFD966),
                  shadowColor: Colors.orangeAccent,
                  elevation: 7,
                  child: GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        try {
                          await _auth.registerWithEmailAndPassword(
                              _email, _password, _name, _phoneNo);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Wrapper(null)));
                        } catch (e) {
                          print(e.message.toString());
                        }
                      }
                      return null;
                    },
                    child: Center(
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
