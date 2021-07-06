import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_chat_app/utils/routes.dart';
import 'package:simple_chat_app/widgets/common_styles.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // extendBodyBehindAppBar: true,
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/images/cold_mountain_bg.jpg",
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8,sigmaY: 8),
                child: Container(
                  height: 20,
                  width: 20,
                  alignment: Alignment.center,
                  // padding: EdgeInsets.fromLTRB(20, 430, 230, 200),
                  color: Colors.grey.withOpacity(0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 350,),
                      Container(
                        // margin: EdgeInsets.fromLTRB(10, 400, 180, 0),
                        // padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text(
                            "Welcome",
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  textBaseline: TextBaseline.alphabetic,
                                  fontSize: 34,
                                  color: Colors.white,
                                )
                            )
                        ),
                      ),
                      SizedBox(height: 7,),
                      Container(
                        // margin: EdgeInsets.fromLTRB(10, 4, 180, 0),
                        child: Text(
                          "This Is a Basic Chat Application",
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white
                              )
                          ),
                        ),
                      ),
                      SizedBox(height: 30,),
                      InkWell(
                        onTap: () {
                          print("login Tapped");
                          Navigator.pushNamed(context, MyRoutes.signinRoute);
                        },
                        child: CommonStyles.roundButton(context,"Sign IN"),
                      ),
                      SizedBox(height: 20,),
                      InkWell(
                        onTap: () {
                          print("Signup Tapped");
                          Navigator.pushNamed(context, MyRoutes.signupRoute);
                        },
                        child: CommonStyles.roundButton(context,"SIGN UP")
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
