import 'package:flutter/material.dart';
import 'package:libpro/provider/app_controller.dart';
import 'package:provider/provider.dart';

class ScanQrToAccptBook extends StatelessWidget {
  const ScanQrToAccptBook({super.key, required this.bookReq});
  final Map<String, dynamic> bookReq;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<AppController>(
          builder: (context, value, child) {
            final qrData = value.qrResultDataToAccptBook;

            // Check if QR data is valid and normalize it
            final bool isValidQR = qrData != null && qrData.length == 14;

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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      value.handleBookRequest(bookReq["_id"], "accepted");
                      Navigator.pop(context);
                    },
                    child: const Text("Accept"),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      value.handleBookRequest(bookReq["_id"], "rejected");
                      Navigator.pop(context);
                    
                    },
                    style:
                        OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text("Reject"),
                  ),
                ],

                // Show warning when scanning the wrong QR
                if (isValidQR && !isMatchingBook)
                  const Text(
                    "*You are scanning QR for the wrong book",
                    style: TextStyle(color: Colors.redAccent),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
