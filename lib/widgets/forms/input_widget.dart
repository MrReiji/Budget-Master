import 'package:flutter/material.dart';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import '../../constants/constants.dart';

/// A widget that provides an input field based on the type of [fieldBloc].
///
/// The [InputWidget] can be used to display various types of input fields, such as text fields or date fields,
/// based on the type of [fieldBloc] provided.
///
/// - The [hintText] parameter is used to display a hint text inside the input field.
/// - The [prefixIcon] parameter is used to display an icon at the beginning of the input field.
/// - The [height] parameter is used to set the height of the input field.
/// - The [topLabel] parameter is used to display a label above the input field.
/// - The [obscureText] parameter is used to hide the input text.
/// - The [autofillHints] parameter is used to provide autofill hints for the input field.
/// - The [fieldBloc] parameter is required and represents the field bloc associated with the input field.
///  -The [textInputType] parameter is used to set the keyboard type for the input field.
///
/// Example usage:
/// ```dart
/// InputWidget(
///   hintText: 'Enter your name',
///   prefixIcon: Icons.person,
///   height: 70.0,
///   topLabel: 'Name',
///   obscureText: false,
///   autofillHints: ['name'],
///   fieldBloc: TextFieldBloc(),
///   textInputType: TextInputType.text,
/// )
/// ```
///
class InputWidget extends StatelessWidget {
  final String? hintText;
  final IconData? prefixIcon;
  final double height;
  final String? topLabel;
  final bool obscureText;
  final Iterable<String>? autofillHints;
  final FieldBloc<dynamic> fieldBloc;
  final TextInputType? textInputType;

  InputWidget({
    this.hintText,
    this.prefixIcon,
    this.height = 70.0,
    this.topLabel,
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
        //Useful in ProcutCard
        if (topLabel != null) ...[
          Text(topLabel!),
          SizedBox(height: 5.0),
        ],

        Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: buildFieldBlocBuilder()),
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
      prefixIcon: prefixIcon != null
          ? Icon(
              this.prefixIcon,
              color: Color.fromRGBO(105, 108, 121, 1),
            )
          : null,
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
      errorMaxLines: 4,
      // helperText: '',
    );
  }
}
