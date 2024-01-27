import 'package:budget_master/pages/home_page.dart';
import 'package:budget_master/screens/auth/auth_screen.dart';
import 'package:budget_master/screens/auth/login_screen.dart';
import 'package:budget_master/screens/auth/signup_screen.dart';
import 'package:budget_master/screens/home_screen.dart';
import 'package:budget_master/utils/navigation/app_router_paths.dart';
import 'package:budget_master/utils/navigation/router.dart';
import 'package:budget_master/widgets/dialogs/loading_dialog.dart';
import 'package:budget_master/widgets/forms/reset_password_form.dart';
import 'package:budget_master/widgets/ui_elements/app_button.dart';
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

  testWidgets('Verifying additional login screen data',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyTestApp(initialLocation: AppRouterPaths.login));
    await tester.pumpAndSettle();
    await tester.tap(find.byWidgetPredicate((Widget widget) =>
        widget is AppButton && RegExp("[Ll]og.*[Ii]n").hasMatch(widget.text)));
    expect(find.byType(LoginScreen), findsOne);
    await tester.pumpAndSettle();
    await tester.tap(find.byWidgetPredicate((Widget widget) =>
        widget is Text &&
        RegExp("[Ff]orgot.*[Pp]assword.*").hasMatch(widget.data ?? "")));
    await tester.pumpAndSettle();
    expect(find.byType(ResetPasswordForm), findsOne);
    await tester.tap(find.byWidgetPredicate((Widget widget) =>
        widget is AppButton &&
        RegExp("[Rr]eset.*[Pp]assword.*").hasMatch(widget.text)));
    expect(find.byType(ResetPasswordForm), findsOne);
  });

  testWidgets('Verifying additional singup screen data',
      (WidgetTester tester) async {
    WidgetController.hitTestWarningShouldBeFatal = true;
    tester.view.physicalSize = const Size(1080, 2220);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(MyTestApp(
      initialLocation: AppRouterPaths.signUp,
    ));
    await tester.pumpAndSettle();
    expect(find.byType(SignUpScreen), findsOne);
    await tester.tap(find.byWidgetPredicate((Widget widget) =>
        widget is AppButton &&
        RegExp("[Ss]ign.*[Uu]p.*").hasMatch(widget.text)));
  });
}
