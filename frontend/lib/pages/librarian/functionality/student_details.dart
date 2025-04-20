// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:libpro/provider/app_controller.dart';
import 'package:provider/provider.dart';

class StudentDetails extends StatelessWidget {
  const StudentDetails({super.key, this.studentData});
  final studentData;

  @override
  Widget build(BuildContext context) {
    TextEditingController studentNameController = TextEditingController();
    TextEditingController studentEmailController = TextEditingController();
    TextEditingController studentBranchController = TextEditingController();
    TextEditingController studentDivController = TextEditingController();
    TextEditingController studentSemController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text("Add Book")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<AppController>(
              builder: (context, value, child) => Column(
                children: [
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Student Name",
                        style: TextStyle(fontSize: 20),
                      )),
                  TextField(
                    controller: studentNameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: studentData["name"].toString(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft, child: Text("Email")),
                  TextField(
                    controller: studentEmailController,
                    decoration: InputDecoration(
                      enabled: false,
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: studentData["email"].toString(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft, child: Text("Branch")),
                  TextField(
                    controller: studentBranchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.category),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: studentData["branch"].toString(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft, child: Text("Division")),
                  TextField(
                    controller: studentDivController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.abc),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: studentData["div"].toString(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft, child: Text("Semister")),
                  TextField(
                    controller: studentSemController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.numbers),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: studentData["sem"].toString(),
                    ),
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
      ),
    );
  }
}
