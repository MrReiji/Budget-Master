import 'package:budget_master/models/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReceiptFormBlock extends FormBloc<String, String> {
  final String creatorID = FirebaseAuth.instance.currentUser!.uid;

  final storeName = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final purchaseDate = InputFieldBloc<DateTime, Object>(
    validators: [FieldBlocValidators.required],
    initialValue: DateTime.now(),
  );

  final category = TextFieldBloc();

  final description = TextFieldBloc();

  final receipt = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final product = ListFieldBloc<ProductFieldBloc, dynamic>(name: 'product');

  ReceiptFormBlock() {
    addFieldBlocs(
      fieldBlocs: [
        storeName,
        purchaseDate,
        category,
        description,
        product,
      ],
    );
  }

  void addProduct() {
    product.addFieldBloc(ProductFieldBloc(
        productName: TextFieldBloc(name: 'productName'),
        price: TextFieldBloc(name: 'price')));
  }

  void removeProduct(int index) {
    product.removeFieldBlocAt(index);
  }

  @override
  void onSubmitting() async {
    try {
      String formattedPurchaseDate =
          DateFormat('yyyy-MM-dd').format(purchaseDate.value);

      await FirebaseFirestore.instance.collection('receipts').add({
        'creatorID': creatorID,
        'storeName': storeName.value,
        'purchaseDate': formattedPurchaseDate,
        'category': category.value == '' ? 'Not entered' : category.value,
        'description': description.value,
        'product': product.value.map<Product>((memberField) {
          debugPrint(memberField.productName.value);
          debugPrint(memberField.price.value);
          return Product(
            productName: memberField.productName.value,
            price: memberField.price.value,
          );
        }).map<Map<String, dynamic>>((product) {
          return product.toJson();
        }).toList(),
      });
      emitSuccess(successResponse: 'Expense added successfully');
    } catch (e) {
      emitFailure(failureResponse: 'Failed to add expense.');
      debugPrint(e.toString());
      debugPrint(product.value.toString());
    }
  }
}

class ProductFieldBloc extends GroupFieldBloc {
  final TextFieldBloc productName;
  final TextFieldBloc price;

  ProductFieldBloc({
    required this.productName,
    required this.price,
    super.name,
  }) : super(fieldBlocs: [productName, price]);
}
