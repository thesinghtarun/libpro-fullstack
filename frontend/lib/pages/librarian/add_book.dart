import 'package:flutter/material.dart';
import 'package:libpro/provider/app_controller.dart';
import 'package:provider/provider.dart';

class AddBook extends StatelessWidget {
  const AddBook({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController bookNameController = TextEditingController();
    TextEditingController bookCategoryController = TextEditingController();
    final TextEditingController bookPublisherController =
        TextEditingController();
    TextEditingController bookEditionController = TextEditingController();
    final TextEditingController bookPriceController = TextEditingController();
    final TextEditingController bookPublishedYearController =
        TextEditingController();
    final TextEditingController bookCountController = TextEditingController();

    return 
    Scaffold(
      appBar: AppBar(title: const Text("Add Book")),
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: bookNameController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.book),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Book Name"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: bookCategoryController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Book Category"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: bookCountController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.numbers),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Count"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: bookPublisherController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Publisher"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: bookEditionController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.edit),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Edition"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: bookPriceController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Price"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: bookPublishedYearController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_month),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Published Year"),
            ),
            const SizedBox(
              height: 20,
            ),
            Consumer<AppController>(
              builder: (context, value, child) => OutlinedButton(
                  onPressed: () {
                    value.addBook(
                        bookNameController.text.toString().trim(),
                        bookCategoryController.text.toString().trim(),
                        int.parse(bookCountController.text.trim()),
                        bookPublisherController.text.toString().trim(),
                        bookEditionController.text.toString().trim(),
                        int.parse(bookPriceController.text.trim()),
                        int.parse(bookPublishedYearController.text.trim()),
                        value.loggedInUserEmail);
                    bookNameController.text = "";
                    bookPublisherController.text = "";
                    bookPriceController.text = "";
                    bookPublishedYearController.text = "";
                    bookCountController.text = "";
                  },
                  child: const Text("Add Book")),
            )
          ],
        ),
      ),
    );
  }
}
