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
