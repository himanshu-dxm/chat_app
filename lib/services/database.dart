import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  getUserByUsername(String username) async{
    return await FirebaseFirestore.instance.
    collection("users").
    where("name", isEqualTo: username).get();
  }

  getUserByUserEmail(String email) async{
    return await FirebaseFirestore.instance.
    collection("users").
    where("email", isEqualTo: email).get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap).
    catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String chatRoomId,chatRoomMap) {
    // print("In creation of ChatRoom");
    try {
      FirebaseFirestore.instance.collection("ChatRoom").
      doc(chatRoomId).set(chatRoomMap).catchError((e) {print(e.toString());});
    } on Exception catch (e) {
      print(e.toString());
    }
  }
  
  getConversationMesssages(String chatRoomId) async {
    print("Function called");
    return await FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time",descending: false)
        .snapshots();
  }

  addConversationMesssages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap).catchError((e){
      print("${e.toString()} this is error");
    });
  }

  getChatRooms(String username) async {
    return await FirebaseFirestore.instance.collection("ChatRoom")
        .where("users",arrayContains: username).snapshots();
  }

}