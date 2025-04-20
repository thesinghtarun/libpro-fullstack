import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libpro/provider/app_controller.dart';
import 'package:provider/provider.dart';

class ScanQrToReturnBook extends StatelessWidget {
  const ScanQrToReturnBook({super.key, required this.bookReq});
  final Map<String, dynamic> bookReq;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Qr"),
      ),
      body: Center(
          child: !kIsWeb
              ? Platform.isAndroid || Platform.isIOS
                  ? Consumer<AppController>(
                      builder: (context, value, child) {
                        final qrData = value.qrResultDataToAccptBook;

                        // Check if QR data is valid and normalize it
                        final bool isValidQR =
                            qrData != null && qrData.length == 15;

                        // Normalize and trim both QR and book request data
                        final bool isMatchingBook = isValidQR &&
                            qrData[1].toString().trim() ==
                                bookReq["bookId"].toString().trim() &&
                            qrData[8].toString().trim() ==
                                bookReq["studentEmail"].toString().trim();

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!isValidQR)
                              const Text(
                                "Result will show here",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )
                            else
                              Text(
                                isMatchingBook
                                    ? "Book Name: ${qrData[2]}"
                                    : "You are scanning the wrong QR",
                                style: const TextStyle(fontSize: 16),
                              ),
                            const SizedBox(height: 20),

                            OutlinedButton(
                              onPressed: () => value.showQrScannerToAccptBook(),
                              child: const Text("Scan"),
                            ),

                            // Show "Accept" and "Deny" buttons when book matches
                            if (isMatchingBook) ...[
                              const SizedBox(height: 10),
                              OutlinedButton(
                                onPressed: () {
                                  value.handleBookRequest(
                                      bookReq["_id"], "accepted");
                                  value.decreaseBookcountFromBookCollection(
                                      bookReq["bookId"]);
                                  value.increaseCountForMostReqBook(
                                      context,
                                      bookReq["bookId"],
                                      bookReq["bookName"]
                                          .toString()
                                          .toLowerCase(),
                                      bookReq["bookEdition"],
                                      value.loggedUserRole == "Student"
                                          ? value.librarianEmail
                                          : value.loggedInUserEmail);
                                  Navigator.pop(context);
                                },
                                child: const Text("Accept"),
                              ),
                              const SizedBox(height: 10),
                              OutlinedButton(
                                onPressed: () {
                                  value.handleBookRequest(
                                      bookReq["_id"], "rejected");
                                  Navigator.pop(context);
                                },
                                style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red),
                                child: const Text("Reject"),
                              ),
                            ],

                            // Show warning when scanning the wrong QR
                            if (isValidQR && !isMatchingBook)
                              const Text(
                                "*You are scanning QR for the wrong book",
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            if (!isValidQR)
                              const Text(
                                "*You are scanning wrong QR",
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            OutlinedButton(
                              onPressed: () {
                                print("QR Scanned Data: ${qrData.toString()}");
                                value.revealScannedData();
                              },
                              child: const Text("Show Data"),
                            ),
                            Visibility(
                              visible: value.showScannedData,
                              child: Text(qrData == null
                                  ? "Data will show here"
                                  : qrData.toString()),
                            ),
                          ],
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/animated_mobile.png",
                            height: MediaQuery.of(context).size.height / 2.5,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "Use Mobile to scan QR",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/animated_mobile.png",
                        height: MediaQuery.of(context).size.height / 2.5,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Use Mobile to scan QR",
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
    );
  }
}
