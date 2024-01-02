import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:budget_master/firebase_options.dart'; // Ensure this path is correct
import 'package:budget_master/main.dart';

void main() {
  // Initialize Firebase before running any tests
  setUpAll(() async {
    await dotenv.load(fileName: ".env");
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  });

  // Define a widget test
  testWidgets('Home screen welcome message test', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Verify that the welcome message "Welcome Back" is present on the screen
    expect(find.text("Welcome Back"), findsOneWidget);
  });
}
