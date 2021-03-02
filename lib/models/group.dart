import 'package:flutter/cupertino.dart';

import 'contact.dart';

class Group{
  String id;
  String name;
  List<Contact> contacts;
  String avatar;

  Group({
    @required this.id,
    @required this.name,
    @required this.contacts,
    @required this.avatar
  });
}