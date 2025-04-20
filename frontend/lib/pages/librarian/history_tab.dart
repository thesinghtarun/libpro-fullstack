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
                      trailing: InkWell(
                          onTap: () {
                            _showDialog(context, allReq);
                          },
                          child: Icon(Icons.more_vert,
                              color: statusColor, size: 18)),
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

  void _showDialog(BuildContext context, data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(data["bookName"]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data["studentEmail"] ?? "N/A"),
            Text(data["createdAt"] ?? "N/A"),
            Text("Book Publisher: ${data["bookPublisher"] ?? "N/A"}"),
            Text("Book Price: ${data["bookPrice"] ?? "N/A"}"),
            Text("Book Edition: ${data["bookEdition"] ?? "N/A"}"),
            Text("Published Year: ${data["bookPublishedYear"] ?? "N/A"}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          Consumer<AppController>(
            builder: (context, value, child) {
              final String reqId = data["_id"]; // or use a unique ID you have
              final bool isReturned = value.isReturned(reqId);
              final String status = data["status"] ?? "pending";

              // Only show "Return" button if status is 'accepted' and not already returned
              if (status != "accepted" || isReturned) {
                return const SizedBox(); // empty widget if conditions not met
              }

              return TextButton(
                onPressed: () {
                  value.increaseBookcountFromBookCollection(data["bookId"]);
                  value.markReturned(reqId);
                  Navigator.pop(context);
                },
                child: const Text("Return"),
              );
            },
          ),
        ],
      ),
    );
  }
}
