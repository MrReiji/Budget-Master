import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import '../../constants/constants.dart';

class ReceiptInputWidget extends StatelessWidget {
  final String? hintText;
  final double height;
  final bool obscureText;
  final Iterable<String>? autofillHints;
  final FieldBloc<dynamic> fieldBloc;
  final TextInputType? textInputType;

  ReceiptInputWidget({
    this.hintText,
    this.height = 10.0,
    this.obscureText = false,
    this.autofillHints,
    required this.fieldBloc,
    this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: height),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: buildFieldBlocBuilder()),
        ),
      ],
    );
  }

  Widget buildFieldBlocBuilder() {
    if (fieldBloc is TextFieldBloc) {
      return TextFieldBlocBuilder(
        textFieldBloc: fieldBloc as TextFieldBloc,
        obscureText: obscureText,
        autofillHints: autofillHints,
        keyboardType: textInputType,
        decoration: getInputDecoration(),
      );
    } else if (fieldBloc is InputFieldBloc<DateTime, Object>) {
      return DateTimeFieldBlocBuilder(
        dateTimeFieldBloc: fieldBloc as InputFieldBloc<DateTime, Object>,
        format: DateFormat('dd-MM-yyyy'),
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        decoration: getInputDecoration(),
      );
    }
    return Container(); // Return an empty container if the type is not supported
  }

  InputDecoration getInputDecoration() {
    return InputDecoration(
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
    );
  }
}
