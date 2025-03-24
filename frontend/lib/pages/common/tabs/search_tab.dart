// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:libpro/pages/librarian/functionality/book_details.dart';
import 'package:libpro/provider/app_controller.dart';
import 'package:provider/provider.dart';

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: Consumer<AppController>(
                          builder: (context, value, child) => InkWell(
                            onTap: () {
                              // value.fetchBookBasedOnCategoryData = null;
                              value.searchBook(
                                context,
                                  searchController.text.trim().toLowerCase());
                            },
                            child: const Icon(Icons.search),
                          ),
                        ),
                        hintText: "Search book",
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),

                  /// ✅ Filter Icon with Categories
                  Consumer<AppController>(
                    builder: (context, value, child) => InkWell(
                      onTap: () async {
                        await value.fetchAllCategory(
                            value.loggedUserRole == "Student"
                                ? value.librarianEmail
                                : value.loggedInUserEmail);

                        if (value.allCategoryData != null &&
                            value.allCategoryData['bookCategory'] != null) {
                          _showSmallDialog(context, value);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("No categories found"),
                            ),
                          );
                        }
                      },
                      child: const Icon(
                        Icons.filter_alt,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// ✅ Book List with Proper Null Safety Handling
              Expanded(
                child: Consumer<AppController>(
                  builder: (context, value, child) {
                    var data = value.fetchBookBasedOnCategoryData;

                    if (data == null) {
                      return Center(
                        child: Image.asset(
                          "assets/images/search.png",
                          height: MediaQuery.of(context).size.height / 2.5,
                        ),
                      );
                    }

                    // Handle empty list or no data
                    if (data is List && data.isEmpty) {
                      return const Center(
                        child: Text("No books found for this category"),
                      );
                    }

                    // Display books when data is a List
                    if (data is List) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var book = data[index] ?? {};
                            return Card(
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => BookDetails(
                                              bookData: book,
                                            ))),
                                child: SizedBox(
                                  width: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          book["bookName"]
                                                  .toString()
                                                  .toUpperCase() ??
                                              "Unnamed",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "Category: ${book["bookCategory"] ?? "Unknown"}",
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }

                    // Handle single book (map case)
                    if (data is Map) {
                      return Card(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data["bookName"].toString().toUpperCase() ??
                                    "Unnamed",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Category: ${data["bookCategory"] ?? "Unknown"}",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Fallback for unexpected data types
                    return const Center(child: Text("No books found"));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Improved Category Dialog
  void _showSmallDialog(BuildContext context, AppController controller) {
    List<dynamic> categories = controller.allCategoryData['bookCategory'] ?? [];

    final screenSize = MediaQuery.of(context).size;
    const double dialogWidth = 250;
    const double dialogHeight = 200;

    showDialog(
      context: context,
      builder: (context) => Stack(
        children: [
          Positioned(
            top: 100,
            left: screenSize.width - dialogWidth - 20,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: dialogWidth,
                height: dialogHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "Categories",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: categories.isEmpty
                          ? const Center(child: Text("No categories available"))
                          : ListView.builder(
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                var category = categories[index];
                                return InkWell(
                                  onTap: () async {
                                    Navigator.pop(context); // Close dialog
                                    await controller.fetchBookBasedOnCategory(
                                        category["bookCategory"],
                                        controller.loggedUserRole == "Student"
                                            ? controller.librarianEmail
                                            : controller.loggedInUserEmail);
                                  },
                                  child: Card(
                                    elevation: 0.5,
                                    child: ListTile(
                                      leading: const Icon(Icons.book),
                                      title: Text(category['bookCategory']),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
