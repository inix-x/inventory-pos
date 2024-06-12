  import 'dart:developer';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter_application_1/global/common/toast.dart';

  class AuthService {
    final _auth = FirebaseAuth.instance;

    Future<User?> createUserWithEmailAndPassword(
        String email, String password) async {
      try {
        final cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        return cred.user;
      } on  FirebaseAuthException catch (e) {
        if( e.code == 'email-already-in-use'){
          showToast(message: 'The email is already in use.');
        }else{
          showToast(message: 'An error occured: ${e.code}');
          print(e);
        }
      }
      return null;
    }

    Future<User?> loginUserWithEmailAndPassword(
        String email, String password) async {
      try {
        final cred = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        return cred.user;
      } on  FirebaseAuthException catch (e) {
        if( e.code == 'user-not-found' || e.code == 'wrong-password'){
          showToast(message: 'Invalid Email or Password.');
        }else{
          showToast(message: 'An error occured: ${e.code}');
        }
      }
      return null;
    }

    Future<void> signout() async {
      try {
        await _auth.signOut();
      } catch (e) {
        log("Something went wrong");
      }
    }

    // New function to check login status
    bool isLoggedIn() {
      return _auth.currentUser != null;
    }
  }