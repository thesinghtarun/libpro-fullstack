// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:libpro/consts.dart';
import 'package:libpro/pages/common/authentication/login_screen.dart';
import 'package:libpro/pages/common/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class AppController extends ChangeNotifier {
  var loggedInUserEmail;
  var loggedUserRole;
  var studentData;
  var bookData;
  //to change index of homeScreen
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  //API call for login
  login(String email, String password, BuildContext context) async {
    loggedInUserEmail = email;

    if (email.isEmpty || password.isEmpty) {
      print("Enter Credentials");
      return;
    }

    String loginApi = "${api}api/login";
    var url = Uri.parse(loginApi);

    try {
      var data = jsonEncode({"email": email, "password": password});
      var res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: data,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        var userData = jsonDecode(res.body);
        loggedUserRole = userData["user"]["role"];
        print("User Role: $loggedUserRole");
        print("User Email: $loggedInUserEmail");
        await getLibraianEmail();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        print("Login failed: ${res.statusCode} - ${res.body}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  // API call for registration
  signUp(
      String name, String email, String password, BuildContext context) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return print("Enter Data");
    }
    String signUpApi = "${api}api/signUp";
    var url = Uri.parse(signUpApi);

    try {
      var data = jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "role": "Librarian"
      });
      print(data);
      var res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: data,
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    } catch (e) {
      print("Error occurred while calling API for sign-up: $e");
      return {"success": false, "error": e.toString()};
    }
  }

  //API call for addStudent
  addStudent(String name, String email, String branch, String course,
      String sem, String div, String addedBy) async {
    var addStudentUrl = "${api}api/addStudent";
    String password = "Welcome";
    String role = "Student";
    var data = jsonEncode({
      "name": name,
      "email": email,
      "password": password,
      "role": role,
      "branch": branch,
      "course": course,
      "sem": sem,
      "div": div,
      "addedBy": addedBy
    });
    try {
      var url = Uri.parse(addStudentUrl);
      var res = await http.post(url,
          headers: {
            "Content-Type": "application/json",
          },
          body: data);
      print(data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        print(jsonDecode(res.body));
      }
      if (res.statusCode != 200 || res.statusCode != 201) {
        print(res.statusCode);
      }
    } catch (e) {
      print("error while adding student $e");
    }
  }

  //API call for addBook
  addBook(String name, String category, int count, String publisher,
      String edition, int price, int publishedYear, String addedBy) async {
    var addBookUrl = "${api}api/addBook";
    var data = jsonEncode({
      "bookName": name,
      "bookCategory": category,
      "bookCount": count,
      "bookPublisher": publisher,
      "bookEdition": edition,
      "bookPrice": price,
      "bookPublishedYear": publishedYear,
      "addedBy": addedBy
    });
    try {
      var url = Uri.parse(addBookUrl);
      var res = await http.post(url,
          headers: {
            "Content-Type": "application/json",
          },
          body: data);
      print(data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        print(jsonDecode(res.body));
      }
      if (res.statusCode != 200 || res.statusCode != 201) {
        print(res.statusCode);
      }
    } catch (e) {
      print("error while adding bookR $e");
    }
  }

  // Fetch all students
  Future<List<dynamic>> showAllStudents() async {
    var url = "${api}api/showAllStudents";
    try {
      var showAllStudentUrl = Uri.parse(url);
      var res = await http.post(showAllStudentUrl,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"addedBy": loggedInUserEmail}));

      if (res.statusCode == 200 || res.statusCode == 201) {
        var data = jsonDecode(res.body);
        return data["students"] ?? []; // Return only the student list
      } else {
        print("Error ${res.statusCode}: ${res.body}");
      }
    } catch (e) {
      print("Error while fetching students: $e");
    }
    return []; // Return empty list if error occurs
  }

  // Fetch all books

  Future<List<dynamic>> showAllBooks() async {
    var url = "${api}api/showAllBooks";
    var showAllBooksUrl = Uri.parse(url);

    try {
      final res = await http.post(
        showAllBooksUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"addedBy": librarianEmail ?? loggedInUserEmail}),
      );

      print("Response Status Code: ${res.statusCode}");
      print("Response Body: ${res.body}"); // Log full response

      if (res.statusCode == 200 || res.statusCode == 201) {
        List<dynamic> data = jsonDecode(res.body);

        return data;
      } else {
        print("Error ${res.statusCode}: ${res.body}");
        throw Exception("Server returned an error: ${res.body}");
      }
    } catch (e) {
      print("Error while fetching books: $e");
      print(7); // Print full stack trace
    }

    return [];
  }

