import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/constants.dart';
import '../../utils/navigation/app_router_paths.dart';
import '../../widgets/ui_elements/app_button.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Image.asset(
                          "assets/logo.png",
                          scale: 1.1,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 24.0,
                      ),
                      decoration: BoxDecoration(
                        color: Constants.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          topLeft: Radius.circular(30.0),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.0),
                          Text(
                            "Welcome to Budget Master!",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(19, 22, 33, 1),
                                ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Please sign in or create an account below.",
                            style: TextStyle(
                              color: Color.fromRGBO(74, 77, 84, 1),
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          AppButton(
                            text: "Log In",
                            type: ButtonType.PLAIN,
                            onPressed: () {
                              context.push(AppRouterPaths.login);
                            },
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          AppButton(
                            text: "Create an Account",
                            type: ButtonType.PRIMARY,
                            onPressed: () {
                              context.push(AppRouterPaths.signUp);
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
    );
  }
}
