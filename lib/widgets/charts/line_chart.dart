import 'package:flutter/material.dart';

import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class LineChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> dataPoints;
  LineChartWidget({Key? key, required this.dataPoints}) : super(key: key);

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  int displayedYear = DateTime.now().year; // Aktualny rok jako domyślny

  List<Color> gradientColors = [
    Colors.blue.shade300,
    Colors.blue.shade800,
  ];
  List<Color> gradientColors2 = [
    Colors.white,
    Colors.blue.shade800,
  ];
  bool showAvg = false;
  void _incrementYear() {
    setState(() {
      displayedYear++;
    });
  }

  void _decrementYear() {
    setState(() {
      displayedYear--;
    });
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.blue,
    );

    List<String> monthNames = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];

    int monthIndex = value.toInt();

    // Sprawdzenie, czy miesiąc pasuje do naszego schematu (co trzy miesiące zaczynając od lutego)
    if (monthIndex % 3 == 1) {
      // 1 dla lutego, 4 dla maja, 7 dla sierpnia, 10 dla listopada
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(monthNames[monthIndex], style: style),
      );
    } else {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(''),
      );
    }
  }

  Widget leftTitleWidgets(double value, TitleMeta meta, double maxY) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: Colors.blue,
    );

    // nie wyświetlaj etykiety, jeśli wartość to 0
    if (value == 0) {
      return Text('');
    }

    // tylko etykiety dla określonych interwałów
    if (value % (maxY / 5) == 0) {
      return Text('${value.toInt()}', style: style);
    }

    return Text('');
  }

  Map<String, double> groupDataByDate(
      List<Map<String, dynamic>> chartData, int displayedYear) {
    Map<String, double> groupedData = {};

    for (var dataPoint in chartData) {
      if (!dataPoint.containsKey('purchaseDate') ||
          !dataPoint.containsKey('totalPrice')) {
        continue;
      }

      DateTime purchaseDate = DateTime.parse(dataPoint['purchaseDate']);
      if (purchaseDate.year != displayedYear) {
        continue; // Pomijamy dane, które nie są z wybranego roku
      }

      String formattedDate = DateFormat('yyyy-MM').format(purchaseDate);
      double totalPrice = dataPoint['totalPrice'] ?? 0;

      groupedData[formattedDate] =
          (groupedData[formattedDate] ?? 0) + totalPrice;
    }

    // Sortowanie mapy według kluczy (miesiące)
    var sortedKeys = groupedData.keys.toList(growable: false)..sort();
    Map<String, double> sortedGroupedData = {
      for (var key in sortedKeys) key: groupedData[key]!
    };

    return sortedGroupedData;
  }

  LineChartData mainLineData(List<Map<String, dynamic>> chartData) {
    Map<String, double> groupedData = groupDataByDate(chartData, displayedYear);

    List<FlSpot> getSpots(Map<String, double> groupedData) {
      return groupedData.entries.map((entry) {
        int month = int.parse(entry.key.split('-')[1]);
        double xValue = (month - 1).toDouble(); // Miesiące zaczynają się od 0
        return FlSpot(xValue, entry.value);
      }).toList();
    }

    List<FlSpot> spots = getSpots(groupedData);

    double minX = 0;
    double maxX = 11;
    double minY = 0;
    double maxY = 0;

    if (groupedData.isNotEmpty) {
      maxY = groupedData.values.reduce(max);
      maxY = (maxY / 50).ceil() * 50; // Zaokrąglanie
    }

    double intervalY = 5;
    if (maxY != 0) {
      intervalY = maxY / 10;
    } // interwały dla poziomych linii oraz wartości osi y

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: intervalY,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color.fromARGB(255, 179, 231, 255),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color.fromARGB(255, 179, 231, 255),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) =>
                leftTitleWidgets(value, meta, maxY),
            reservedSize: 40,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(
          color: Color.fromARGB(255, 179, 231, 255),
        ),
      ),
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors2
                  .map((color) => color.withOpacity(0.5))
                  .toList(),
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
      ],
    );
  }

  // LineChartData avgData() {
  //   return LineChartData(
  //     lineTouchData: const LineTouchData(enabled: false),
  //     gridData: FlGridData(
  //       show: true,
  //       drawHorizontalLine: true,
  //       verticalInterval: 1,
  //       horizontalInterval: 1,
  //       getDrawingVerticalLine: (value) {
  //         return const FlLine(
  //           color: Colors.lightBlue,
  //           strokeWidth: 1,
  //         );
  //       },
  //       getDrawingHorizontalLine: (value) {
  //         return const FlLine(
  //           color: Colors.lightBlue,
  //           strokeWidth: 1,
  //         );
  //       },
  //     ),
  //     titlesData: FlTitlesData(
  //       show: true,
  //       bottomTitles: AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: true,
  //           reservedSize: 30,
  //           getTitlesWidget: bottomTitleWidgets,
  //           interval: 1,
  //         ),
  //       ),
  //       leftTitles: AxisTitles(
  //         sideTitles: SideTitles(
  //           showTitles: true,
  //           getTitlesWidget: leftTitleWidgets,
  //           reservedSize: 35,
  //           interval: 1,
  //         ),
  //       ),
  //       topTitles: const AxisTitles(
  //         sideTitles: SideTitles(showTitles: false),
  //       ),
  //       rightTitles: const AxisTitles(
  //         sideTitles: SideTitles(showTitles: false),
  //       ),
  //     ),
  //     borderData: FlBorderData(
  //       show: true,
  //       border: Border.all(color: Colors.lightBlue),
  //     ),
  //     minX: 0,
  //     maxX: 12,
  //     minY: 0,
  //     maxY: 1,
  //     lineBarsData: [
  //       LineChartBarData(
  //         spots: const [
  //           FlSpot(0, 0.344),
  //           FlSpot(2.6, 0.344),
  //           FlSpot(4.9, 0.344),
  //           FlSpot(6.8, 0.344),
  //           FlSpot(8, 0.344),
  //           FlSpot(9.5, 0.344),
  //           FlSpot(11, 0.344),
  //         ],
  //         isCurved: true,
  //         gradient: LinearGradient(
  //           colors: gradientColors.map((color) => color).toList(),
  //         ),
  //         barWidth: 5,
  //         isStrokeCapRound: true,
  //         dotData: const FlDotData(
  //           show: false,
  //         ),
  //         belowBarData: BarAreaData(
  //           show: true,
  //           gradient: LinearGradient(
  //             colors: gradientColors
  //                 .map((color) => color.withOpacity(0.3))
  //                 .toList(),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  showAvg = !showAvg;
                });
              },
              child: Text(
                'avg',
                style: TextStyle(
                  fontSize: 12,
                  color: showAvg ? Colors.orange : Colors.red,
                ),
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: _decrementYear,
            ),
            Text('$displayedYear'),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: _incrementYear,
            ),
          ],
        ),
        AspectRatio(
          aspectRatio: 1.2,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 1.0,
              vertical: 1.0,
            ),
            child: LineChart(
              // showAvg ? avgData() : mainLineData(widget.dataPoints),
              mainLineData(widget.dataPoints),
            ),
          ),
        ),
      ],
    );
  }
}
