// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'dart:html' as html;

import 'shuriken.dart';

class FirebaseAuthServices {
  //static final _auth = FirebaseAuth.instance;
  static Future<User?> signUpWithEmailAndPassword(
      String userEmail, String userPass, BuildContext context) async {
    //Create a new email and password in firebase
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: userEmail, password: userPass);
      Navigator.pop(context);
      //html.window.alert("Account successfully created, please Log In.");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // html.window.alert(
        //     "The password provided is too weak. Must include minimum 6 characters.");
      } else if (e.code == 'email-already-in-use') {
        //html.window.alert("The account already exists for that email.");
      }
    } catch (e) {
      //print(e);
    }

    return null;
  }

  static Future<User?> signInWithEmailAndPassword(
      String userEmail, String userPass, BuildContext context) async {
    //Create a new email and password in firebase
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: userEmail, password: userPass);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
      //html.window.alert("Welcome back $userEmail");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //html.window.alert('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        //html.window.alert('Wrong password provided for that user.');
      } else {
        //html.window.alert('Invalid Entry, please try again.');
      }
    } catch (e) {
      //print(e);
    }
    return null;
  }
}
