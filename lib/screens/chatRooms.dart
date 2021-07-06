import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat_app/screens/mainChat.dart';
import 'package:simple_chat_app/services/auth.dart';
import 'package:simple_chat_app/services/database.dart';
import 'package:simple_chat_app/utils/constants.dart';
import 'package:simple_chat_app/utils/helperfunctions.dart';
import 'package:simple_chat_app/utils/routes.dart';

class ChatRooms extends StatefulWidget {
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {

  AuthMethods _authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream<QuerySnapshot> chatRoomsStream = FirebaseFirestore.instance.collection("ChatRoom")
      .where("users",arrayContains: Constants.myName).snapshots();

  Widget chatRoomsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatRoomsStream,
      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
        return (snapshot.hasData) ? ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index) {
              return ChatRoomsTile(
                  snapshot.data!.docs[index].get("chatroomid").toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
                snapshot.data!.docs[index].get("chatroomid")
              );
            }
        ): Container();
      }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    print("$chatRoomsStream");
    print("In init State mName = ${Constants.myName}");
    super.initState();
  }

  getUserInfo() async {
    print("Inside getUserInfo Function before await ");
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    setState(() {

    });
    // Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    // print("myName = ${HelperFunctions.getUserNameSharedPreference()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Your Chat Rooms"),
        leading: new IconButton(
          icon: new Icon(Icons.logout_rounded, color: Colors.orange),
          onPressed: () {
            _authMethods.signOut();
            HelperFunctions.saveUserLoggedInSharedPreference(false).
            then((val) {
              print("HelperFunctions LoggedInSharedPreference = ${HelperFunctions.getUserLoggedInSharedPreference().toString()}");
            });
            Navigator.pushReplacementNamed(context, MyRoutes.homeRoute);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, MyRoutes.searchScrenRoute);
        },
        child: Icon(Icons.search_sharp),
      ),
      body: Container(
        child: chatRoomsList(),
      ),
    );
  }
}


class ChatRoomsTile extends StatelessWidget {
  final String username;
  final String chatRoomId;

  ChatRoomsTile(this.username,this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(chatRoomId)));
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 8,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(40)
                    ),
                    child: Text(
                      username.substring(0,1).toUpperCase(),
                      style: TextStyle(
                        fontSize: 20
                      ),
                    )
                  ),
                  SizedBox(width: 8,),
                  Text(
                    username,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
