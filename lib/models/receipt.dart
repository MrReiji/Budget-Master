import 'package:budget_master/models/product.dart';

enum ReceiptInputMethod { MANUAL, OCR }

class Receipt {
  final String id;
  final String storeName;
  final String purchaseDate;
  final String category;
  final String description;
  final ReceiptInputMethod receiptInputMethod;
  final List<Product> products;
  final String totalPrice;

  Receipt(
      {required this.id,
      required this.storeName,
      required this.purchaseDate,
      required this.category,
      required this.description,
      required this.receiptInputMethod,
      required this.products,
      required this.totalPrice});
}
