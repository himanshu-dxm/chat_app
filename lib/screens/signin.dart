import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_chat_app/services/auth.dart';
import 'package:simple_chat_app/services/database.dart';
import 'package:simple_chat_app/utils/helperfunctions.dart';
import 'package:simple_chat_app/utils/routes.dart';
import 'package:simple_chat_app/widgets/progressIndicators.dart';
import '../widgets/common_styles.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool isLoading = false;
  QuerySnapshot? snapshotUserInfo;

  signIn() {

    if(formKey.currentState!.validate()) {

      HelperFunctions.saveUserEmailSharedPreference(emailController.text);

      setState(() {
        isLoading = true;
      });

      databaseMethods.getUserByUserEmail(emailController.text).
          then((val) {
            snapshotUserInfo = val;
            // print("UserNameSharedPreference = ${snapshotUserInfo!.docs[0].get("name")}");
            HelperFunctions.saveUserNameSharedPreference(
              snapshotUserInfo!.docs[0].get("name"),
            );
      });

      authMethods.signInWithEmailAndPassword(
          emailController.text,
          passwordController.text
      ).then((value) => {
        if(value==1) {
          ScaffoldMessenger.of(context).showSnackBar(CommonStyles.snackBar(context, "No user found for that email."))
        } else if(value==2) {
          ScaffoldMessenger.of(context).showSnackBar(CommonStyles.snackBar(context, "Wrong password provided for that user."))
        } else if(value!=null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true),
          Navigator.pushReplacementNamed(context, MyRoutes.chatRoomsRoute),
        } else {
          ScaffoldMessenger.of(context).showSnackBar(CommonStyles.snackBar(context, "Check Your Credentials Properly"))
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar:CommonStyles.myAppBar(context),
      body: (isLoading)?ProgressIndicators.circularIndicator():SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height-70,
          alignment: Alignment.bottomCenter,
          child: Stack(
            children: [
              Image.asset(
                "assets/images/signin_bg.jpg",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8,sigmaY: 8),
                  child: Container(
                    height: MediaQuery.of(context).size.height-70,
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Form(
                          key:formKey ,
                          child: Column(
                            children: [
                              TextFormField(
                                validator: (value) {
                                  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!) ?
                                  null : "Enter correct email";
                                },
                                controller: emailController,
                                decoration: CommonStyles.textFieldStyle("E-mail"),
                              ),
                              SizedBox(height: 15,),
                              TextFormField(
                                obscureText: true,
                                obscuringCharacter: '*',
                                validator: (value) {
                                  if(value!.length < 6) {
                                    return "It should be atleast 6 characters in length";
                                  } else if(value.isEmpty) {
                                    return "Enter Password";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: passwordController,
                                decoration: CommonStyles.textFieldStyle("Password"),
                              ),
                              SizedBox(height: 15,),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, MyRoutes.forgotPasswordRoute);
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                              child: Text(
                                "Forgot Password ?",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              ),
                            ),
                          ),
                        SizedBox(height: 15,),
                        GestureDetector(
                          onTap: () {
                            signIn();
                            // Navigator.pushNamed(context, MyRoutes.chatRoomsRoute);
                          },
                          child: Container(
                            child: CommonStyles.roundButton(context,"login"),
                          ),
                        ),
                        SizedBox(height: 18,),
                        GestureDetector(
                          onTap: () async {
                            await authMethods.signInWithGoogle().then((value) {
                              HelperFunctions.saveUserLoggedInSharedPreference(
                                  true);
                              Navigator.pushReplacementNamed(
                                  context, MyRoutes.chatRoomsRoute);
                            });
                            // HelperFunctions.saveUserLoggedInSharedPreference(true);
                            // Navigator.pushReplacementNamed(context, MyRoutes.chatRoomsRoute);
                          },
                          child: Container(
                            child: CommonStyles.roundButton(context,"sign in with google"),
                          ),
                        ),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account ? ",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacementNamed(context, MyRoutes.signupRoute);
                              },
                              child: Container(
                                child: Text(
                                    "Register Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 50,)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}