// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:namer_app/shuriken.dart';
import 'signup.dart';

class GoogleAuth {
  loginViaGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn().signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);
      await FirebaseAuth.instance.signInWithCredential(authCredential);
      var username = FirebaseAuth.instance.currentUser!.email;
      var email = FirebaseAuth.instance.currentUser!.email;
      addNewUser(username!, email!);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    }
  }

  signout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
