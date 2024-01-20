import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatefulWidget {
  final bool isPlaying = false;
  final List<Map<String, dynamic>> chartData;
  LineChartWidget({Key? key, required this.chartData}) : super(key: key);

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<Color> gradientColors = [
    Colors.blue.shade300,
    Colors.blue.shade800,
  ];
  List<Color> gradientColors2 = [
    Colors.white,
    Colors.blue.shade800,
  ];
  bool showAvg = false;

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.blue,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('JAN', style: style);
        break;
      case 3:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('MAY', style: style);
        break;
      case 7:
        text = const Text('JUL', style: style);
        break;
      case 9:
        text = const Text('SEP', style: style);
        break;
      case 11:
        text = const Text('NOV', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: Colors.blue,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1';
        break;
      case 3:
        text = '3';
        break;
      case 5:
        text = '5';
        break;
      case 7:
        text = '7';
        break;
      case 9:
        text = '9';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainLineData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
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
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 35,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(
          color: Color.fromARGB(255, 179, 231, 255),
        ),
      ),
      minX: 0,
      maxX: 12,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(1, 3),
            FlSpot(2, 2),
            FlSpot(3, 5),
            FlSpot(4, 3.1),
            FlSpot(5, 4),
            FlSpot(6, 3),
            FlSpot(7, 4),
            FlSpot(8, 6),
            FlSpot(9, 7),
            FlSpot(10, 8),
            FlSpot(11, 5),
          ],
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

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.lightBlue,
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.lightBlue,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 35,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.lightBlue),
      ),
      minX: 0,
      maxX: 12,
      minY: 0,
      maxY: 1,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 0.344),
            FlSpot(2.6, 0.344),
            FlSpot(4.9, 0.344),
            FlSpot(6.8, 0.344),
            FlSpot(8, 0.344),
            FlSpot(9.5, 0.344),
            FlSpot(11, 0.344),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors.map((color) => color).toList(),
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
        AspectRatio(
          aspectRatio: 1.2,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 1.0,
              vertical: 1.0,
            ),
            child: LineChart(
              showAvg ? avgData() : mainLineData(),
            ),
          ),
        ),
      ],
    );
  }
}
