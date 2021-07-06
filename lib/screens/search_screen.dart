import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_chat_app/screens/mainChat.dart';
import 'package:simple_chat_app/services/database.dart';
import 'package:simple_chat_app/utils/constants.dart';
import 'package:simple_chat_app/widgets/common_styles.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods _databaseMethods = new DatabaseMethods();
  TextEditingController _searchTextEditingController = new TextEditingController();

  QuerySnapshot? searchSnapshot;
  initiateSearch() {
    _databaseMethods.
    getUserByUsername(_searchTextEditingController.text).then((val) {
      setState(() {
        setState(() {
          searchSnapshot = val;
        });
      });
    });
  }

  Widget searchList() {
    return searchSnapshot != null ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchSnapshot!.docs.length,
      itemBuilder: (context,index) {
        return SearchTile(
            userName: searchSnapshot!.docs[index].get("name"),
            userEmail: searchSnapshot!.docs[index].get("email"),
        );
      }
    ): Container();
  }

  @override
  void initState() {
    initiateSearch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonStyles.myAppBar(context),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 7,),
            Container(
              color: Color(0x54FFFFFF),
              child: Row(
                children: [
                  SizedBox(width: 18,),
                  Container(
                    child: Expanded(
                      child: TextField(
                        controller: _searchTextEditingController,
                        decoration: CommonStyles.textFieldStyle(" Enter Username To Search . . .")
                      )
                    ),
                  ),
                  SizedBox(width: 2,),
                  InkWell(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.search),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 2,),
            searchList(),
          ],
        ),
      ),
    );
  }
}

createChatRoomAndStartConversation(String username,BuildContext context) {

  String chatRoomId = getChatRoomId(username, Constants.myName);
  List<String?> users = [username, Constants.myName];
  Map<String,dynamic> chatRoomMap = {
    "users" : users,
    "chatroomid" : chatRoomId,
  };
  print(username+Constants.myName);
  try {
    DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(context,MaterialPageRoute(
      builder: (context) => ConversationScreen(
          chatRoomId
      )
    ));
  } on Exception catch (e) {
    // TODO
    print(e.toString());
  }
}

class SearchTile extends StatelessWidget {
  final String userName;
  final String userEmail;

  SearchTile({required this.userName,required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: GoogleFonts.lato(),
              ),
              Text(
                userEmail,
                style: GoogleFonts.lato(),
              )
            ],
          ),
          Spacer(),
          InkWell(
            onTap: () {
              //TODO
              createChatRoomAndStartConversation(userName,context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              child: Text(
                  "Message"
              ),
            ),
          )
        ],
      ),
    );
  }
}


getChatRoomId(String a,String b) {
  if(a.substring(0).codeUnitAt(0) > b.substring(0).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
