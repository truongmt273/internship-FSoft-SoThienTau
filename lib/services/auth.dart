import 'dart:async';
import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/screens/authenticate/register.dart';
import 'package:brew_crew/screens/authenticate/registerPhoneAinfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/models/user_state.dart';
import 'package:brew_crew/models/ultilities.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  String _smsCode = '';
  String _phoneNo = '';

  String verificationId;
  static final Firestore _firestore = Firestore.instance;
  static final CollectionReference _userCollection =
      _firestore.collection('users');

  // create user obj based on firebase user

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid, name: user.displayName) : null;
  }

  User _userFromUid(User user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
    // if (_auth.onAuthStateChanged.map(_userFromFirebaseUser) != null) {
    //   return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
    // } else {
    //   return StreamController<User>().stream.map(_userFromUid);
    // }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.message.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(
      String email, String password, String name, String phoneNo) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      await DatabaseService(uid: user.uid).setUserData(
          email: email,
          name: name,
          phone: phoneNo,
          password: password,
          state: 1);
      Fluttertoast.showToast(
        msg: "Register complete",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
      _userFromFirebaseUser(user);
      // return await _auth.signOut();
      return null;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.message.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
      // return null;
    }
  }

  //Show dialog
  Future _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        top: 50, left: 30, right: 30, bottom: 30),
                    // margin: EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                        color: Color(0xFFFFEEEE),
                        borderRadius: BorderRadius.circular(17),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.orange,
                              blurRadius: 10.0,
                              offset: Offset(0, 10.0))
                        ]),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'VERIFY SMS CODE',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          onChanged: (val) {
                            this._smsCode = val;
                          },
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              labelText: 'smsCode',
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              )),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () async {
                            try {
                              await _auth.verifyPhoneNumber(
                                phoneNumber: this._phoneNo,
                                timeout: Duration(seconds: 60),
                                verificationCompleted:
                                    (AuthCredential phoneAuthCredential) =>
                                        print('request smscode complete'),
                                verificationFailed: (AuthException error) =>
                                    print('error message is ${error.message}'),
                                codeSent: (String verID,
                                    [int forceResendingToken]) {
                                  this.verificationId = verID;
                                  //show dialog to take input from the user
                                },
                                codeAutoRetrievalTimeout: (String verId) {
                                  this.verificationId = verId;
                                  print(verificationId);
                                  print("Timout");
                                },
                              );
                            } catch (e) {
                              Fluttertoast.showToast(
                                msg: e.message.toString(),
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                              );
                            }
                          },
                          child: Text(
                            'Request smsCode?',
                            style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            InkWell(
                              onTap: () async {
                                this.verifySMSCode(context, this._smsCode);
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
                        ),
                      ],
                    ),
                  )
                ],
              ));
        });
  }

  //Sign in with phone
  Future requestSMSCodeUsingPhoneNumber(
      String phoneNo, BuildContext context) async {
    this._phoneNo = phoneNo;
    await Firestore.instance
        .collection('listPhone')
        .document(phoneNo)
        .get()
        .then((value) async {
      print((value.data == null).toString());
      if (value.data == null) {
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNo,
          timeout: Duration(seconds: 60),
          verificationCompleted: (AuthCredential phoneAuthCredential) =>
              print('request smscode complete'),
          verificationFailed: (AuthException error) =>
              print('error message is ${error.message}'),
          codeSent: (String verID, [int forceResendingToken]) {
            this.verificationId = verID;
            //show dialog to take input from the user
          },
          codeAutoRetrievalTimeout: (String verId) {
            this.verificationId = verId;
            print(verificationId);
            print("Timout");
          },
        );

        _showDialog(context);
      } else {
        Fluttertoast.showToast(
          msg: 'Phone Number already exist',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
        );
      }
    });
  }

  Future verifySMSCode(BuildContext context, String smsCode) async {
    try {
      AuthCredential authCreds = PhoneAuthProvider.getCredential(
          verificationId: this.verificationId, smsCode: smsCode);
      AuthResult result = await _auth.signInWithCredential(authCreds);
      print('1_' + result.user.uid);
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddInfoRegisterPhone(
                    phone: this._phoneNo,
                    uid: result.user.uid,
                  )));
      return await this.signOut(null);
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.message.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
      return null;
    }
  }

  Future addInfoRegiserPhone(String phone, String email, String name,
      String password, String uid) async {
    print(uid);
    await Firestore.instance.collection('listPhone').document(phone).setData({
      'uid': uid,
      'password': password,
      'name': name,
    });
    await DatabaseService(uid: uid).setUserData(
        email: email, name: name, phone: phone, password: password);
    return null;
  }

  Future signInWithPhoneandPassword(String phone, String password) async {
    User user = await Firestore.instance
        .collection('listPhone')
        .document(phone)
        .get()
        .then((onValue) {
      print(onValue.data);
      if (onValue.data['password'] != password) {
        print(password + ' != ' + onValue.data['password']);
        Fluttertoast.showToast(
          msg: 'Wrong password',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
        );
        return null;
      }
      return User(uid: onValue.data['uid']);
    });
    print(user);
    Firestore.instance.collection('currentUser').document(user.uid).setData({
      'uid': user.uid,
    });
    return _userFromUid(user);
  }

  //Sign in with Google
  Future signInwithGoogleAccount(BuildContext context) async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      AuthResult result = await _auth.signInWithCredential(credential);
      FirebaseUser user = result.user;
      bool check = await Firestore.instance
          .collection('users')
          .document(user.uid)
          .get()
          .then((value) {
        return value.data == null;
      });
      if (check) {
        Firestore.instance.collection('users').document(user.uid).setData({
          'email': user.email,
          'name': user.displayName,
          'password': '',
          'phone': '',
          'state': 1,
          'uid': user.uid,
        });
      }
      return _userFromFirebaseUser(user);
      // return _userFromFirebaseUser(user);
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.message.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );
      return null;
    }
  }

  // sign out
  Future signOut(String uid) async {
    try {
      Firestore.instance.collection('currentUser').document(uid).delete();
      return await _auth.signOut().then((value) => _googleSignIn.signOut());
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) =>
      _userCollection.document(uid).snapshots();

  Future<User> getUserDetails() async {
    FirebaseUser currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =
        await _userCollection.document(currentUser.uid).get();

    return User.fromMap(documentSnapshot.data);
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  void setUserState({@required String userId, @required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);

    _userCollection.document(userId).updateData({
      "state": stateNum,
    });
  }
}
