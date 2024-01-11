import 'dart:convert';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

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

  void loadFromGallery() async {
    final XFile? gallery_image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (gallery_image != null) {
      var text =
          FlutterTesseractOcr.extractText(gallery_image.path, language: 'pol');
      var res = LineSplitter().convert(await text);
      List<String> n_res = [];
      for (var item in res) {
        if (item.isNotEmpty) {
          n_res.add(item);
        }
      }
      // Asuuming bounds
      var top = extractOne(query: 'FISKALNY', choices: n_res, cutoff: 75)
          .index; // Lower due to 'paragon niefiskalny'
      var bot = extractOne(query: 'PLN', choices: n_res, cutoff: 80)
          .index; // Should be at the end of the list
      for (var i = top+1; i < bot; i++) {
        product.addFieldBloc(ProductFieldBloc(
            productName:
                TextFieldBloc(name: 'productName', initialValue: n_res[i]),
            price: TextFieldBloc(name: 'price', initialValue: 'test')));
      }
    }
  }

  void extractText(String text) {}

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
      await FirebaseFirestore.instance.collection('addedReceipts').add({
        'storeName': storeName.value,
        'purchaseDate': purchaseDate.value,
        'category': category.value,
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