//camera permission
  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      debugPrint("Camera permission granted");
    } else {
      debugPrint("Camera permission denied");
    }
  }

  //qrCode
  List<dynamic>? qrResultData;
  String? qrResult;
  showQr() async {
    try {
      qrResult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (qrResult != null || qrResult!.isNotEmpty) {
        qrResultData = qrResult!.split(",");
      }
      notifyListeners();
    } on PlatformException {
      qrResult = 'Failed to get platform version.';
      notifyListeners();
    }
  }

//temp addStudent
  qrAddStudent(String addedBy) async {
    var addStudentUrl = "${api}api/addStudent";
    String password = "Welcome";
    String role = "Student";
    var data = jsonEncode({
      "name": qrResultData![0],
      "email": qrResultData![1],
      "password": password,
      "role": role,
      "branch": qrResultData![2],
      "course": qrResultData![3],
      "sem": qrResultData![4],
      "div": qrResultData![5],
      "addedBy": addedBy
    });

    try {
      var url = Uri.parse(addStudentUrl);
      var res = await http.post(url,
          headers: {
            "Content-Type": "application/json",
          },
          body: data);
      print(data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        print(jsonDecode(res.body));
        qrResultData = null;
        notifyListeners();
      }
      if (res.statusCode != 200 || res.statusCode != 201) {
        print(res.statusCode);
      }
    } catch (e) {
      print("error while adding student $e");
    }
  }

  //to get librarian Email
  var librarianEmail;
  Future<void> getLibraianEmail() async {
    var data = jsonEncode({"role": loggedUserRole, "email": loggedInUserEmail});
    var uri = "${api}api/fetchLibrarianEmail";
    var url = Uri.parse(uri);

    try {
      var res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: data,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        var responseBody = jsonDecode(res.body);
        librarianEmail = responseBody["addedBy"];
        print(librarianEmail);
      } else {
        print("Error: ${res.statusCode} - ${res.body}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  //book availablity
  bool isBookAvailable = true;
  void toggleBookAvailablity() {
    isBookAvailable = !isBookAvailable;
    notifyListeners();
  }

  //to update in db
  Future<void> updateAvailablityInDb(bookId, bookAvailablity) async {
    var uri = "${api}api/updateBookavailablity";
    var url = Uri.parse(uri);
    var data = jsonEncode({"_id": bookId, "bookAvailablity": bookAvailablity});
    try {
      var res = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        print("Availablity updation Done");
        var bookData = jsonDecode(res.body);
        isBookAvailable = bookData["updatedBook"]["bookAvailablity"];
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  //get book Availablity from Db
  Future<void> getBookAvailablityFromDb(bookId) async {
    var uri = "${api}api/getBookAvailablity/";
    var url = Uri.parse(uri);
    var data = jsonEncode({"_id": bookId});
    try {
      var res = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: data);

      if (res.statusCode == 200) {
        var bookData = jsonDecode(res.body);
        print("trye: $bookData");
        isBookAvailable = bookData["bookAvailablity"];
        notifyListeners();
      } else {
        print("Failed to fetch book availability: ${res.body}");
      }
    } catch (e) {
      print("Error fetching book availability: $e");
    }
  }
}
