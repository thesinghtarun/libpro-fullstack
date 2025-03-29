import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libpro/pages/librarian/functionality/show_qr_for_book_req.dart';
import 'package:libpro/pages/student/scan_qr_to_accpt_book.dart';
import 'package:libpro/provider/app_controller.dart';
import 'package:provider/provider.dart';

class ShowAllRequest extends StatefulWidget {
  const ShowAllRequest({super.key});

  @override
  _ShowAllRequestState createState() => _ShowAllRequestState();
}

class _ShowAllRequestState extends State<ShowAllRequest> {
  late AppController appController;
  late Future<void> fetchDataFuture;

  @override
  void initState() {
    super.initState();
    appController = Provider.of<AppController>(context, listen: false);
    fetchDataFuture = appController.loggedUserRole == "Librarian"
        ? appController.getPendingReqBook()
        : appController.getReqBookByStudent(appController.loggedInUserEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Requested Books")),
      body: FutureBuilder(
        future: fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          return Consumer<AppController>(
            builder: (context, value, child) {
              var bookRequests = appController.loggedUserRole == "Librarian"
                  ? value.allRequestedBookData
                  : value.allReqDoneByStudent;

              if (bookRequests.isEmpty) {
                return const Center(child: Text("No book requests found"));
              }

              return ListView.builder(
                itemCount: bookRequests.length,
                itemBuilder: (context, index) {
                  var request = bookRequests[index];
                  return InkWell(
                    onTap: () {
                      if (appController.loggedUserRole == "Student") {
                        appController.resetQrDataToAccptBook();
                        if (!kIsWeb) {
                          if (Platform.isAndroid || Platform.isIOS) {
                            appController.requestCameraPermission();
                          }
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ScanQrToAccptBook(bookReq: request),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ShowQrForBookReq(bookReqData: request),
                          ),
                        );
                      }
                    },
                    child: Card(
                      elevation: 1,
                      child: ListTile(
                        title: Text(request['bookName'].toString().toUpperCase()),
                        subtitle:
                            Text("Requested by: ${request['studentEmail']}"),
                        trailing: Text("Days: ${request['days']}"),
                      ),
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
