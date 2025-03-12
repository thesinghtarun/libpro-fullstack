import 'package:flutter/material.dart';

class StudentDetails extends StatelessWidget {
  final studentData;
  const StudentDetails({super.key, this.studentData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("Student Details"),);
  }
}
