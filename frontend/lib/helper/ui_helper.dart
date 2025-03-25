import 'package:flutter/material.dart';

class UiHelper {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final snackBar = SnackBar(
      content: Text(
        msg,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      backgroundColor: const Color(0xFF558F97).withOpacity(0.9),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(
        right: 20,
        bottom: 20,
        left: MediaQuery.of(context).size.width * 0.5,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
