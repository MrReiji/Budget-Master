import 'package:budget_master/screens/login_screen.dart';
import 'package:budget_master/screens/receipt_screen.dart';
import 'package:budget_master/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/auth_screen.dart';
import '../../screens/home_screen.dart';
import 'app_router_paths.dart';

class AppRouter {
  static final router = GoRouter(
    //refreshListenable: RouterNotifier(),
    //redirect: RouterNotifier().redirect,
    debugLogDiagnostics: true,
    initialLocation: AppRouterPaths.auth,
    routes: [
      GoRoute(
          name: 'home',
          path: AppRouterPaths.home,
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          }),
      GoRoute(
          name: 'auth',
          path: AppRouterPaths.auth,
          builder: (BuildContext context, GoRouterState state) {
            return const AuthScreen();
          }),
      GoRoute(
          name: 'login',
          path: AppRouterPaths.login,
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          }),
      GoRoute(
          name: 'signUp',
          path: AppRouterPaths.signUp,
          builder: (BuildContext context, GoRouterState state) {
            return const SignUpScreen();
          }),
      GoRoute(
          name: 'receipt',
          path: AppRouterPaths.receipt,
          builder: (BuildContext context, GoRouterState state) {
            return const ReceiptScreen();
          }),
    ],
  );
}
