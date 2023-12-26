import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> resetPassword(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  } on FirebaseAuthException catch (e) {
    debugPrint(e.toString());
  }
}
