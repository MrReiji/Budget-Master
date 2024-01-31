import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:budget_master/constants/constants.dart';

enum ButtonType { PRIMARY, PLAIN }

/// A custom button widget that can be styled based on the [ButtonType].
///
/// The [AppButton] widget is a reusable button component that can be used
/// throughout the application. It supports two types of buttons: [ButtonType.PRIMARY]
/// and [ButtonType.PLAIN]. The button's appearance and behavior can be customized
/// by providing the [type], [onPressed], and [text] properties.
///
/// Example usage:
/// ```dart
/// AppButton(
///   type: ButtonType.PRIMARY,
///   onPressed: () {
///     // Handle button press
///   },
///   text: 'Submit',
/// )
/// ```
class AppButton extends StatelessWidget {
  final ButtonType type;
  final VoidCallback onPressed;
  final String text;

  AppButton({required this.type, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onPressed,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: getButtonColor(type),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(169, 176, 185, 0.42),
              spreadRadius: 0,
              blurRadius: 8.0,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Center(
          child: Text(
            this.text,
            style: GoogleFonts.roboto(
              color: getTextColor(type),
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

Color getButtonColor(ButtonType type) {
  switch (type) {
    case ButtonType.PRIMARY:
      return Constants.primaryColor;
    case ButtonType.PLAIN:
      return Colors.white;
    default:
      return Constants.primaryColor;
  }
}

Color getTextColor(ButtonType type) {
  switch (type) {
    case ButtonType.PLAIN:
      return Constants.primaryColor;
    case ButtonType.PRIMARY:
      return Colors.white;
    default:
      return Colors.white;
  }
}
