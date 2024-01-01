import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseFormBloc extends FormBloc<String, String> {
  final productName = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final price = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final store = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final purchaseDate = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final category = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final description = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  ExpenseFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        productName,
        price,
        store,
        purchaseDate,
        category,
        description,
      ],
    );
  }

  @override
  void onSubmitting() async {
    try {
      await FirebaseFirestore.instance.collection('expenses').add({
        'productName': productName.value,
        'price': price.value,
        'store': store.value,
        'purchaseDate': purchaseDate.value,
        'category': category.value,
        'description': description,
      });
      emitSuccess(successResponse: 'Expense added successfully');
    } catch (e) {
      emitFailure(failureResponse: 'Failed to add expense');
    }
  }
}
