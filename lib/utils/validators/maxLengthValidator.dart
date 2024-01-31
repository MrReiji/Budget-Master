import 'package:flutter_form_bloc/flutter_form_bloc.dart';

/// Returns a validator function that checks if the given [value] is not longer than [maxLength] characters.
/// If the [value] exceeds the [maxLength], it returns an error message.
/// Otherwise, it returns null.
///
/// Example usage:
///
/// ```dart
/// final validator = maxLengthValidator(10);
///
/// final errorMessage = validator('This is a long string'); // Returns "Value can't be longer than 10 characters"
/// final noErrorMessage = validator('Short'); // Returns null
/// ```
Validator<String> maxLengthValidator(int maxLength) {
  return (String? value) {
    if (value != null && value.length > maxLength) {
      return "Value can't be longer than $maxLength characters";
    }
    return null;
  };
}
