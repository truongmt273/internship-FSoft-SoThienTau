import 'package:flutter/material.dart';
import 'package:brew_crew/message/database_mess.dart';
import 'package:brew_crew/message/chatScreen.dart';

class SmsButton extends StatelessWidget {
  const SmsButton({
    Key key,
    @required this.listName,
  }) : super(key: key);
  final List<String> listName;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.message),
        onPressed: () {
          createChatRoomAndStartConversation();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Chat(
                        listName: listName,
                      )));
        });
  }

  createChatRoomAndStartConversation() {
    String chatRoomId = listName[2];
    List<String> users = [listName[1], listName[0]];
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatRoomId": chatRoomId
    };
    print(chatRoomId);
    DatabaseMethods().addChatRoom(chatRoomId, chatRoomMap);
  }
}
