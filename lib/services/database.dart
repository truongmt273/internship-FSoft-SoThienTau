import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brew_crew/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future<void> setUserData(
      {String phone,
      String email,
      int state,
      String uid,
      String name,
      String password}) async {
    return await userCollection.document(this.uid).setData({
      'uid': this.uid,
      'phone': phone,
      'email': email,
      'state': state,
      'name': name,
      'password': password,
    });
  }

  Stream<List<User>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  Stream<User> get user {
    return userCollection.snapshots().map(_singleUserdataFromSnapshot);
  }

  User _singleUserdataFromSnapshot(QuerySnapshot snapshot) {
    DocumentSnapshot snap = snapshot.documents.firstWhere(
        (DocumentSnapshot documentSnapshot) =>
            documentSnapshot.data['uid'] == this.uid);
    return _userDataFromSnapshot(snap);
  }

  User _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return User(
      uid: snapshot.data['uid'] ?? '3hY988mKaNfxjvNmKdrf3zm9xGE3',
      name: snapshot.data['name'] ?? null,
      email: snapshot.data['email'] ?? null,
      password: snapshot.data['password'] ?? null,
    );
  }

  List<User> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return User(
        email: doc.data['email'] ?? '',
        name: doc.data['name'] ?? '',
        phoneNo: doc.data['phone'] ?? '0',
        state: doc.data['state'] ?? 3,
        uid: doc.data['uid'] ?? '',
      );
    }).toList();
  }

  Future<User> getUserData() async {
    User user;
    await userCollection.document(uid).get().then((onValue) {
      user = _userDataFromSnapshot(onValue);
    });
    return user;
  }
}
