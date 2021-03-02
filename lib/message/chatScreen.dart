import 'dart:async';
import 'package:brew_crew/message/database_mess.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final List<String> listName;
  Chat({this.listName});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Stream<QuerySnapshot> chats;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageEditingController = new TextEditingController();

  Widget chatMessagesList(){
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return MessageTile(
                message: snapshot.data.documents[index].data["message"],
                sendByMe: widget.listName[0] == snapshot.data.documents[index].data["sendBy"],
                sendby: snapshot.data.documents[index].data["sendBy"],
              );
            }) : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageEditingController.text,
        "sendBy": widget.listName[0],
        'time': DateTime
            .now().millisecondsSinceEpoch,
      };
      databaseMethods.addMessage(widget.listName[2], chatMessageMap);
      setState(() {
        messageEditingController.text = "";
      });
    }
  }


  @override
  void initState() {
    databaseMethods.getChats(widget.listName[2]).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /*Image.asset(
              'image/logo.png',
              fit: BoxFit.contain,
              height: 40,
            ),*/
            Container(
                padding: const EdgeInsets.all(0.0),
                child: Text(widget.listName[1]))
          ],
        ),
        backgroundColor: Colors.yellow,
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessagesList(),
            Container(alignment: Alignment.bottomLeft,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                color: Colors.yellow,
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageEditingController,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          decoration: InputDecoration(
                              hintText: "Message ...",
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                              border: InputBorder.none
                          ),
                        )),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight
                              ),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(8),
                          child: Image.asset("image/send.png",
                            height: 40, width: 40,)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class MessageTile extends StatelessWidget {
  final String message;
  final String sendby;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendby, @required this.sendByMe});



  @override
  Widget build(BuildContext context) {
    print(sendby);
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 12,
          right: sendByMe ? 12 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: sendByMe
                ? EdgeInsets.only(left: 10)
                : EdgeInsets.only(right: 10),
            padding: EdgeInsets.only(
                top: 10, bottom: 10, left: 5, right: 5),
            decoration: BoxDecoration(
                borderRadius: sendByMe ? BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15)
                ) :
                BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                gradient: LinearGradient(
                  colors: sendByMe ? [
                    const Color(0xff007EF4),
                    const Color(0xff2A75BC)
                  ] : [
                    const Color(0xFFFAAF0A),
                    const Color(0xFFFAAF0A)
                  ],
                )
            ),
            child: Text(message,
                //textAlign: sendByMe? TextAlign.right : TextAlign.right,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300)),
          ),
          Text("Send by " + sendby,
              //textAlign: sendByMe? TextAlign.right : TextAlign.right,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontFamily: 'OverpassRegular',
                  fontWeight: FontWeight.w300)),
        ],
      ),
    );
  }
}




