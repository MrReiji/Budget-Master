import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BarChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> chartData;
  final bool isPlaying;
  BarChartWidget({Key? key, required this.chartData, this.isPlaying = false})
      : super(key: key);

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  late DateTime startDate;
  late DateTime endDate;

  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;
  Color touchedBarColor = Colors.blue.shade800;
  Color barBackgroundColor = Colors.grey.shade100;

  List<Color> gradientColors = [
    Colors.blue.shade200,
    Colors.blue.shade600,
  ];

  @override
  void initState() {
    super.initState();
    _setWeekDates();
  }

  void _setWeekDates() {
    DateTime now = DateTime.now();
    startDate = DateTime(now.year, now.month, now.day - now.weekday + 1);
    endDate = startDate.add(Duration(days: 6));
  }

  void _incrementWeek() {
    setState(() {
      startDate = startDate.add(Duration(days: 7));
      endDate = endDate.add(Duration(days: 7));
    });
  }

  void _decrementWeek() {
    setState(() {
      startDate = startDate.subtract(Duration(days: 7));
      endDate = endDate.subtract(Duration(days: 7));
    });
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    double maxY = 20,
    List<int> showTooltips = const [],
  }) {
    barColor ??= Colors.blue;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? touchedBarColor : barColor,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          width: width,
          borderSide: isTouched
              ? BorderSide(color: touchedBarColor)
              : const BorderSide(color: Colors.grey, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxY,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  Map<int, double> groupDataByDayOfWeek(List<Map<String, dynamic>> chartData) {
    Map<int, double> groupedData = {};

    for (var dataPoint in chartData) {
      if (!dataPoint.containsKey('purchaseDate') ||
          !dataPoint.containsKey('totalPrice')) {
        continue;
      }

      DateTime purchaseDate = DateTime.parse(dataPoint['purchaseDate']);
      if (purchaseDate.isBefore(startDate) || purchaseDate.isAfter(endDate)) {
        continue; // Ignoring data outside the current week
      }

      int dayOfWeek = purchaseDate.weekday;
      double totalPrice = dataPoint['totalPrice'] ?? 0;

      groupedData[dayOfWeek] = (groupedData[dayOfWeek] ?? 0) + totalPrice;
    }

    return groupedData;
  }

  List<BarChartGroupData> showingGroups() {
    Map<int, double> groupedData = groupDataByDayOfWeek(widget.chartData);
    double maxYValue = findMaxValue(groupedData);

    return List.generate(7, (i) {
      double rawYValue = groupedData[i + 1] ?? 0;
      return makeGroupData(i, rawYValue,
          isTouched: i == touchedIndex, maxY: maxYValue);
    });
  }

  double findMaxValue(Map<int, double> groupedData) {
    if (groupedData.isEmpty) return 0;
    return groupedData.values.reduce(max);
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x) {
              case 0:
                weekDay = 'Monday';
                break;
              case 1:
                weekDay = 'Tuesday';
                break;
              case 2:
                weekDay = 'Wednesday';
                break;
              case 3:
                weekDay = 'Thursday';
                break;
              case 4:
                weekDay = 'Friday';
                break;
              case 5:
                weekDay = 'Saturday';
                break;
              case 6:
                weekDay = 'Sunday';
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
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
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('M', style: style);
        break;
      case 1:
        text = const Text('T', style: style);
        break;
      case 2:
        text = const Text('W', style: style);
        break;
      case 3:
        text = const Text('T', style: style);
        break;
      case 4:
        text = const Text('F', style: style);
        break;
      case 5:
        text = const Text('S', style: style);
        break;
      case 6:
        text = const Text('S', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
      animDuration + const Duration(milliseconds: 50),
    );
    if (widget.isPlaying) {
      await refreshState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: _decrementWeek,
            ),
            Text(DateFormat('yyyy-MM-dd').format(startDate) +
                ' - ' +
                DateFormat('yyyy-MM-dd').format(endDate)),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: _incrementWeek,
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
            child: BarChart(
              mainBarData(),
              swapAnimationDuration: animDuration,
            ),
          ),
        ),
      ],
    );
  }
}
