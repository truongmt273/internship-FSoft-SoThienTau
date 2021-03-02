import 'package:firebase_database/firebase_database.dart';

class User {
  String uid;
  String name;
  String email;
  String phoneNo;
  String avatar;
  int state;
  String password;
  User({
    this.uid,
    this.name,
    this.email,
    this.phoneNo,
    this.avatar,
    this.state,
    this.password,
  });

  User.fromSnapshot(DataSnapshot snapshot) {
    uid = snapshot.key;
    name = snapshot.value['name'];
    email = snapshot.value['email'];
    phoneNo = snapshot.value['phoneNo'];
  }

  User.fromData(Map<String, dynamic> data)
      : uid = data['uid'],
        name = data['name'],
        email = data['email'],
        password = data['password']; //debug only

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password, //debug only
    };
  }

  User.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.phoneNo = mapData['phone'];
    this.state = mapData['state'];
  }
}
