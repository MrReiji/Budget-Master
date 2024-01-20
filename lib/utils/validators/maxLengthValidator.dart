import 'package:flutter_form_bloc/flutter_form_bloc.dart';

Validator<String> maxLengthValidator(int maxLength) {
  return (String? value) {
    if (value != null && value.length > maxLength) {
      return "Value can't be longer than $maxLength characters";
    }
    return null;
  };
}
