import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../utils/constants.dart';

class InputWidget extends StatelessWidget {
  final String? hintText;
  final IconData? prefixIcon;
  final double height;
  final String topLabel;
  final bool obscureText;
  final Iterable<String>? autofillHints;
  final TextFieldBloc<dynamic> textFieldBloc;

  InputWidget({
    this.hintText,
    this.prefixIcon,
    this.height = 70.0,
    this.topLabel = "",
    this.obscureText = false,
    this.autofillHints,
    required this.textFieldBloc,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(this.topLabel),
        SizedBox(height: 5.0),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: height),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: TextFieldBlocBuilder(
              textFieldBloc: textFieldBloc,
              keyboardType: TextInputType.emailAddress,
              autofillHints: autofillHints,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  this.prefixIcon,
                  color: Color.fromRGBO(105, 108, 121, 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(74, 77, 84, 0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Constants.primaryColor,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                  ),
                ),
                hintText: this.hintText,
                hintStyle: TextStyle(
                  fontSize: 14.0,
                  color: Color.fromRGBO(105, 108, 121, 0.7),
                ),
              ),
              // child: TextFormField(
              //   obscureText: this.obscureText,
              // decoration: InputDecoration(
              //   prefixIcon: Icon(
              //     this.prefixIcon,
              //     color: Color.fromRGBO(105, 108, 121, 1),
              //   ),
              //     enabledBorder: OutlineInputBorder(
              //       borderSide: BorderSide(
              //         color: Color.fromRGBO(74, 77, 84, 0.2),
              //       ),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide(
              //         color: Constants.primaryColor,
              //       ),
              //     ),
              //     hintText: this.hintText,
              //     hintStyle: TextStyle(
              //       fontSize: 14.0,
              //       color: Color.fromRGBO(105, 108, 121, 0.7),
              //     ),
              //   ),
              // ),
            ),
          ),
        ),
      ],
    );
  }
}
