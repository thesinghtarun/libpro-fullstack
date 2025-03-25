import 'package:flutter/material.dart';
import 'package:libpro/provider/app_controller.dart';
import 'package:provider/provider.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<AppController>(context, listen: false).clearCache();
            },
          )
        ],
      ),
      body: Consumer<AppController>(
        builder: (context, appController, child) {
          return FutureBuilder<List<dynamic>>(
            future: appController.showAllReq(appController.loggedInUserEmail),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text("Something went wrong"));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No data found"));
              }

              var data = snapshot.data!;
              print("Data on screen: $data");

              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var allReq = data[index];
                  String status = allReq["status"] ?? "pending";

                  // Conditional color logic
                  Color statusColor = Colors.grey; // Default color for pending
                  if (status == "accepted") {
                    statusColor = Colors.greenAccent;
                  } else if (status == "rejected") {
                    statusColor = Colors.redAccent;
                  }

                  return Card(
                    elevation: 3,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: ListTile(
                      title: Text(
                        "Book: ${allReq["bookName"].toString().toUpperCase()}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Asked by: ${allReq["studentEmail"]}"),
                      trailing:
                          Icon(Icons.circle, color: statusColor, size: 18),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
