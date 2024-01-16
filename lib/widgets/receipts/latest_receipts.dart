import 'package:budget_master/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/receipt.dart';
import '../../constants/constants.dart';
import 'receipt_card.dart';

class LatestReceipts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('receipts')
            .where('creatorID',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Latest Receipts",
                        style: TextStyle(
                          color: Color.fromRGBO(19, 22, 33, 1),
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        "Filter by",
                        style: TextStyle(
                          color: Constants.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                receiptsBasedOnSnapshot(snapshot),
              ],
            ),
          );
        });
  }
}

Widget receiptsBasedOnSnapshot(
    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
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
    final loadedReceiptsDocs = snapshot.data!.docs;

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 10.0,
      ),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final receipt = loadedReceiptsDocs[index].data();

        final List<Product> products = List.from(receipt['products'])
            .map((item) => Product(
                  productName: item['productName'],
                  price: item['price'],
                ))
            .toList();

        return ReceiptCard(
          receipt: Receipt(
            receiptInputMethod: ReceiptInputMethod.MANUAL,
            products: products,
            storeName: receipt['storeName'],
            purchaseDate: receipt['purchaseDate'],
            category: receipt['category'],
            description: receipt['description'],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 15.0,
        );
      },
      itemCount: loadedReceiptsDocs.length,
    );
  }
  debugPrint(snapshot.connectionState.toString());
  debugPrint(snapshot.hasData.toString());
  debugPrint(snapshot.data!.docs.isEmpty.toString());
  return Center(
    child: Text(
      'Something went wrong...',
      style: TextStyle(fontSize: 20),
    ),
  );
}
