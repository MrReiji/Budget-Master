import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:budget_master/models/filter_options.dart';
import 'package:budget_master/models/product.dart';
import 'package:budget_master/models/receipt.dart';

import 'receipt_card.dart';

class LatestReceipts extends StatelessWidget {
  final FilterOption filterOption;
  final SortDirection sortDirection;

  LatestReceipts({
    required this.filterOption,
    required this.sortDirection,
  });

  @override
  Widget build(BuildContext context) {
    Query receiptsQuery = FirebaseFirestore.instance
        .collection('receipts')
        .where('creatorID', isEqualTo: FirebaseAuth.instance.currentUser!.uid);

    String orderByField = filterOption == FilterOption.purchaseDate
        ? 'purchaseDate'
        : 'totalPrice';
    bool isDescending = sortDirection == SortDirection.descending;

    receiptsQuery =
        receiptsQuery.orderBy(orderByField, descending: isDescending);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream:
          receiptsQuery.snapshots().cast<QuerySnapshot<Map<String, dynamic>>>(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/empty_list_image.png',
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                Text(
                  "Empty list? Add your first expenses!",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          );
        }
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var receiptData = snapshot.data!.docs[index].data();
              final String receiptID = snapshot.data!.docs[index].id;

              var products =
                  List.from(receiptData['products']).map<Product>((item) {
                return Product(
                    productName: item['productName'], price: item['price']);
              }).toList();

              Receipt receipt = Receipt(
                id: receiptID,
                receiptInputMethod:
                    ReceiptInputMethod.MANUAL, // Or other method
                products: products,
                storeName: receiptData['storeName'],
                purchaseDate: receiptData['purchaseDate'],
                category: receiptData['category'],
                description: receiptData['description'],
                totalPrice: receiptData['totalPrice'],
              );

              return ReceiptCard(receipt: receipt);
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 2.0,
              );
            },
          );
        }
        return Center(
          child: Text(
            'Something went wrong...',
            style: TextStyle(fontSize: 20),
          ),
        );
      },
    );
  }
}
