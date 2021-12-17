import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat_app/screens/chatRooms.dart';
import 'package:simple_chat_app/screens/forgotPassword.dart';
import 'package:simple_chat_app/screens/search_screen.dart';
import 'package:simple_chat_app/screens/signin.dart';
import 'package:simple_chat_app/screens/signup.dart';
import 'package:simple_chat_app/screens/welcome_screen.dart';
import 'package:simple_chat_app/utils/helperfunctions.dart';
import 'package:simple_chat_app/utils/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userIsLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

//   Future<Null> _getCurrentUser() async {
//     var result = await HelperFunctions.getCurrentUser();
//
// //we notified that there was a change and that the UI should be rendered
//     setState(() {
//       currentUser = result;
//     });
//   }
  getLoggedInState() async{
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) => {
      print("Value inside getLoggedINState = $value"),
      userIsLoggedIn = value!
    });
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {

    // print("Value of isUserLoggedIN in build methods main.dart = $userIsLoggedIn");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Chat_App",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      // routes: ,
      initialRoute: (userIsLoggedIn)?MyRoutes.chatRoomsRoute:MyRoutes.homeRoute,
      routes: {
        MyRoutes.homeRoute : (context) => WelcomeScreen(),
        MyRoutes.signinRoute : (context) => SignIn(),
        MyRoutes.signupRoute : (context) => Signup(),
        MyRoutes.forgotPasswordRoute : (context) => ForgotPassword(),
        MyRoutes.chatRoomsRoute : (context) => ChatRooms(),
        MyRoutes.searchScrenRoute : (context) => SearchScreen(),
        // MyRoutes.mainChatRoute : (context) => ConversationScreen(),
      },
    );
  }
}