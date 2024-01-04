import 'package:budget_master/screens/auth_screen.dart';
import 'package:budget_master/screens/home_screen.dart';
import 'package:budget_master/screens/login_screen.dart';
import 'package:budget_master/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:budget_master/main.dart';
import './mock.dart';

void main() {
  // Mock Firebase before running any tests
  setUpAll(() async {
    setupFirebaseAuthMocks();
    await dotenv.load(fileName: ".env");
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
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
    await tester.enterText(
        find.byWidgetPredicate((Widget widget) =>
            widget is InputWidget &&
            widget.textInputType == TextInputType.emailAddress),
        "mock@mock.com");
    await tester.enterText(
        find.byWidgetPredicate((Widget widget) =>
            widget is InputWidget &&
            widget.textInputType == TextInputType.visiblePassword),
        "mockmockmock");
    await tester.tap(find.bySemanticsLabel(RegExp("[Ll]og.*[Ii]n\$")));
    await tester.pumpAndSettle(); // This *will* fail if firebase emulation is not up and runnning
    expect(find.byType(HomeScreen), findsOne);
  });
}