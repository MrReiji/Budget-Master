import 'package:budget_master/utils/navigation/app_router_paths.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouterNotifier extends ChangeNotifier {
  final _firebase = FirebaseAuth.instance;
  RouterNotifier() {
    _firebase.authStateChanges().listen((event) {
      notifyListeners();
    });
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final onAuthScreen = state.fullPath == '/auth';

    if (_firebase.currentUser != null && onAuthScreen) {
      debugPrint(state.fullPath);
      return AppRouterPaths.home;
    }
    return null;
  }
}
