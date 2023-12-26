import 'package:budget_master/blocs/form_blocs/reset_password_form_bloc.dart';
import 'package:budget_master/widgets/app_button.dart';
import 'package:budget_master/widgets/input_widget.dart';
import 'package:budget_master/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:budget_master/utils/constants.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordFormBloc(),
      child: Builder(
        builder: (context) {
          final resetPasswordformBloc = context.read<ResetPasswordFormBloc>();

          return FormBlocListener<ResetPasswordFormBloc, String, String>(
            onSubmitting: (context, state) {
              LoadingDialog.show(context);
            },
            onSubmissionFailed: (context, state) {
              LoadingDialog.hide(context);
            },
            onSuccess: (context, state) {
              LoadingDialog.hide(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.successResponse!)));
              context.pop();
            },
            onFailure: (context, state) {
              LoadingDialog.hide(context);
            },
            child: Center(
              child: SingleChildScrollView(
                child: Card(
                  surfaceTintColor: Colors.white,
                  margin: EdgeInsets.all(20),
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Image.asset("assets/forgot_password.png"),
                        ),
                        Text(
                          "Forgot your password?",
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Please enter the email address you'd like your password reset information sent to!",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        InputWidget(
                          topLabel: "Recovery Email",
                          hintText: "Enter your recovery email",
                          prefixIcon: Icons.email,
                          textInputType: TextInputType.emailAddress,
                          textFieldBloc: resetPasswordformBloc.recoveryEmail,
                        ),
                        SizedBox(height: 20),
                        AppButton(
                          type: ButtonType.PRIMARY,
                          onPressed: resetPasswordformBloc.submit,
                          text: 'Reset Password',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
