import 'package:flutter/material.dart';
import 'package:flutter_finance_app_ui/data/models/add_data.dart';
import 'package:flutter_finance_app_ui/data/utlity.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartOld extends StatefulWidget {
  const ChartOld({super.key});

  @override
  State<ChartOld> createState() => _ChartOldState();
}

class _ChartOldState extends State<ChartOld> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <SplineSeries<SalesData, String>>[
          SplineSeries<SalesData, String>(
            width: 3,
            color: const Color.fromARGB(255, 47, 125, 121),
            dataSource: <SalesData>[
              SalesData(100, 'Mon'),
              SalesData(20, 'Tue'),
              SalesData(40, 'Wed'),
              SalesData(15, 'Sat'),
              SalesData(5, 'Sun'),
            ],
            xValueMapper: (SalesData sales, _) => sales.year,
            yValueMapper: (SalesData sales, _) => sales.sales,
          )
        ],
      ),
    );
  }
}

class SalesData {
  SalesData(this.sales, this.year);
  final String year;
  final int sales;
}
