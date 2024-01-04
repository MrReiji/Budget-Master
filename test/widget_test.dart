import 'package:budget_master/screens/auth_screen.dart';
import 'package:budget_master/screens/login_screen.dart';
import 'package:budget_master/screens/signup_screen.dart';
import 'package:budget_master/utils/navigation/router.dart';
import 'package:budget_master/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:budget_master/main.dart';
import 'package:go_router/go_router.dart';
import './mock.dart';

void main() {
  // Mock Firebase before running any tests
  setUpAll(() async {
    setupFirebaseAuthMocks();
    await dotenv.load(fileName: ".env");
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  // Define a widget test
  testWidgets('Auth screen UI test', (WidgetTester tester) async {
    // Build the app and trigger a frame

    await tester.pumpWidget(const MyApp());

    // Verify that the welcome message is present on the screen
    expect(find.text("Welcome to Budget Master!"), findsOneWidget);
    expect(find.text("Log In"), findsOneWidget);
    expect(find.text("Create an Account"), findsOneWidget);
  });

  testWidgets('Login screen navigation test', (WidgetTester tester) async {
    // Fixes sizing issue in test
    WidgetController.hitTestWarningShouldBeFatal = true;
    tester.view.physicalSize = const Size(1080, 2220);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const MyApp());
    expect(find.byType(AuthScreen), findsOne);

    await tester.tap(find.bySemanticsLabel(RegExp("[Ll]og.*[Ii]n")));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOne);

    await tester.tap(find.byIcon(Icons.keyboard_backspace_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(AuthScreen), findsOne);
  });

  testWidgets('Signup screen navigation test', (WidgetTester tester) async {
    // Fixes sizing issue in test
    WidgetController.hitTestWarningShouldBeFatal = true;
    tester.view.physicalSize = const Size(1080, 2220);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const MyApp());
    expect(find.byType(AuthScreen), findsOne);

    await tester.tap(find.byWidgetPredicate((Widget widget) =>
        widget is AppButton &&
        RegExp("[Cc]reate.*[Aa]ccount").hasMatch(widget.text)));
    await tester.pumpAndSettle();
    expect(find.byType(SignUpScreen), findsOne);

    await tester.tap(find.byIcon(Icons.keyboard_backspace_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(AuthScreen), findsOne);
  });

  testWidgets('Router paths test', (WidgetTester tester) async {
    for (var route in AppRouter.router.configuration.routes) {
      var fixRoute = route as GoRoute; // I hate how this works here
      expect(fixRoute.name, isNotNull);
      expect(fixRoute.path, isNotNull);
      expect(fixRoute.builder, isNotNull);
    }
  });

  
}
