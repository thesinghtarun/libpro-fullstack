import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:libpro/provider/app_controller.dart';
import 'package:provider/provider.dart';

class ShowReport extends StatefulWidget {
  final String addedBy;

  const ShowReport({super.key, required this.addedBy});

  @override
  State<ShowReport> createState() => _ShowReportState();
}

class _ShowReportState extends State<ShowReport> {
  @override
  void initState() {
    super.initState();
    Provider.of<AppController>(context, listen: false)
        .showReport(context,widget.addedBy);
  }

  /// ✅ Generate pie sections with better color and formatting
  List<PieChartSectionData> generatePieSections(List<dynamic> data) {
    return data.map((item) {
      return PieChartSectionData(
        color: getRandomColor(),
        value: (item["count"] ?? 0).toDouble(),
        title: "${item["bookName"]}\n(${item["edition"]})",
        radius: 90,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report")),
      body: Consumer<AppController>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (value.reportData.isEmpty) {
            return const Center(child: Text("No reports found"));
          }

          List<PieChartSectionData> pieSections =
              generatePieSections(value.reportData);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "Book Request Distribution",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sections: pieSections,
                      borderData: FlBorderData(show: false),
                      centerSpaceRadius: 60,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color getRandomColor() {
  Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(200) + 55,  // Ensures colors are not too dark
    random.nextInt(200) + 55,
    random.nextInt(200) + 55,
  );
}
}
