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

  // Define a widget test
  testWidgets('Home screen welcome message test', (WidgetTester tester) async {
    // Build the app and trigger a frame

    await tester.pumpWidget(const MyApp());

    // Verify that the welcome message is present on the screen
    expect(find.text("Welcome to Budget Master!"), findsOneWidget);
  });
}
