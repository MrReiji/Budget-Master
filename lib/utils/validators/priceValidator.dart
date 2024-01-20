import 'package:flutter_form_bloc/flutter_form_bloc.dart';

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
