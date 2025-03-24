import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libpro/pages/librarian/functionality/qr_scanner_to_add_student.dart';
import 'package:libpro/provider/app_controller.dart';
import 'package:provider/provider.dart';

class AddStudent extends StatelessWidget {
  const AddStudent({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController studNameController = TextEditingController();
    TextEditingController studCourseController = TextEditingController();
    TextEditingController studDivisionController = TextEditingController();
    TextEditingController studBranchController = TextEditingController();
    TextEditingController studSemController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Student"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: studNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: const Icon(Icons.person),
                hintText: "Name",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: const Icon(Icons.email),
                hintText: "Student Email",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: studBranchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: const Icon(Icons.people),
                hintText: "Branch",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: studCourseController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: const Icon(CupertinoIcons.book),
                hintText: "Course",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: studSemController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: const Icon(Icons.numbers),
                hintText: "Semester",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: studDivisionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: const Icon(Icons.group_outlined),
                hintText: "Division",
              ),
            ),
            const SizedBox(height: 10),
            Consumer<AppController>(
              builder: (context, value, child) => OutlinedButton(
                onPressed: () {
                  value.addStudent(
                    context,
                      studNameController.text.toString().trim(),
                      emailController.text.toString().trim(),
                      studBranchController.text.toString().trim(),
                      studCourseController.text.toString().trim(),
                      studSemController.text.toString().trim(),
                      studDivisionController.text.toString().trim(),
                      value.loggedInUserEmail);

                  studNameController.clear();
                  emailController.clear();
                  studBranchController.clear();
                  studCourseController.clear();
                  studSemController.clear();
                  studDivisionController.clear();
                },
                child: const Text("Add Student"),
              ),
            ),
            Visibility(
              visible: !kIsWeb && (Platform.isAndroid || Platform.isIOS)
                  ? true
                  : false,
              child: const Row(
                children: [
                  Expanded(child: Divider()),
                  Text("or"),
                  Expanded(child: Divider())
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Visibility(
              visible: !kIsWeb && (Platform.isAndroid || Platform.isIOS)
                  ? true
                  : false,
              child: Consumer<AppController>(
                builder: (context, value, child) => OutlinedButton(
                    onPressed: () {
                      value.requestCameraPermission();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const QrScannerToAddStudent()));
                    },
                    child: const Text("Scan Qr")),
              ),
            )
          ],
        ),
      ),
    );
  }
}
