// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:libpro/consts.dart';
import 'package:libpro/pages/common/authentication/login_screen.dart';
import 'package:libpro/pages/common/home_screen.dart';

class AppController extends ChangeNotifier {
  var loggedInUserEmail;
  var loggedUserRole;
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
      return print("Enter Credentials");
    }
    String loginApi = "${api}api/login";
    var url = Uri.parse(loginApi);
    try {
      var data = jsonEncode({"email": email, "password": password});
      var res = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        var userData = jsonDecode(res.body);
        loggedUserRole = userData["user"]["role"];
        return Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
      if (res.statusCode != 200 || res.statusCode != 201) {
        return print(res.statusCode);
      }
    } catch (e) {
      return print("error occurred: $e");
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
}
