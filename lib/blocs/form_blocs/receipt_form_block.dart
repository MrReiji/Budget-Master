import 'package:budget_master/utils/validators/priceValidator.dart';
import 'package:budget_master/utils/validators/maxLengthValidator.dart';
import 'dart:convert';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:budget_master/models/product.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

class ReceiptFormBloc extends FormBloc<String, String> {
  final String creatorID = FirebaseAuth.instance.currentUser!.uid;

  final storeName = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      maxLengthValidator(30),
    ],
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

  final products = ListFieldBloc<ProductFieldBloc, dynamic>(name: 'product');

  ReceiptFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        storeName,
        purchaseDate,
        category,
        description,
        products,
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
          .index; // Lower cutoff due to 'paragon niefiskalny'
      var bot = extractOne(query: 'PLN', choices: n_res, cutoff: 80)
          .index; // Should be at the end of the list
      for (var i = bot; i > top + 1; i--) {
        if (n_res[i].contains("x") || n_res[i].contains("*")) {
          bot = i;
          print(n_res[i]);
          break; // finds lowest multiplication sign, seems to be the only consistent delimiter
        }
      }
      for (var i = top + 1; i <= bot; i++) {
        //TODO:
        // Go line by line, remember that line with "*"/"x" is the last in pairs/singles
        // If line doesn't have "*"/"x", look ahead and see if the next line is mostly numbers
        // Actually do it always
        // In case of any inconsistencies, probably just throw an error rn until we manage to error-catch it properly
        // Which (todo) isn't done yet
        //if (i + 1 < n_res.length) {
        //  if (next_line_is_mostly_numbers) {
        //    if (next_line_has_mult) {
        //      select_next_line_as_value;
        //      select_this_line_as_name;
        //    } else if (this_line_has_mult) {
        //      go_to_the_mult_div_and_a_little_to_the_left___choose_that_as_pivot;
        //      select_left_og_pivot_as_name;
        //      select_right_ofpivot_and_next_line_as_value;
        //    }
        //  }
        //} else if (this_line_has_mult) {
        //  select_this_line_as_value;
        //  go_to_the_mult_div_and_a_little_to_the_left___choose_that_as_pivot;
        //  split_at_pivot;
        //  things_on_left_of_pivot_are_name;
        //  things_on_right_of_pivot_are_value_for_now;
        //}
        products.addFieldBloc(ProductFieldBloc(
            productName:
                TextFieldBloc(name: 'productName', initialValue: n_res[i]),
            price: TextFieldBloc(name: 'price', initialValue: 'test')));
      }
    }
  }

  void extractText(String text) {}

  void addProduct() {
    products.addFieldBloc(ProductFieldBloc(
      productName: TextFieldBloc(
        name: 'productName',
        validators: [
          FieldBlocValidators.required,
          maxLengthValidator(30),
        ],
      ),
      price: TextFieldBloc(
        name: 'price',
        validators: [
          FieldBlocValidators.required,
          priceValidator,
        ],
      ),
    ));
  }

  void removeProduct(int index) {
    products.removeFieldBlocAt(index);
  }

  @override
  void onSubmitting() async {
    try {
      if (products.value.isEmpty) {
        throw NoProductsException('Please add at least one product.');
      }

      String formattedPurchaseDate =
          DateFormat('yyyy-MM-dd').format(purchaseDate.value);

      final totalPrice = products.value
          .fold<double>(
            0.0,
            (sum, product) =>
                sum + double.parse(product.price.value.replaceAll(',', '.')),
          )
          .toStringAsFixed(2);

      await FirebaseFirestore.instance.collection('receipts').add({
        'creatorID': creatorID,
        'storeName': storeName.value,
        'purchaseDate': formattedPurchaseDate,
        'category': category.value.isEmpty ? 'Not entered' : category.value,
        'description': description.value,
        'products': products.value.map<Product>((productField) {
          return Product(
            productName: productField.productName.value,
            price: productField.price.value.replaceAll(',', '.'),
          );
        }).map<Map<String, dynamic>>((product) {
          return product.toJson();
        }).toList(),
        'totalPrice': totalPrice,
      });
      emitSuccess(successResponse: 'Expense added successfully');
    } catch (e) {
      if (e is NoProductsException) {
        emitFailure(failureResponse: e.toString());
      } else {
        emitFailure(failureResponse: 'Failed to add expense.');
      }
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
  }) : super(fieldBlocs: [productName, price]) {
    productName.addValidators([
      FieldBlocValidators.required,
      maxLengthValidator(30),
    ]);
    price.addValidators([
      FieldBlocValidators.required,
      priceValidator,
    ]);
  }
}

class NoProductsException implements Exception {
  final String message;
  NoProductsException(this.message);

  @override
  String toString() => message;
}
