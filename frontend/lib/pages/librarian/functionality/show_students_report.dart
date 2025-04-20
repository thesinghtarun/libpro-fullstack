import 'package:flutter/material.dart';
import 'package:libpro/provider/app_controller.dart';
import 'package:provider/provider.dart';

class ShowStudentsReport extends StatelessWidget {
  const ShowStudentsReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Book Report"),
      ),
      body: SafeArea(
        child: Consumer<AppController>(
          builder: (context, value, child) {
            // Trigger the API call
            return FutureBuilder(
              future: value.showStudentLibrarianReport(value.loggedInUserEmail),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ✅ Get data directly from provider
                final data = value.studentReport;

                if (data == null || data['studentReport'] == null || data['studentReport'].isEmpty) {
                  return const Center(child: Text("No Data found"));
                }

                final studentReport = data['studentReport'];

                return ListView.builder(
                  itemCount: studentReport.length,
                  itemBuilder: (context, index) {
                    final report = studentReport[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(report['studentEmail'] ?? "No Email"),
                        subtitle: Text(
                          "Book: ${report['bookName'] ?? "Unknown"}\n"
                          "Status: ${report['status'] ?? "N/A"}\n"
                          "Days: ${report['days'].toString()}",
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
