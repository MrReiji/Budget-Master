import 'dart:async';
import 'package:budget_master/constants/constants.dart';
import 'package:budget_master/widgets/charts/bar_chart%20copy.dart';
import 'package:budget_master/widgets/charts/line_chart.dart';
import 'package:flutter/material.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({super.key});

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;
  bool isPlaying = false;
  Color touchedBarColor = Colors.blue.shade800;
  Color barBackgroundColor = Constants.primaryColor;
  // ChartType selectedChartType = ChartType.bar;

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 35,
                    ),
                    Text(
                      "Charts",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                    ),
                    // Dodaj przyciski do wyboru rodzaju wykresu
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     ElevatedButton(
                    //       onPressed: () {
                    //         setState(() {
                    //           selectedChartType = ChartType.bar;
                    //         });
                    //       },
                    //       child: Text('Bar Chart'),
                    //     ),
                    //     ElevatedButton(
                    //       onPressed: () {
                    //         setState(() {
                    //           selectedChartType = ChartType.line;
                    //         });
                    //       },
                    //       child: Text('Line Chart'),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 35.0,
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
                        height: 50.0,
                      ),
                      Container(
                        // height: 300,
                        child: Column(
                          children: [
                            Row(
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
                              ],
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            buildChart(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100.0,
                      ),
                      Container(
                        // height: 320,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    "Weekly Spendings",
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            Container(height: 300, child: buildChart2()),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100.0,
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

  // Funkcja do renderowania odpowiedniego wykresu w zależności od wybranej opcji
  Widget buildChart() {
    return LineChartWidget();
    // switch (selectedChartType) {
    //   case ChartType.bar:
    //     return BarChartWidget(
    //       isPlaying: isPlaying,
    //     );
    //   case ChartType.line:
    //     return LineChartWidget();
    // }
  }

  Widget buildChart2() {
    return BarChartWidget(isPlaying: isPlaying);
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
      animDuration + const Duration(milliseconds: 50),
    );
    if (isPlaying) {
      await refreshState();
    }
  }
}

// Dodane wyliczenie do przechowywania rodzaju wykresu
// enum ChartType {
//   bar,
//   line,
// }
