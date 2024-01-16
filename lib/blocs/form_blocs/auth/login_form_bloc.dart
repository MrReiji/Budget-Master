import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class LoginFormBloc extends FormBloc<String, String> {
  final email = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.email,
    ],
  );

  final password = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.passwordMin6Chars,
    ],
  );

  LoginFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        email,
        password,
      ],
    );
  }

  @override
  void onSubmitting() async {
    debugPrint(email.value);
    debugPrint(password.value);

    try {
      final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: email.value, password: password.value);
      debugPrint(userCredentials.toString());
      debugPrint("Logged in");
      emitSuccess(successResponse: "You have logged in successfully!");
    } on FirebaseAuthException catch (_) {
      emitFailure(
          failureResponse: "Invalid email or password. Please try again!");
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
