// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:libpro/provider/app_controller.dart';
import 'package:provider/provider.dart';

class BookDetails extends StatelessWidget {
  const BookDetails({super.key, this.bookData});
  final bookData;

  @override
  Widget build(BuildContext context) {
    TextEditingController bookNameController = TextEditingController();
    TextEditingController bookCategoryController = TextEditingController();
    TextEditingController bookCountController = TextEditingController();
    TextEditingController bookPublisherController = TextEditingController();
    TextEditingController bookEditionController = TextEditingController();
    TextEditingController bookPriceController = TextEditingController();
    TextEditingController bookPublishedYearController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text("Add Book")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Consumer<AppController>(
                  builder: (context, value, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                          value.loggedUserRole == "Librarian"
                              ? "Book Availablity"
                              : "Available",
                          style: value.loggedUserRole == "Student"
                              ? value.isBookAvailable
                                  ? const TextStyle(color: Colors.greenAccent)
                                  : const TextStyle(color: Colors.redAccent)
                              : null),
                      Visibility(
                        visible:
                            value.loggedUserRole == "Librarian" ? true : false,
                        child: Switch(
                            value: value.isBookAvailable,
                            activeColor: Colors.green,
                            onChanged: (val) async {
                              value.toggleBookAvailablity();

                              await value.updateAvailablityInDb(
                                  bookData["_id"], value.isBookAvailable);
                              print("Value: ${value.isBookAvailable}");
                            }),
                      )
                    ],
                  ),
                ),
                const Align(
                    alignment: Alignment.centerLeft, child: Text("Book Name")),
                TextField(
                  controller: bookNameController,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.book),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: bookData["bookName"].toString()),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Book Category")),
                TextField(
                  controller: bookCategoryController,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.category),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: bookData["bookCategory"].toString()),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Available Book")),
                TextField(
                  controller: bookCountController,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.numbers),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: bookData["bookCount"].toString()),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Publisher By")),
                TextField(
                  controller: bookPublisherController,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: bookData["bookPublishedYear"].toString()),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                    alignment: Alignment.centerLeft, child: Text("Edition")),
                TextField(
                  controller: bookEditionController,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.edit),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: bookData["bookEdition"].toString()),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                    alignment: Alignment.centerLeft, child: Text("Price")),
                TextField(
                  controller: bookPriceController,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.currency_rupee),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: bookData["bookPrice"].toString()),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Published Year"),
                ),
                TextField(
                  controller: bookPublishedYearController,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.calendar_month),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: bookData["bookPublishedYear"].toString()),
                ),
                const SizedBox(
                  height: 20,
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text("Update"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
