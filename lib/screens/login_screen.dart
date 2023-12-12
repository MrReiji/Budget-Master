import 'package:budget_master/blocs/form_blocs/login_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:go_router/go_router.dart';

import '../utils/constants.dart';
import '../utils/navigation/app_router_paths.dart';
import '../widgets/app_button.dart';
import '../widgets/input_widget.dart';
import '../widgets/loading_dialog.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginFormBloc(),
      child: Builder(builder: (context) {
        final loginFormBloc = context.read<LoginFormBloc>();
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Constants.primaryColor,
          body: FormBlocListener<LoginFormBloc, String, String>(
            onSubmitting: (context, state) {
              LoadingDialog.show(context);
            },
            onSubmissionFailed: (context, state) {
              LoadingDialog.hide(context);
            },
            onSuccess: (context, state) {
              LoadingDialog.hide(context);

              context.push(AppRouterPaths.home);
            },
            onFailure: (context, state) {
              LoadingDialog.hide(context);

              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.failureResponse!)));
            },
            child: SafeArea(
              bottom: false,
              child: Container(
                child: SingleChildScrollView(
                  child: Container(
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
                                "Log in to your account",
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
                                // Lets make a generic input widget
                                InputWidget(
                                  topLabel: "Email",
                                  hintText: "Enter your email address",
                                  prefixIcon: Icons.email_outlined,
                                  autofillHints: const [
                                    AutofillHints.email,
                                  ],
                                  textFieldBloc: loginFormBloc.email,
                                ),
                                SizedBox(
                                  height: 25.0,
                                ),
                                InputWidget(
                                  topLabel: "Password",
                                  obscureText: true,
                                  hintText: "Enter your password",
                                  prefixIcon: Icons.lock_outlined,
                                  autofillHints: const [
                                    AutofillHints.password,
                                  ],
                                  textFieldBloc: loginFormBloc.password,
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    "Forgot Password?",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Constants.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                AppButton(
                                  type: ButtonType.PRIMARY,
                                  text: "Log In",
                                  onPressed: () {
                                    loginFormBloc.submit();
                                    debugPrint("Log in Button pressed");
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
        );
      }),
    );
  }
}
