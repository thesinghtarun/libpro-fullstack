import 'package:flutter/material.dart';

class ShowEachRequestQr extends StatelessWidget {
  const ShowEachRequestQr({super.key, this.bookReqData});
  final bookReqData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(bookReqData["bookName"]),
    );
  }
}
