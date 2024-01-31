import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'package:budget_master/utils/validators/maxLengthValidator.dart';
import 'package:budget_master/utils/validators/priceValidator.dart';

class ProductFieldBloc extends GroupFieldBloc {
  final TextFieldBloc productName;
  final TextFieldBloc price;

  ProductFieldBloc({
    required this.productName,
    required this.price,
    super.name,
  }) : super(fieldBlocs: [productName, price]) {
    productName.addValidators([
      FieldBlocValidators.required,
      maxLengthValidator(50),
    ]);
    price.addValidators([
      FieldBlocValidators.required,
      priceValidator,
    ]);
  }
}
