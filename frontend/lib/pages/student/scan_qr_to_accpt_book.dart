import 'package:flutter/material.dart';
import 'package:libpro/provider/app_controller.dart';
import 'package:provider/provider.dart';

class ScanQrToAccptBook extends StatelessWidget {
  const ScanQrToAccptBook({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<AppController>(
          builder: (context, value, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              value.qrResultToAccptBook == null || value.qrResultToAccptBook!.isEmpty
                  ? const Text(
                      "Result will show here",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  : Text(
                      "Book Name: ${value.qrResultDataToAccptBook![2].toString()}",
                      style: const TextStyle(fontSize: 16),
                    ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () => value.showQrScannerToAccptBook(),
                child: const Text("Scan"),
              ),
              Consumer<AppController>(
                  builder: (context, value, child) => Visibility(
                      visible: value.qrResultDataToAccptBook == null ? false : true,
                      child: OutlinedButton(
                          onPressed: () {
                            // value.qrAddStudent(value.loggedInUserEmail);
                          },
                          child: const Text("Accept"))))
            ],
          ),
        ),
      ),
    );
  }
}
