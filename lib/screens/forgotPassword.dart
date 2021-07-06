import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:simple_chat_app/services/auth.dart';
import 'package:simple_chat_app/utils/routes.dart';
import 'package:simple_chat_app/widgets/common_styles.dart';
import 'package:simple_chat_app/widgets/progressIndicators.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  AuthMethods _authMethods = new AuthMethods();

  resetPassword() {

    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      _authMethods.resetPassword(emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
      CommonStyles.snackBar(context, "Check Your Mail Box"));
      Navigator.popAndPushNamed(context, MyRoutes.signinRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ForgotPassword"),
      ),
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
                    alignment: Alignment.center,
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
                                decoration: CommonStyles.textFieldStyle("Enter Your E-mail"),
                              ),
                              SizedBox(height: 15,),
                            ],
                          ),
                        ),

                        SizedBox(height: 15,),
                        GestureDetector(
                          onTap: () {
                            resetPassword();
                          },
                          child: Container(
                            child: CommonStyles.roundButton(context,"reset password"),
                          ),
                        ),
                        SizedBox(height: 18,),
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