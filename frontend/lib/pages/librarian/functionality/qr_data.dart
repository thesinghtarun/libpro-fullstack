import 'package:flutter/material.dart';
import 'package:libpro/provider/app_controller.dart';
import 'package:provider/provider.dart';

class QrData extends StatelessWidget {
  const QrData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<AppController>(
          builder: (context, value, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              value.qrResult == null || value.qrResult!.isEmpty
                  ? const Text(
                      "Result will show here",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  : Text(
                      value.qrResultData.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () => value.showQr(),
                child: const Text("Scan"),
              ),
              Consumer<AppController>(
                  builder: (context, value, child) => Visibility(
                      visible: value.qrResultData == null ? false : true,
                      child: OutlinedButton(
                          onPressed: () {
                            value.qrAddStudent(value.loggedInUserEmail);
                          },
                          child: const Text("Add Student"))))
            ],
          ),
        ),
      ),
    );
  }
}
