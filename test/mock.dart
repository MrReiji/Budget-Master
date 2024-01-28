// https://github.com/firebase/flutterfire/blob/master/packages/firebase_auth/firebase_auth/test/mock.dart

// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:budget_master/constants/constants.dart';
import 'package:budget_master/models/receipt.dart';
import 'package:budget_master/screens/auth/auth_screen.dart';
import 'package:budget_master/screens/auth/login_screen.dart';
import 'package:budget_master/screens/auth/signup_screen.dart';
import 'package:budget_master/screens/home_screen.dart';
import 'package:budget_master/screens/receipt_screen.dart';
import 'package:budget_master/utils/navigation/app_router_paths.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

typedef Callback = void Function(MethodCall call);

void setupFirebaseAuthMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();
}

Future<T> neverEndingFuture<T>() async {
  // ignore: literal_only_boolean_expressions
  while (true) {
    await Future.delayed(const Duration(minutes: 5));
  }
}

class TestRouterNotifier extends ChangeNotifier {}

class TestAppRouter {
  static GoRouter get_router({initialLocation = AppRouterPaths.auth}) {
    return GoRouter(
      refreshListenable: TestRouterNotifier(),
      debugLogDiagnostics: true,
      initialLocation: initialLocation,
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
              final Receipt receipt = state.extra as Receipt;
              return ReceiptScreen(receipt: receipt);
            }),
      ],
    );
  }
}

class MyTestApp extends StatefulWidget {
  const MyTestApp({super.key, this.initialLocation = AppRouterPaths.login});
  final initialLocation;
  @override
  State<MyTestApp> createState() => _myTestState();
}

class _myTestState extends State<MyTestApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: TestAppRouter.get_router(initialLocation: widget.initialLocation)
          .routerDelegate,
      routeInformationParser:
          TestAppRouter.get_router(initialLocation: widget.initialLocation)
              .routeInformationParser,
      routeInformationProvider:
          TestAppRouter.get_router(initialLocation: widget.initialLocation)
              .routeInformationProvider,
      title: 'Budget Master',
      theme: ThemeData(
        scaffoldBackgroundColor: Constants.scaffoldBackgroundColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
