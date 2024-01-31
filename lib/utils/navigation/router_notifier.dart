import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import 'package:budget_master/utils/navigation/app_router_paths.dart';

class RouterNotifier extends ChangeNotifier {
  final _firebase = FirebaseAuth.instance;
  RouterNotifier() {
    _firebase.authStateChanges().listen((event) {
      notifyListeners();
    });
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final currentScreen = state.fullPath!;
    // Check if the current screen is one of the auth-related screens
    final isAuthScreen = ['/auth', '/login', '/signUp'].contains(currentScreen);

    // If the user is logged in and currently on an auth-related screen, redirect to the HomeScreen
    if (_firebase.currentUser != null && isAuthScreen) {
      return AppRouterPaths.home;
    }

    // If the user is logged out and not on an auth-related screen, redirect to the AuthScreen
    if (_firebase.currentUser == null && !isAuthScreen) {
      return AppRouterPaths.auth;
    }

    return null;
  }
}
