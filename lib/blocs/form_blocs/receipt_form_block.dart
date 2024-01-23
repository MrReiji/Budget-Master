import 'dart:math';
import 'package:budget_master/utils/validators/priceValidator.dart';
import 'package:budget_master/utils/validators/maxLengthValidator.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:budget_master/models/product.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:simple_cluster/simple_cluster.dart';

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
    final XFile? gallery_image = await ImagePicker().pickImage(source: source);
    if (gallery_image != null) {
      // path grabbing works for temporary access as such
      final inputImage = InputImage.fromFilePath(gallery_image.path);
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      // y,x,text map, attempting to create a single line
      var text = new Map<int, Map<int, String>>();
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          // normalize due to possible angling
          var yval = (line.cornerPoints.first.y -
                  tan((line.angle ?? 0).toDouble() * pi / 180) *
                      line.cornerPoints.first.x)
              .toInt();
          var xval = line.cornerPoints.first.x;
          if (!text.containsKey(yval)) {
            text[yval] = {xval: line.text};
          } else {
            text[yval]!.addAll({xval: line.text});
          }
        }
      }
      // sort vertically
      var res_text = Map.fromEntries(
          text.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
      List<String> parse_dat = [];
      for (var line in res_text.values) {
        for (var vert in line.values) {
          parse_dat.insertAll(parse_dat.length, vert.split(" "));
        }
      }
      // remove non-important entries
      var top = 0;
      try {
        top = extractOne(query: 'FISKALNY', choices: parse_dat, cutoff: 80)
            .index; // Price data starts from this
      } catch (e) {}
      var bot = 0;
      try {
        var bot_sprzedaz =
            extractOne(query: 'SPRZEDAZ', choices: parse_dat, cutoff: 80).index;
        bot = bot_sprzedaz;
      } catch (e) {}
      // One of these hould be somewhere at the end of the list, but no earlier
      try {
        var bot_pln =
            extractOne(query: 'PLN', choices: parse_dat, cutoff: 80).index;
        var bot_suma =
            extractOne(query: 'SUMA', choices: parse_dat, cutoff: 80).index;
        // A quick check to verify we arent out of bounds
        if (bot < top) {
          if (bot_pln < bot_suma) {
            bot = bot_pln;
          } else {
            bot = bot_suma;
          }
        }
      } catch (e) {}

      bot = parse_dat.length - bot;
      if (bot > top) {
        for (var i = 0; i < bot; i = i) {
          if (res_text.values.last.isEmpty) {
            res_text.remove(res_text.keys.last).toString();
          } else {
            i += res_text.values.last.values.last.split(" ").length;
            res_text.values.last
                .remove(res_text.values.last.keys.last)
                .toString();
          }
        }
      }
      for (var i = 0; i < top; i = i) {
        if (res_text.values.first.isEmpty) {
          res_text.remove(res_text.keys.first);
        } else {
          i += res_text.values.first.values.first.split(" ").length;
          res_text.values.first.remove(res_text.values.first.keys.first);
        }
      }
      var grouper = DBSCAN(
          epsilon: recognizedText
              .blocks[(recognizedText.blocks.length / 2).round()]
              .lines
              .first
              .elements
              .first
              .boundingBox
              .height);
      List<List<double>> g_list = [];
      for (var k in res_text.keys) {
        g_list.add([k.toDouble()]);
      }
      grouper.run(g_list);
      var grouped_text = new Map<int, Map<int, String>>();
      var targets = grouper.label ?? [];
      for (var i = 0; i < (targets.length); i += 1) {
        if (!grouped_text.containsKey(targets[i])) {
          grouped_text[targets[i]] = res_text.values.elementAt(i);
        } else {
          grouped_text[targets[i]]!.addAll(res_text.values.elementAt(i));
        }
      }
      String n_res = "";
      for (var line in grouped_text.entries) {
        // sort horizontally
        var res_line = Map.fromEntries(line.value.entries.toList()
          ..sort((e1, e2) => e1.key.compareTo(e2.key)));
        for (var element in res_line.entries) {
          n_res += " " + element.value;
        }
      }
      var results;
      try {
        results = processText(n_res);
      } catch (e) {
        emitFailure(failureResponse: "Failed to process image!");
      }

      for (var result in results ?? []) {
        products.addFieldBloc(ProductFieldBloc(
            productName:
                TextFieldBloc(name: 'productName', initialValue: result.$1),
            price: TextFieldBloc(name: 'price', initialValue: result.$2)));
      }
      textRecognizer.close();
      emitFailure(failureResponse: "Image scanned");
    }
  }

  List<(String, String)> processText(String text) {
    // Regex breakdown:
    // Attempt to match product name, weight/count data, text-like quantifiers, multiplier, result number
    // \s? is for possible whitespaces
    print(text);
    var item_data = RegExp(
            r"(?!\d)(?<name>[\w\s\d.]*?)(?<price_mult>\d+[,\d]*\s?\w*\s?[x*]\s?[\d,]*\s?[\s=]*)(?<price>\d*,\d*)")
        .allMatches(text);
    List<(String, String)> results = [];
    for (var item in item_data) {
      results
          .add((item.namedGroup('name') ?? '', item.namedGroup('price') ?? ''));
    }
    return results;
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
