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
            child: Consumer<AppController>(
              builder: (context, value, child) => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                          value.loggedUserRole == "Librarian"
                              ? "Book Availablity"
                              : "Available",
                          style: value.isBookAvailable
                              ? const TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold)
                              : const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold)),
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
                            }),
                      )
                    ],
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Book Name",
                        style: TextStyle(fontSize: 20),
                      )),
                  TextField(
                    controller: bookNameController,
                    decoration: InputDecoration(
                      enabled:
                          value.loggedUserRole == "Librarian" ? true : false,
                      prefixIcon: const Icon(Icons.book),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: bookData["bookName"].toString(),
                    ),
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
                      enabled:
                          value.loggedUserRole == "Librarian" ? true : false,
                      prefixIcon: const Icon(Icons.category),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: bookData["bookCategory"].toString(),
                    ),
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
                      enabled:
                          value.loggedUserRole == "Librarian" ? true : false,
                      prefixIcon: const Icon(Icons.numbers),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: bookData["bookCount"].toString(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Published By")),
                  TextField(
                    controller: bookPublisherController,
                    decoration: InputDecoration(
                      enabled:
                          value.loggedUserRole == "Librarian" ? true : false,
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: bookData["bookPublisher"].toString(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft, child: Text("Edition")),
                  TextField(
                    controller: bookEditionController,
                    decoration: InputDecoration(
                      enabled:
                          value.loggedUserRole == "Librarian" ? true : false,
                      prefixIcon: const Icon(Icons.edit),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: bookData["bookEdition"].toString(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft, child: Text("Price")),
                  TextField(
                    controller: bookPriceController,
                    decoration: InputDecoration(
                      enabled:
                          value.loggedUserRole == "Librarian" ? true : false,
                      prefixIcon: const Icon(Icons.currency_rupee),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: bookData["bookPrice"].toString(),
                    ),
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
                      enabled:
                          value.loggedUserRole == "Librarian" ? true : false,
                      prefixIcon: const Icon(Icons.calendar_month),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: bookData["bookPublishedYear"].toString(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: value.loggedUserRole == "Student"
                        ? value.isBookAvailable
                            ? true
                            : false
                        : true,
                    child: OutlinedButton(
                      onPressed: () {
                        value.loggedUserRole == "Student"
                            ? showOptionDialog(context, value)
                            : print("Admin");
                      },
                      child: Text(value.loggedUserRole == "Librarian"
                          ? "Update"
                          : "Ask for Book"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showOptionDialog(BuildContext context, AppController value) {
    TextEditingController daysController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          title: const Text(
            "For how many days\nYou want this book?",
            style: TextStyle(fontSize: 14),
          ),
          content: TextField(
            controller: daysController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: const Icon(Icons.calendar_month),
              hintText: "Days",
            ),
            // obscureText: true,
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                value.reqBook(
                    bookData["_id"],
                    bookData["bookName"],
                    bookData["bookCategory"],
                    bookData["bookPublisher"],
                    bookData["bookEdition"],
                    bookData["bookPrice"],
                    bookData["bookPublishedYear"],
                    value.loggedInUserEmail,
                    daysController.text);
                Navigator.pop(context);
              },
              child: const Text("Ask for Book"),
            ),
          ],
        );
      },
    );
  }
}
