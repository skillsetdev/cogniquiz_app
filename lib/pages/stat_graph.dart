import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class IndividualBar {
  final int x;
  final double y;
  IndividualBar({required this.x, required this.y});
}

class BarData {
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thuAmount;
  final double friAmount;
  final double satAmount;
  final double sunAmount;
  BarData({
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thuAmount,
    required this.friAmount,
    required this.satAmount,
    required this.sunAmount,
  });

  List<IndividualBar> barData = [];

  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: monAmount),
      IndividualBar(x: 1, y: tueAmount),
      IndividualBar(x: 2, y: wedAmount),
      IndividualBar(x: 3, y: thuAmount),
      IndividualBar(x: 4, y: friAmount),
      IndividualBar(x: 5, y: satAmount),
      IndividualBar(x: 6, y: sunAmount),
    ];
  }
}

class StatGraph extends StatefulWidget {
  const StatGraph({super.key});

  @override
  State<StatGraph> createState() => _StatGraphState();
}

class _StatGraphState extends State<StatGraph> {
  List<double> weeklySummary = [
    17.6,
    2.3,
    56.6,
    86.4,
    36.7,
    67.4,
    97.9,
  ];
  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
        monAmount: weeklySummary[0],
        tueAmount: weeklySummary[1],
        wedAmount: weeklySummary[2],
        thuAmount: weeklySummary[3],
        friAmount: weeklySummary[4],
        satAmount: weeklySummary[5],
        sunAmount: weeklySummary[6]);
    return Center(
      child: Container(
        height: 400,
        child: BarChart(BarChartData(
          maxY: 100,
          minY: 0,
          barGroups: myBarData.barData.map((data) => BarChartGroupData(x: data.x, barRods: [BarChartRodData(toY: data.y)])).toList(),
        )),
      ),
    );
  }
}
