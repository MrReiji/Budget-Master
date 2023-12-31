import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordFormBloc extends FormBloc<String, String> {
  final recoveryEmail = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.email,
    ],
  );

  ResetPasswordFormBloc() {
    addFieldBlocs(fieldBlocs: [recoveryEmail]);
  }

  @override
  void onSubmitting() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: recoveryEmail.value);
      emitSuccess(
          successResponse:
              'If the e-mail exists in the database, password reset email sent successfully!');
    } catch (e) {
      emitFailure(failureResponse: 'Failed to send password reset email!');
    }
  }
}
