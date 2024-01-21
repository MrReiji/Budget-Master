import 'package:budget_master/utils/validators/maxLengthValidator.dart';
import 'package:budget_master/utils/validators/priceValidator.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:budget_master/models/product.dart';
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
