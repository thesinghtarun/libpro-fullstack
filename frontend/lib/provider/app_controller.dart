// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:libpro/consts.dart';
import 'package:libpro/helper/ui_helper.dart';
import 'package:libpro/pages/common/authentication/login_screen.dart';
import 'package:libpro/pages/common/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class AppController extends ChangeNotifier {
  var loggedInUserEmail;
  var loggedUserRole;
  var studentData;
  var bookData;
  var loggedInUserData;

  //to change index of homeScreen
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  bool isLoading = false;
  void loading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  //API call for login
  login(String email, String password, BuildContext context) async {
    loading();
    loggedInUserEmail = email;

    if (email.isEmpty || password.isEmpty) {
      UiHelper.showSnackbar(context, "Enter Credentials");

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
        loggedInUserData = userData["user"];
        print("User Role: $loggedUserRole");
        print("User Email: $loggedInUserData");
        await getLibraianEmail();
        print("userData: $userData");
        loading();
        UiHelper.showSnackbar(context, "Logged in successfully");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        notifyListeners();
      } else {
        UiHelper.showSnackbar(context, "Login failed: - ${res.body}");
      }
    } catch (e) {
      UiHelper.showSnackbar(context, "Error occurred: $e");
    }
  }

  // API call for registration
  signUp(
      String name, String email, String password, BuildContext context) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return UiHelper.showSnackbar(context, "Enter Data");
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
        UiHelper.showSnackbar(context, "User registered successfully");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    } catch (e) {
      UiHelper.showSnackbar(
          context, "Error occurred while calling API for sign-up: $e");
      return {"success": false, "error": e.toString()};
    }
  }

  //API call for addStudent
  addStudent(context, String name, String email, String branch, String course,
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
        UiHelper.showSnackbar(context, "Student added");
      }
    } catch (e) {
      UiHelper.showSnackbar(context, "error while adding student $e");
    }
  }

  //API call for addBook
  addBook(context, String name, String category, int count, String publisher,
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
      // print(data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        print(jsonDecode(res.body));
      }
      if (res.statusCode != 200 || res.statusCode != 201) {
        UiHelper.showSnackbar(context, "Book added");
      }
    } catch (e) {
      UiHelper.showSnackbar(context, "error while adding bookR $e");
    }
  }

  // Fetch all students
  Future<List<dynamic>> showAllStudents(context) async {
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
        UiHelper.showSnackbar(context, "Error ${res.statusCode}: ${res.body}");
      }
    } catch (e) {
      UiHelper.showSnackbar(context, "Error while fetching students: $e");
    }
    return []; // Return empty list if error occurs
  }

  // Fetch all books

  Future<List<dynamic>> showAllBooks(context) async {
    var url = "${api}api/showAllBooks";
    var showAllBooksUrl = Uri.parse(url);

    try {
      final res = await http.post(
        showAllBooksUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"addedBy": librarianEmail ?? loggedInUserEmail}),
      );

      // print("Response Status Code: ${res.statusCode}");
      // print("Response Body: ${res.body}"); // Log full response

      if (res.statusCode == 200 || res.statusCode == 201) {
        List<dynamic> data = jsonDecode(res.body);

        return data;
      } else {
        UiHelper.showSnackbar(context, "Error ${res.statusCode}: ${res.body}");
        throw Exception("Server returned an error: ${res.body}");
      }
    } catch (e) {
      UiHelper.showSnackbar(context, "Error while fetching books: $e");
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

  //qrCode scanner to add student
  List<dynamic>? qrResultData;
  String? qrResult;
  showQrScannerToAddStudent() async {
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

//qr scanner to accpt book
  String? qrResultToAccptBook;
  List<dynamic>? qrResultDataToAccptBook;
  showQrScannerToAccptBook() async {
    try {
      qrResultToAccptBook = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (qrResultToAccptBook != null || qrResultToAccptBook!.isNotEmpty) {
        qrResultDataToAccptBook = qrResultToAccptBook!.split(",");
      }
      notifyListeners();
      print("qrResultDataReq: $qrResultDataToAccptBook ");
    } on PlatformException {
      qrResultToAccptBook = 'Failed to get platform version.';
      notifyListeners();
    }
  }

  //to resetQrData
  void resetQrDataToAccptBook() {
    qrResultToAccptBook = null;
    qrResultDataToAccptBook = null;
    notifyListeners();
  }

//addStudent using qr
  qrAddStudent(context, String addedBy) async {
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
        UiHelper.showSnackbar(context, "Student added");
      }
    } catch (e) {
      UiHelper.showSnackbar(context, "error while adding student $e");
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
  Future<void> updateAvailablityInDb(context, bookId, bookAvailablity) async {
    var uri = "${api}api/updateBookavailablity";
    var url = Uri.parse(uri);
    var data = jsonEncode({"_id": bookId, "bookAvailablity": bookAvailablity});
    try {
      var res = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        UiHelper.showSnackbar(context, "Availablity updation Done");
        var bookData = jsonDecode(res.body);
        isBookAvailable = bookData["updatedBook"]["bookAvailablity"];
        notifyListeners();
      }
    } catch (e) {
      UiHelper.showSnackbar(context, e.toString());
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

  //to change theme
  bool day = true;
  bool isImageVisible = false;
  ThemeMode themeMode = ThemeMode.light;
  void changeTheme() {
    Timer(const Duration(seconds: 3), () {
      isImageVisible = false;
      notifyListeners();
    });
    day = !day;
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    isImageVisible = true; // Show the image
    notifyListeners();
  }

  //to req book

  Future<void> reqBook(
      bookId,
      bookName,
      bookCategory,
      bookPublisher,
      bookEdition,
      bookPrice,
      bookPublishedYear,
      studentEmail,
      addedBy,
      days) async {
    var uri = "${api}api/requestBook";
    var url = Uri.parse(uri);
    try {
      var data = jsonEncode({
        "bookId": bookId,
        "bookName": bookName,
        "bookCategory": bookCategory,
        "bookPublisher": bookPublisher,
        "bookEdition": bookEdition,
        "bookPrice": bookPrice,
        "bookPublishedYear": bookPublishedYear,
        "studentEmail": studentEmail,
        "addedBy": addedBy,
        "days": days,
      });
      var res = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        final reqBookData = jsonDecode(res.body);
        if (reqBookData != null) {
          print(reqBookData);
          notifyListeners();
        }
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  //to show all request
  var allRequestedBookData;
  Future<void> getPendingReqBook() async {
    var uri = "${api}api/getPendingReqBook";
    var url = Uri.parse(uri);
    var data = jsonEncode({"addedBy": loggedInUserEmail});
    try {
      var res = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        var reqBookData = jsonDecode(res.body);
        allRequestedBookData = reqBookData["requestedBook"];
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  //to show reqested book to student
  var allReqDoneByStudent;
  Future<void> getReqBookByStudent(
    String studentEmail,
  ) async {
    var uri = "${api}api/getReqBookForStudent";
    var url = Uri.parse(uri);
    var data = jsonEncode({"studentEmail": studentEmail, "status": "pending"});
    try {
      var res = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        var bookData = jsonDecode(res.body);
        allReqDoneByStudent = bookData["requestedBook"];
      }
      notifyListeners();
      print("AllReq" + allReqDoneByStudent.toString());
    } catch (e) {
      print(e);
    }
  }

  //update status to accepted or deny
  Future<void> handleBookRequest(String reqBookId, String status) async {
    var uri = "${api}api/updateBookRequestStatus";
    var url = Uri.parse(uri);
    var data = jsonEncode({"requestId": reqBookId, "status": status});
    try {
      var res = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        print("Status updated");
      }
    } catch (e) {
      print(e);
    }
  }

  //hide accept/reject button
  bool hide = false;
  void hideButton() {
    hide = true;
    notifyListeners();
  }

  //to show data of qr in show_qr_for_book_req
  bool showData = false;
  void revealQrData() {
    showData = !showData;
    notifyListeners();
  }

  //to show data scanned in scan_qr_to_accpt_book
  bool showScannedData = false;
  void revealScannedData() {
    showScannedData = !showScannedData;
    notifyListeners();
  }

  //to decrease book count
  Future<void> decreaseBookcountFromBookCollection(String bookId) async {
    var uri = "${api}api/decreaseBookCount";
    var url = Uri.parse(uri);
    var data = jsonEncode({"bookId": bookId});
    try {
      var res = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        print("Book count reduced");
      } else {
        print("Nothing happend");
      }
    } catch (e) {
      print(e);
    }
  }

  //to show all book req accpted by student
  var allReqAccptedByStudent;
  Future<List<dynamic>> getReqAcceptedByStudent(String studentEmail) async {
    var uri = "${api}api/getReqBookForStudent";
    var url = Uri.parse(uri);
    var data = jsonEncode({"studentEmail": studentEmail, "status": "accepted"});

    try {
      var res = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: data);

      if (res.statusCode == 200 || res.statusCode == 201) {
        var bookData = jsonDecode(res.body);

        // ✅ Store and return the data
        allReqAccptedByStudent = bookData["requestedBook"];
        print("All Accepted Books: $allReqAccptedByStudent");

        return allReqAccptedByStudent; // ✅ Return the data
      } else {
        print("Failed to fetch data. Status: ${res.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

//to fetch all Category
  var allCategoryData;
  Future<void> fetchAllCategory(String addedBy) async {
    final data = jsonEncode({"addedBy": addedBy});
    var uri = "${api}api/fetchBookCategory";
    var url = Uri.parse(uri);

    try {
      var res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: data,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        // ✅ Correct status code check
        allCategoryData = jsonDecode(res.body);
        print("AllCategory: $allCategoryData");
        notifyListeners();
      } else {
        print("Error: ${res.statusCode} - ${res.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

//to fetch book based on category and same librarian
  var fetchBookBasedOnCategoryData;
  Future<void> fetchBookBasedOnCategory(String category, String addedBy) async {
    var uri = "${api}api/fetchBookBasedOnCategory";
    var url = Uri.parse(uri);
    var data = jsonEncode({"bookCategory": category, "addedBy": addedBy});
    try {
      var res = await http.post(url,
          headers: {"Content-type": "application/json"}, body: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        fetchBookBasedOnCategoryData = jsonDecode(res.body);
        print("fetchBookBasedOnCategoryData: $fetchBookBasedOnCategoryData");
        notifyListeners();
      } else {
        print("Error: ${res.statusCode} - ${res.body}");
      }
    } catch (e) {
      print(e);
    }
  }

  //to update password
  Future<void> updatePassword(context, String email, String password) async {
    var uri = "${api}api/updatePassword";
    var url = Uri.parse(uri);
    if (password.isEmpty) {
      UiHelper.showSnackbar(context, "Enter password");
    }
    var data = jsonEncode({"email": email, "password": password});
    try {
      var res = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        UiHelper.showSnackbar(context, "Password updated successfully");
      } else {
        UiHelper.showSnackbar(context, "Something went wrong");
      }
    } catch (e) {
      UiHelper.showSnackbar(context, e.toString());
    }
  }

  //to search book
  Future<void> searchBook(context, String bookName) async {
    var uri = "${api}api/searchBookController";
    var url = Uri.parse(uri);

    if (bookName.isEmpty) {
      UiHelper.showSnackbar(context, "Enter Book Name");
      return; // ✅ Exit the function if book name is empty
    }

    var data = jsonEncode({"bookName": bookName});

    try {
      var res = await http.post(
        url,
        headers: {"Content-Type": "application/json"}, // ✅ Fixed typo
        body: data,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        var responseData = jsonDecode(res.body);

        if (responseData['bookData'] != null &&
            responseData['bookData'].isNotEmpty) {
          fetchBookBasedOnCategoryData = responseData['bookData'];
          notifyListeners();
        } else {
          UiHelper.showSnackbar(context, "No book found.");
        }
      } else {
        UiHelper.showSnackbar(
            context, "Failed to fetch book: ${res.statusCode}");
      }
    } catch (e) {
      UiHelper.showSnackbar(context, "Error: $e");
    }
  }

  //to increase count for most req book
  Future<void> increaseCountForMostReqBook(context, String bookId,
      String bookName, String bookEdition, String addedBy) async {
    var uri = "${api}api/mostReqBookController";
    var url = Uri.parse(uri);
    var data = jsonEncode({
      "bookId": bookId,
      "bookName": bookName,
      "bookEdition": bookEdition,
      "addedBy": addedBy
    });
    try {
      var res = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        var bookData = jsonDecode(res.body);
        print(bookData["msg"]);
      }
    } catch (e) {
      UiHelper.showSnackbar(context, e.toString());
    }
  }

  //show all req made by student to show it in history tab of librarian

  List<dynamic> allReq = [];
  Future<List<dynamic>>? _futureReq; // Cache future to prevent continuous calls

  Future<List<dynamic>> showAllReq(String addedBy) async {
    if (_futureReq != null) {
      return _futureReq!; // Return cached future if it exists
    }

    var uri = "${api}api/showALLReqController";
    var url = Uri.parse(uri);
    var data = jsonEncode({"addedBy": addedBy});

    _futureReq = http
        .post(
      url,
      headers: {"Content-Type": "application/json"},
      body: data,
    )
        .then((res) {
      if (res.statusCode == 200) {
        final reqData = jsonDecode(res.body);
        allReq = reqData['allReq'];
        notifyListeners();
        return allReq;
      } else if (res.statusCode == 404) {
        allReq = [];
        notifyListeners();
        print("allReq data $allReq");
        return [];
      } else {
        print("Error: ${res.statusCode}, ${res.body}");
        return [];
      }
    }).catchError((e) {
      print("Exception: $e");
      return [];
    });

    return _futureReq!;
  }

  void clearCache() {
    _futureReq = null; // Clear cache if you need to refetch data
  }

  //to show report of most requested book to librarian
  var reportData;
  Future<void> showReport(BuildContext context, String addedBy) async {
    loading();
    var uri = "${api}api/showReportController";
    var url = Uri.parse(uri);
    var data = jsonEncode({"addedBy": addedBy});

    try {
      var res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: data,
      );

      loading();
      if (res.statusCode == 200) {
        var report = jsonDecode(res.body);
        reportData = report["data"];

        if (reportData.isEmpty) {
          UiHelper.showSnackbar(context, "No report data found");
        } else {
          print("Report data: $reportData"); // Debugging
        }
      } else if (res.statusCode == 404) {
        UiHelper.showSnackbar(context, "No reports found");
      } else {
        UiHelper.showSnackbar(context, "Failed to fetch report: ${res.body}");
      }
    } catch (e) {
      UiHelper.showSnackbar(context, "Error: $e");
    }
  }

//to update book details by librarian
  Future<void> updateBookDetails(
      BuildContext context,
      String bookId,
      String bookName,
      String bookCategory,
      int bookCount,
      String bookPublisher,
      String bookEdition,
      int bookPrice,
      int bookPublishedYear) async {
    var data = jsonEncode({
      "bookId": bookId,
      "bookName": bookName,
      "bookCategory": bookCategory,
      "bookCount": bookCount,
      "bookPublisher": bookPublisher,
      "bookEdition": bookEdition,
      "bookPrice": bookPrice,
      "bookPublishedYear": bookPublishedYear
    });
    var uri = "${api}api/bookUpdateController";
    var url = Uri.parse(uri);
    try {
      var res = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        var book = jsonDecode(res.body);
        print(book);
        UiHelper.showSnackbar(context, "Updated successfully");
      } else {
        UiHelper.showSnackbar(context, "msg");
      }
    } catch (e) {
      UiHelper.showSnackbar(context, e.toString());
    }
  }

  //to show librarian report about student and books
  var studentReport;
  Future<void> showStudentLibrarianReport(String addedBy) async {
    var uri = "${api}api/studentBookReportController/";
    var url = Uri.parse(uri);
    var data = jsonEncode({"addedBy": addedBy});
    var res = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: data);
    if (res.statusCode == 200 || res.statusCode == 201) {
      var studentData = jsonDecode(res.body);
      studentReport = studentData;
      print("studenttyttttttttt" + studentData);
      notifyListeners();
    } else {
      print("object...............");
    }
  }

  //to increase book count
  Future<void> increaseBookcountFromBookCollection(String bookId) async {
    var uri = "${api}api/increaseBookCountController";
    var url = Uri.parse(uri);
    var data = jsonEncode({"bookId": bookId});

    print("➡️ Sending request to $url with bookId: $bookId");

    try {
      var res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: data,
      );

      print("📦 Response status: ${res.statusCode}");
      print("📦 Response body: ${res.body}");

      if (res.statusCode == 200 || res.statusCode == 201) {
        print("✅ Book count increased successfully");
      } else {
        print("❌ Failed to increase book count");
      }
    } catch (e) {
      print("🔥 Exception: $e");
    }
  }

  //to mark as returned
  final Set<String> _returnedRequests = {};

  bool isReturned(String id) {
    return _returnedRequests.contains(id);
  }

  void markReturned(String id) {
    _returnedRequests.add(id);
    notifyListeners();
  }

  // optional: for refresh
  void clearReturned() {
    _returnedRequests.clear();
    notifyListeners();
  }

  //reset everything for new login
  void logoutToReset() {
    loggedInUserEmail = null;
    librarianEmail = null;
    loggedUserRole = null;
    fetchBookBasedOnCategoryData = null;
    allCategoryData = null;
    allReqAccptedByStudent = null;
    reportData = null;
    studentReport = null;
    clearReturned();
    setIndex(0);

    notifyListeners();
  }
}
