
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonStyles {

  static textFieldStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: (hint=="Username :"|| hint=="E-mail :")?Colors.white:Colors.black,
        fontWeight: (hint==" Enter Username To Search . . .")?FontWeight.w300:FontWeight.normal,
      ),
      alignLabelWithHint:true,
      contentPadding: EdgeInsets.symmetric(vertical: 5),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            color: Colors.black,
            width: 2
        ),
      ),
    );
  }

  static snackBar(BuildContext context,String snackText) {
    return SnackBar(
      action: SnackBarAction(
        label: 'Done',
        onPressed: () {
          // Code to execute.
        },
      ),
      content: Text(snackText),
      duration: const Duration(milliseconds: 3500),
      width: MediaQuery.of(context).size.width*0.9, // Width of the SnackBar.
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0, // Inner padding for SnackBar content.
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  static myAppBar(BuildContext context) {
      return AppBar(
        backgroundColor: Colors.lightBlueAccent,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios_new_sharp, color: Colors.orange),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Center(child: Text(" ")),
      );
  }

  static roundButton(BuildContext context,String text) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xff07EF4),
              const Color(0xff2A75BC)
            ]
          ),
          border: Border.all(
              color: Colors.red
          ),
          borderRadius: BorderRadius.all(Radius.circular(50))
      ),
      // margin: EdgeInsets.only(left: 50,right: 50,top: 30),
      // width: 100,
      // height: 50,
      width: MediaQuery.of(context).size.width*0.80,
      padding: EdgeInsets.symmetric(vertical: 18,),
      child: Center(
        child: Text(
          text.toUpperCase(),
          style: GoogleFonts.lato(
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.yellowAccent,
                // backgroundColor: Colors.white,
              )
          ),
        ),
      ),
    );
  }
}