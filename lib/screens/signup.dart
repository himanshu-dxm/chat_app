import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:simple_chat_app/services/auth.dart';
import 'package:simple_chat_app/services/database.dart';
import 'package:simple_chat_app/utils/helperfunctions.dart';
import 'package:simple_chat_app/utils/routes.dart';
import 'package:simple_chat_app/widgets/common_styles.dart';
import 'package:simple_chat_app/widgets/progressIndicators.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  bool isLoading = false;

  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController reEnteredPasswordController = new TextEditingController();

  signMeUp() {
    if(formKey.currentState!.validate()) {
      Map<String,String> userMap = {
        "name" : usernameController.text,
        "email" : emailController.text
      };

      HelperFunctions.saveUserEmailSharedPreference(emailController.text);
      HelperFunctions.saveUserNameSharedPreference(usernameController.text);

      setState(() {
        isLoading=true;
      });

      authMethods.signUpWithEmailAndPassword(
          emailController.text,
          passwordController.text
      ).then((value) => print(value));

      databaseMethods.uploadUserInfo(userMap);
      // HelperFunctions.saveUserLoggedInSharedPreference(true);
      Navigator.pushReplacementNamed(context, MyRoutes.signinRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonStyles.myAppBar(context),
      body: (isLoading)? ProgressIndicators.circularIndicator() : SingleChildScrollView(
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height - 70,
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
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height - 70,
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                validator: (value) {
                                  if(value!.isEmpty) {
                                    return "This cannot be empty";
                                  } else if(value.length<=4){
                                    return "Username should be more than 4 characters";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: usernameController,
                                style: TextStyle(color: Colors.white),
                                decoration: CommonStyles.textFieldStyle("Username :"),
                              ),
                              SizedBox(height: 15,),
                              TextFormField(
                                validator: (value) {
                                  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!) ?
                                  null : "Enter correct email";
                                },
                                controller: emailController,
                                style: TextStyle(color: Colors.white),
                                decoration: CommonStyles.textFieldStyle("E-mail :"),
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
                                decoration: CommonStyles.textFieldStyle("Password :"),
                              ),
                              SizedBox(height: 15,),
                              TextFormField(
                                obscureText: true,
                                obscuringCharacter: '*',
                                validator: (value) {
                                  if(value!.isEmpty) {
                                    return "Re-enter Password";
                                  } else if(!(value == passwordController.text)) {
                                    return "Password do not match";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: reEnteredPasswordController,
                                decoration: CommonStyles.textFieldStyle("Re-Enter Password :"),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(height: 15,),
                        SizedBox(height: 18,),
                        InkWell(
                          onTap: () {
                            signMeUp();
                          },
                          child: Container(
                            child: CommonStyles.roundButton(context, "sign up"),
                          ),
                        ),
                        SizedBox(height: 18,),
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(CommonStyles.snackBar(context, " Not Yet Functional"));
                          },
                          child: Container(
                          child: CommonStyles.roundButton(
                              context, "sign up with google"),
                          ),
                        ),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account ? ",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, MyRoutes.signinRoute);
                              },
                              child: Container(
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                      color: Colors.white,
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
