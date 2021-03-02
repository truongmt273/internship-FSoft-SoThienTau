import 'package:flutter/widgets.dart';
import 'user.dart';
import '../services/auth.dart';

class UserProvider with ChangeNotifier {
  User _user;
  AuthService _authMethods = AuthService();

  User get getUser => _user;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
