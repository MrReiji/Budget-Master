import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class ReceiptFormBlock extends FormBloc<String, String> {
  final storeName = TextFieldBloc(
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

  final receipt = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final product = ListFieldBloc<ProductFieldBloc, dynamic>(
      name: 'product'
  );

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
    product.addFieldBloc(
        ProductFieldBloc(
            productName: TextFieldBloc(name: 'productName'),
            price: TextFieldBloc(name: 'price')
        )
    );
  }

  void removeProduct(int index) {
    product.removeFieldBlocAt(index);
  }

  @override
  void onSubmitting() async {
    try {
      await FirebaseFirestore.instance.collection('addedReceipts').add({
        'storeName': storeName.value,
        'purchaseDate': purchaseDate.value,
        'category': category.value,
        'description': description,
        'product': product.value.map<Product>((memberField) {
          return Product(
            productName: memberField.productName.value,
            price: memberField.price.value,
          );
        }).toList(),
      });
      emitSuccess(successResponse: 'Expense added successfully');
    } catch (e) {
      emitFailure(failureResponse: 'Failed to add expense');
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

class Product {
  String? productName;
  String? price;

  Product({this.productName, this.price});

  Product.fromJson(Map<String, dynamic> json) {
    productName = json['productName'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productName'] = productName;
    data['price'] = price;
    return data;
  }

  @override
  String toString() => '''Product {
  productName: $productName,
  price: $price
}''';
}
