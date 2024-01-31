import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final _firebase = FirebaseAuth.instance;

class SignUpFormBloc extends FormBloc<String, String> {
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

  final confirmPassword = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.passwordMin6Chars,
    ],
  );

  final username = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
  );

  SignUpFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        email,
        password,
        confirmPassword,
        username,
      ],
    );
    confirmPassword
      ..addValidators([FieldBlocValidators.confirmPassword(password)])
      ..subscribeToFieldBlocs([password]);
  }

  @override
  void onSubmitting() async {
    debugPrint(email.value);
    debugPrint(password.value);
    debugPrint(confirmPassword.value);
    debugPrint(username.value);

    try {
      final isInternetAvailable =
          await InternetConnectionChecker().hasConnection;
      if (isInternetAvailable == false) {
        emitFailure(failureResponse: "No internet connection!");
        return;
      }
      final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: email.value, password: password.value);
      debugPrint(userCredentials.toString());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set({
        'username': username.value,
        'email': email.value,
      });
      emitSuccess();
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        emitFailure(failureResponse: "Email already in use. Sign in!");
      } else {
        emitFailure(failureResponse: "Authentication failed!");
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
