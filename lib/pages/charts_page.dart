import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:budget_master/constants/constants.dart';
import 'package:budget_master/widgets/charts/bar_chart.dart';
import 'package:budget_master/widgets/charts/line_chart.dart';

class ChartsPage extends StatelessWidget {
  const ChartsPage({super.key});

  final Duration animDuration = const Duration(milliseconds: 250);

  final bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.primaryColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 15.0,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35),
                  child: Text(
                    "Charts",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 180.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 35.0,
                      ),
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('receipts')
                              .where('creatorID',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
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
                                      "No charts? Add your first expenses!",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              );
                            }
                            if (snapshot.hasData &&
                                snapshot.data!.docs.isNotEmpty) {
                              List<Map<String, dynamic>> chartData = snapshot
                                  .data!.docs
                                  .fold<List<Map<String, dynamic>>>([],
                                      (acc, doc) {
                                // Extract the purchaseDate and totalPriceString from each document in the snapshot.
                                final purchaseDate =
                                    doc.data()['purchaseDate'] as String;
                                var totalPriceString = '0';
                                if (doc.data()['totalPrice'] != null) {
                                  totalPriceString =
                                      doc.data()['totalPrice'] as String;
                                } else
                                  totalPriceString =
                                      doc.data()['totalPrice'] = '0';

                                final totalPrice =
                                    double.tryParse(totalPriceString) ?? 0;

                                final existingIndex = acc.indexWhere((item) =>
                                    item['purchaseDate'] == purchaseDate);

                                if (existingIndex != -1) {
                                  // If an entry with the same purchaseDate already exists, update the total price.
                                  acc[existingIndex]['totalPrice'] +=
                                      totalPrice;
                                } else {
                                  // If not, add a new entry to the accumulator list.
                                  acc.add({
                                    'purchaseDate': purchaseDate,
                                    'totalPrice': totalPrice,
                                  });
                                }

                                return acc;
                              });

                              return Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                      ),
                                      child: Text(
                                        "Yearly Spendings",
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    LineChartWidget(
                                      dataPoints: chartData,
                                    ),
                                    SizedBox(
                                      height: 50.0,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        "Weekly Spendings",
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25.0,
                                    ),
                                    BarChartWidget(
                                        chartData: chartData,
                                        isPlaying: isPlaying),
                                  ],
                                ),
                              );
                            }
                            return Center(
                              child: Text(
                                'Something went wrong...',
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          }),
                      SizedBox(
                        height: 50.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
