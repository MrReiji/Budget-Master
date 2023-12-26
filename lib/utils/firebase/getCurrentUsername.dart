import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<String?> getCurrentUsername() async {
  try {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      Map<String, dynamic> userDocData = userDoc.data() as Map<String, dynamic>;
      return userDocData['username'];
    }
  } catch (e) {
    debugPrint("An error occurred while fetching user data: $e");
  }
  return null;
}
