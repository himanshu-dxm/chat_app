
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simple_chat_app/models/user.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MyUser? _userFromFirebaseUser(User? user) {
    return user!=null ? MyUser(userID: user.uid) : null ;
  }

  Future signInWithEmailAndPassword(String email,String password) async {
    try {
      if(email.isEmpty) {
        print("Empty Email");
      } else if(password.isEmpty) {
        print("Password Empty");
      } else {
        print("Noting is Empty");
      }
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // User? fireBaseUser = userCredential.user;
      // return _userFromFirebaseUser(fireBaseUser);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return 1;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return 2;
      }
    } catch(e) {
      print(e);
    }
  }

  Future signUpWithEmailAndPassword(String email,String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      User? fireBaseUser = userCredential.user;
      return _userFromFirebaseUser(fireBaseUser);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch(e) {
      print(e.toString());
    }
  }
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future signInWithGoogle() async{
    final googleSignIn = GoogleSignIn();

    GoogleSignInAccount? _user;

    final googleUser = await googleSignIn.signIn();
    if(googleUser==null) return ;
    _user = googleUser;

    final googleAuth = await _user.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );
    try {
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        // handle the error here
        print(e.toString());
      }
      else if (e.code == 'invalid-credential') {
        // handle the error here
        print(e.toString());
      }
    } catch (e) {
      print(e.toString());
    }
  }

}