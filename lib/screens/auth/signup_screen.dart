import 'package:flutter/material.dart';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:budget_master/blocs/form_blocs/auth/signup_form_bloc.dart';
import 'package:budget_master/constants/constants.dart';
import 'package:budget_master/widgets/dialogs/loading_dialog.dart';
import 'package:budget_master/widgets/forms/input_widget.dart';
import 'package:budget_master/widgets/ui_elements/app_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpFormBloc(),
      child: Builder(builder: (context) {
        final signUpFormBloc = context.read<SignUpFormBloc>();
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: FormBlocListener<SignUpFormBloc, String, String>(
            onSubmitting: (context, state) {
              LoadingDialog.show(context);
            },
            onSubmissionFailed: (context, state) {
              LoadingDialog.hide(context);
            },
            onSuccess: (context, state) {
              LoadingDialog.hide(context);
              // Navigation to home is handled by RouterNotifier's redirect.
              // context.push(AppRouterPaths.home);
            },
            onFailure: (context, state) {
              LoadingDialog.hide(context);

              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.failureResponse!)));
            },
            child: Container(
              color: Constants.primaryColor,
              child: SafeArea(
                bottom: false,
                child: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      color: Constants.primaryColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 15.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    context.pop();
                                  },
                                  child: Icon(
                                    Icons.keyboard_backspace_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  "Create an Account!",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          Flexible(
                            child: Container(
                              width: double.infinity,
                              constraints: BoxConstraints(
                                minHeight:
                                    MediaQuery.of(context).size.height - 180.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                ),
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  InputWidget(
                                    topLabel: "Username",
                                    hintText: "Enter your username",
                                    prefixIcon: Icons.person_outlined,
                                    autofillHints: const [
                                      AutofillHints.newUsername,
                                    ],
                                    fieldBloc: signUpFormBloc.username,
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  InputWidget(
                                    topLabel: "Email",
                                    hintText: "Enter your email address",
                                    prefixIcon: Icons.email_outlined,
                                    textInputType: TextInputType.emailAddress,
                                    autofillHints: const [
                                      AutofillHints.email,
                                    ],
                                    fieldBloc: signUpFormBloc.email,
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  InputWidget(
                                    topLabel: "Password",
                                    obscureText: true,
                                    hintText: "Enter your password",
                                    prefixIcon: Icons.lock_outlined,
                                    textInputType:
                                        TextInputType.visiblePassword,
                                    autofillHints: const [
                                      AutofillHints.password,
                                    ],
                                    fieldBloc: signUpFormBloc.password,
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  InputWidget(
                                    topLabel: "Confirm Password",
                                    obscureText: true,
                                    hintText: "Confirm your password",
                                    textInputType:
                                        TextInputType.visiblePassword,
                                    prefixIcon: Icons.lock_outlined,
                                    autofillHints: const [
                                      AutofillHints.password,
                                    ],
                                    fieldBloc: signUpFormBloc.confirmPassword,
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  AppButton(
                                    type: ButtonType.PRIMARY,
                                    text: "Sign up",
                                    onPressed: () {
                                      signUpFormBloc.submit();

                                      debugPrint("Sign up Button pressed");
                                      // context
                                      //     .pushReplacement(AppRouterPaths.home);
                                    },
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
