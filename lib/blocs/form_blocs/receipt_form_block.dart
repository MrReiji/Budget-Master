import 'package:budget_master/utils/validators/priceValidator.dart';
import 'package:budget_master/utils/validators/maxLengthValidator.dart';
import 'dart:convert';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:budget_master/models/product.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

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

  void loadAndProcessImage(source) async {
    final XFile? gallery_image =
        await ImagePicker().pickImage(source: source);
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
      var results;
      try {
        results = extractText(n_res);
      } catch (e) {
        Fluttertoast.showToast(
        msg: "Failed to process image",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black12,
        textColor: Colors.white,
        fontSize: 16.0
    );
      }
      
      for (var result in results??[]) {
        products.addFieldBloc(ProductFieldBloc(
            productName:
                TextFieldBloc(name: 'productName', initialValue: result.$1),
            price: TextFieldBloc(name: 'price', initialValue: result.$2)));
      }
    }
  }

  List<(String, String)> extractText(List<String> text) {
    // Asuuming bounds
    var top = extractOne(query: 'FISKALNY', choices: text, cutoff: 75)
        .index; // Lower cutoff due to 'paragon niefiskalny'
    var bot = extractOne(query: 'PLN', choices: text, cutoff: 80)
        .index; // Should be at the end of the list
    for (var i = bot; i > top + 1; i--) {
      if (text[i].contains("x") || text[i].contains("*")) {
        bot = i;
        break; // finds lowest multiplication sign, seems to be the only consistent delimiter
      }
    }
    List<(String, String)> re_val = [];
    for (var i = top + 1; i <= bot; i++) {
      // In case of any inconsistencies, probably just throw an error rn until we manage to error-catch it properly
      var value = "v_test";
      var name = "n_test";
      if (i + 1 < text.length) {
        // if there is a next record, check if it's text or possible price data
        var letters = 0;
        var numbers = 0;
        for (var char in text[i + 1].characters) {
          if (RegExp('[a-zA-Z]').hasMatch(char)) {
            letters += 1;
          } else if (RegExp('\\d').hasMatch(char)) {
            numbers += 1;
          }
        }
        if (numbers > letters) {
          // if the next record has numbers, check where the multiplication sign is, and merge
          // consume next line by advancing iterator
          if (RegExp('[x*]').hasMatch(text[i + 1])) {
            value = text[i + 1];
            name = text[i];
            i += 1;
          } else if (RegExp('[x*]').hasMatch(text[i])) {
            name = RegExp('.*\d[\s\d]+[x*].*').firstMatch(text[i]) as String;
            value = RegExp('\d[\s\d]+[x*].*').firstMatch(text[i]) as String;
            value += text[i + 1].replaceAll('\n', ' ');
            i += 1;
          }
        } else if (RegExp('[x*]').hasMatch(text[i])) {
          name = RegExp('.*\d[\s\d]+[x*].*').firstMatch(text[i]) as String;
          value = RegExp('\d[\s\d]+[x*].*').firstMatch(text[i]) as String;
        }
      } else if (RegExp('[x*]').hasMatch(text[i])) {
        // last record check on single line product lists
        name = RegExp('.*\d[\s\d]+[x*].*').firstMatch(text[i]) as String;
        value = RegExp('\d[\s\d]+[x*].*').firstMatch(text[i]) as String;
      }
      re_val.add((name, value));
    }
    return re_val;
  }

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
      final isInternetAvailable =
          await InternetConnectionChecker().hasConnection;
      if (isInternetAvailable == false) {
        emitFailure(failureResponse: "No internet connection!");
        return;
      }
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
