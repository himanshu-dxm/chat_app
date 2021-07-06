import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat_app/services/database.dart';
import 'package:simple_chat_app/utils/constants.dart';
import 'package:simple_chat_app/widgets/common_styles.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  ScrollController _controller = ScrollController();

  Stream<QuerySnapshot> chatMessageStream = FirebaseFirestore.instance.collection("users").snapshots();
  
  Widget ChatMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatMessageStream,

      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
        // if(snapshot.hasError) {
        //   return Text("Something went wrong");
        // }
        // if(snapshot.connectionState == ConnectionState.waiting) {
        //   return Text("loading");
        // }
        // return new ListView(
        //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
        //     Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        //     return (data["message"]!=null)?MessageTile(data["message"],data["sentBy"]):MessageTile("default", "default");
        //   }).toList(),
        // );

        return (snapshot.hasData) ? ListView.builder(
          controller: _controller,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context,index) {
             return MessageTile(
                snapshot.data!.docs[index].get("message"),
               snapshot.data!.docs[index].get("sentBy")
            );
          }
        ): Container();
      }
    );
  }
  
  sendMessage() {
    print("In sendMEssage Function value of myName = ${Constants.myName}");
    if(messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sentBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addConversationMesssages(widget.chatRoomId, messageMap);
      messageController.text = "";
      Timer(Duration(microseconds: 200), () => _controller.jumpTo(_controller.position.maxScrollExtent));
    }
  }

  @override
  void initState() {
    print(databaseMethods.getConversationMesssages(widget.chatRoomId));
    // TODO: implement initState
    setState(() {
    });
    databaseMethods.getConversationMesssages(widget.chatRoomId).
    then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    print(chatMessageStream);
    Timer(
        Duration(milliseconds: 200),
            () => _controller
            .jumpTo(_controller.position.maxScrollExtent));
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios_new_sharp, color: Colors.orange),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "ChatRoom"
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ChatMessageList(),
            ),
            SizedBox(height: 8,),
            Container(
              padding: EdgeInsets.only(bottom: 8,top: 8),
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54FFFFFF),
                child: Row(
                  children: [
                    SizedBox(width: 18,),
                    Container(
                      child: Expanded(
                          child: TextField(
                            onTap: () {
                              Timer(
                                  Duration(milliseconds: 200),
                                      () => _controller
                                      .jumpTo(_controller.position.maxScrollExtent));
                            },
                              controller: messageController,
                              decoration: CommonStyles.textFieldStyle(" Enter Message"),
                          )
                      ),
                    ),
                    SizedBox(width: 2,),
                    InkWell(
                      onTap: () {
                        sendMessage();
                        Timer(
                            Duration(milliseconds: 200),
                                () => _controller
                                .jumpTo(_controller.position.maxScrollExtent));
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(Icons.send),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 8,)
          ],
        ),
      ),
    );
  }
}


class MessageTile extends StatelessWidget {

  final String? message;
  final String sentBy;

  MessageTile(this.message,this.sentBy);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: (sentBy.toLowerCase()==Constants.myName.toLowerCase())?50:8,
        right: (sentBy.toLowerCase()==Constants.myName.toLowerCase())?8:50
      ),
      margin: EdgeInsets.symmetric(vertical: 8,horizontal: 6),
      width: MediaQuery.of(context).size.width,
      alignment: (sentBy.toLowerCase()==Constants.myName.toLowerCase())
          ?Alignment.centerRight:Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: (sentBy.toLowerCase()==Constants.myName.toLowerCase())?
                [
                  const Color(0xff007EF4),
                  const Color(0xff2A75BC)
                ]
                :
                [
                  const Color(0xFF90A4AE),
                  const Color(0xFF607D8B)
                ]
          ),
          borderRadius: (sentBy.toLowerCase()==Constants.myName.toLowerCase())?
              BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
              ):
              BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)
              )
        ),
        child: Text(
          message!,
          style: TextStyle(
            // backgroundColor: Colors.black,
            color: Colors.white,
            fontSize: 17
          ),
        ),
      ),
    );
  }
}

