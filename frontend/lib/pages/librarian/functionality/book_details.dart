import 'package:flutter/material.dart';

class BookDetails extends StatelessWidget {
  const BookDetails({super.key, this.bookData});
  final bookData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("Book Details"),);
  }
}