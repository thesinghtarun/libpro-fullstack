import 'package:flutter/material.dart';

class UiHelper {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();

    final snackBar = SnackBar(
      content: Text(
        msg,
        style: const TextStyle(
          color: Colors.white, 
          fontSize: 16, 
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: Colors.black87,
      behavior: SnackBarBehavior.fixed, 
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4), 
      ), 
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
