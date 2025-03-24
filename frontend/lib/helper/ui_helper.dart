import 'package:flutter/material.dart';

class UiHelper {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).clearSnackBars(); // Clear existing snackbars
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: const Color(0xFF558F97).withOpacity(0.9), // Better visibility
        behavior: SnackBarBehavior.floating,  // Floating for modern UI
        duration: const Duration(seconds: 3), // Visible for 3 seconds
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Add margin
      ),
    );
  }
}
