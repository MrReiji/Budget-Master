import 'package:budget_master/constants/constants.dart';
import 'package:budget_master/models/receipt.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_master/utils/navigation/app_router_paths.dart';
import 'package:intl/intl.dart';

class ReceiptCard extends StatelessWidget {
  final Receipt receipt;

  ReceiptCard({required this.receipt});

  @override
  Widget build(BuildContext context) {
    String productNames;
    if (receipt.products.length > 5) {
      productNames = receipt.products
              .take(5)
              .map((product) => product.productName.trim())
              .join(', ') +
          ', ...';
    } else {
      productNames = receipt.products
          .map((product) => product.productName.trim())
          .join(', ');
    }

    final totalPrice = receipt.products
        .fold<double>(
          0.0,
          (sum, product) =>
              sum + double.parse(product.price.replaceAll(',', '.')),
        )
        .toStringAsFixed(2);

    return GestureDetector(
      onTap: () {
        context.push(AppRouterPaths.receipt);
      },
      child: Container(
        //height: 121,
        decoration: BoxDecoration(
          color: Constants.cardBackgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Constants.cardBorderColor,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getOrderIconWidget(receipt.receiptInputMethod),
            SizedBox(width: 25.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productNames,
                    style: TextStyle(
                      color: Constants.mainTextColor,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  textRow("Price of expenses:", totalPrice),
                  SizedBox(height: 5.0),
                  textRow("Purchased on:", receipt.purchaseDate),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textRow(String textOne, String textTwo) {
    return Wrap(
      children: [
        Text(
          "$textOne:",
          style: TextStyle(
            color: Constants.secondaryTextColor,
            fontSize: 14.0,
          ),
        ),
        SizedBox(width: 4.0),
        Text(
          textTwo,
          style: TextStyle(
            color: Constants.mainTextColor,
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }

  Widget getOrderIconWidget(ReceiptInputMethod receiptInputMethod) {
    switch (receiptInputMethod) {
      case ReceiptInputMethod.MANUAL:
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Constants.manualInputIconBackgroundColor,
          ),
          child: Icon(
            Icons.border_color_rounded,
            color: Constants.manualInputIconColor,
          ),
        );
      case ReceiptInputMethod.OCR:
        return Container(
          width: 37,
          height: 37,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Constants.ocrInputIconBackgroundColor,
          ),
          child: Icon(
            Icons.receipt_long_rounded,
            color: Constants.ocrInputIconColor,
          ),
        );
      default:
        return Container(); // By default, return an empty container if the method is not found.
    }
  }
}
