import 'package:flutter_form_bloc/flutter_form_bloc.dart';

/// Validates the price input.
///
/// The [priceValidator] function checks if the [price] is not null or empty.
///
/// It returns an error message if the price is invalid, otherwise it returns null.
///
/// The price is considered valid if it meets the following criteria:
/// - It is not null or empty.
/// - It has a valid format, which consists of digits followed by an optional decimal point and two decimal places.
/// - It is greater than zero.
final Validator<String> priceValidator = (String? price) {
  if (price == null || price.isEmpty) {
    return 'Price is required.';
  }

  String normalizedPrice = price.replaceAll(',', '.');

  if (!RegExp(r'^[0-9]+(\.[0-9]{1,2})?$').hasMatch(normalizedPrice)) {
    return 'Invalid price format.';
  }
  double parsedPrice = double.tryParse(normalizedPrice) ?? 0;
  if (parsedPrice <= 0) {
    return 'Price must be greater than zero.';
  }
  return null;
};
