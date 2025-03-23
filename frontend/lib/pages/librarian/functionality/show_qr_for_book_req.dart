import 'package:flutter/material.dart';
import 'package:libpro/provider/app_controller.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShowQrForBookReq extends StatelessWidget {
  const ShowQrForBookReq({super.key, this.bookReqData});
  final dynamic bookReqData;

  List<String> _normalizeData(dynamic data) {
    List<String> bookReqDataValue = [];

    if (data != null) {
      if (data is List) {
        // Flatten and trim all elements in the list
        for (var item in data) {
          if (item is List) {
            bookReqDataValue.addAll(item.map((e) => e.toString().trim()));
          } else {
            bookReqDataValue.add(item.toString().trim());
          }
        }
      } else if (data is Map) {
        // Convert map values to a list and trim them
        bookReqDataValue = data.values.map((e) => e.toString().trim()).toList();
      }
    }

    return bookReqDataValue;
  }

  @override
  Widget build(BuildContext context) {
    final bookReqDataValue = _normalizeData(bookReqData);

    return Scaffold(
      appBar: AppBar(title: Text(bookReqData["bookName"]),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Scan to accept "${bookReqData?["bookName"] ?? ""}" book',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            QrImageView(
              data: bookReqDataValue
                  .join(', '), // Flattened & trimmed list as string
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(
              height: 15,
            ),
            Consumer<AppController>(
                builder: (context, value, child) => OutlinedButton(
                    onPressed: () {
                       print("qrScannedData: ${bookReqDataValue.toString()}");
                      value.revealQrData();
                    },
                    child: const Text("Show Data"))),
            Consumer<AppController>(
                builder: (context, value, child) =>Visibility(
                visible: value.showData?true:false,
                child: Text(bookReqDataValue.isEmpty
                    ? "Data will show here"
                    : bookReqDataValue.toString()))),
          ],
        ),
      ),
    );
  }
}
