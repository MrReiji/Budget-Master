import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:budget_master/constants/constants.dart';
import 'package:budget_master/models/receipt.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({required this.receipt, Key? key}) : super(key: key);

  final Receipt receipt;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: Container(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: kToolbarHeight,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.pop(context);
                      },
                      child: Icon(
                        Icons.keyboard_backspace_rounded,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Details About\n",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          TextSpan(
                            text: "Receipt",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Constants.scaffoldBackgroundColor,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 24.0,
                        horizontal: 16.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Receipt Details",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Color.fromRGBO(74, 77, 84, 1),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          getDataRow("STORE NAME:", receipt.storeName),
                          getDataRow("DATE:", receipt.purchaseDate),
                          getDataRow("CATEGORY:", receipt.category),
                          getDescriptionColumn(
                            receipt.description,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "PRODUCTS, THEIR AMOUNT AND PRICE:",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(143, 148, 162, 1),
                            ),
                          ),
                          ListView.builder(
                            padding: EdgeInsets.only(top: 10.0),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: receipt.products.length,
                            itemBuilder: (context, index) {
                              var product = receipt.products[index];
                              return getItemRow(
                                '1',
                                product.productName,
                                product.price + " zł",
                              );
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Divider(),
                          getTotalRow("Total", receipt.totalPrice + " zł"),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget getTotalRow(String title, String amount) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.0),
    child: Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color.fromRGBO(19, 22, 33, 1),
            fontSize: 17.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacer(),
        Text(
          amount,
          style: TextStyle(
            color: Constants.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 17.0,
          ),
        )
      ],
    ),
  );
}

Widget getSubtotalRow(String title, String price) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.0),
    child: Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color.fromRGBO(74, 77, 84, 1),
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Spacer(),
        Text(
          price,
          style: TextStyle(
            color: Color.fromRGBO(74, 77, 84, 1),
            fontSize: 15.0,
          ),
        )
      ],
    ),
  );
}

Widget getItemRow(String count, String item, String price) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.0),
    child: Row(
      children: [
        Text(
          count,
          style: TextStyle(
            color: Color.fromRGBO(74, 77, 84, 1),
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            " x $item",
            style: TextStyle(
              color: Color.fromRGBO(143, 148, 162, 1),
              fontSize: 15.0,
            ),
          ),
        ),
        Text(
          price,
          style: TextStyle(
            color: Color.fromRGBO(74, 77, 84, 1),
            fontSize: 15.0,
          ),
        )
      ],
    ),
  );
}

Widget getDataRow(String topic, String data) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.0),
    child: Row(
      children: [
        Text(
          topic,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color.fromRGBO(143, 148, 162, 1),
          ),
        ),
        Spacer(),
        Text(
          data,
          style: TextStyle(
            color: Color.fromRGBO(74, 77, 84, 1),
            fontSize: 15.0,
          ),
        )
      ],
    ),
  );
}

Widget getDescriptionColumn(String data) {
  return Column(
    children: [
      Row(
        children: [
          Text(
            "DESCRIPTION:",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(143, 148, 162, 1),
            ),
          ),
        ],
      ),
      Container(
          child: Row(
        children: <Widget>[
          Flexible(
            child: Text(
              data,
              style: TextStyle(
                color: Color.fromRGBO(74, 77, 84, 1),
                fontSize: 15.0,
              ),
            ),
          ),
        ],
      )),
    ],
  );
}
