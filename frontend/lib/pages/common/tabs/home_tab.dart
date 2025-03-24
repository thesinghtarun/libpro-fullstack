// ignore_for_file: use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:libpro/pages/librarian/functionality/book_details.dart';
import 'package:libpro/pages/librarian/functionality/student_details.dart';
import 'package:libpro/provider/app_controller.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final appController = Provider.of<AppController>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Consumer<AppController>(
          builder: (context, value, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  value.loggedUserRole == "Librarian" ? "Librarian" : "Student",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  value.loggedUserRole == "Librarian"
                      ? "All Students"
                      : "All Books",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),

              /// **FutureBuilder to Fetch Books or Students**
              Flexible(
                flex: 1,
                child: FutureBuilder<List>(
                  future: value.loggedUserRole == "Librarian"
                      ? value.showAllStudents(context) // Fetch students if Librarian
                      : value.showAllBooks(context), // Fetch books if Student
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                          child: Text("Error: ${snapshot.error}",
                              style: const TextStyle(color: Colors.red)));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          children: [
                            Image.asset(
                              value.loggedUserRole != "Librarian"
                                  ? "assets/images/no_book.png"
                                  : "assets/images/no_stud.png",
                              height: 90,
                            ),
                            const Text("No data available"),
                          ],
                        ),
                      );
                    }

                    List data = snapshot.data!;

                    return CarouselSlider.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index, realIndex) {
                        final item = data[index];

                        return InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      value.loggedUserRole == "Librarian"
                                          ? StudentDetails(
                                              studentData: data,
                                            )
                                          : BookDetails(
                                              bookData: data,
                                            ))),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  value.loggedUserRole == "Librarian"
                                      ? "${item["name"] ?? "Unnamed Student"}"
                                      : " ${item["bookName"].toString().toUpperCase() ?? "Unnamed Book"}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  value.loggedUserRole == "Librarian"
                                      ? "Email: ${item["email"] ?? "No Email"}"
                                      : "Category: ${item["bookCategory"] ?? "Unknown"}",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: height / 3,
                        enlargeCenterPage: true,
                        viewportFraction: 0.75,
                        autoPlay: true,
                        autoPlayCurve: Curves.fastOutSlowIn,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  "All Books",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),

              /// **FutureBuilder for Books ListView**
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FutureBuilder<List>(
                    future: appController.showAllBooks(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                            child: Text("Error: ${snapshot.error}",
                                style: const TextStyle(color: Colors.red)));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            children: [
                              Image.asset("assets/images/no_book.png",
                                  height: 90),
                              const Text("No books available"),
                            ],
                          ),
                        );
                      }

                      List data = snapshot.data!;

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index];

                          return SizedBox(
                            width: 200,
                            child: Consumer<AppController>(
                              builder: (context, value, child) => InkWell(
                                onTap: () async {
                                  await value
                                      .getBookAvailablityFromDb(item["_id"]);
                                  print("id: ${item["_id"]}");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => BookDetails(
                                                bookData: item,
                                              )));
                                },
                                child: Card(
                                  color: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${item["bookName"].toString().toUpperCase() ?? "Unnamed"}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "Category: ${item["bookCategory"] ?? "Unknown"}",
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
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
