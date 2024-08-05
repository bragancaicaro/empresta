import 'package:flutter/material.dart';

class CustomSnackbar {
  static void showWithAction(BuildContext context, String text, Color backgroundColor, SnackBarAction? action) {
    final snackbar = SnackBar(
      content: Text(
        text,
        style: const TextStyle(fontSize:16, color: Colors.white),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.fixed,
      action: action,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
  static void show(BuildContext context, String text, Color backgroundColor) {
    final snackbar = SnackBar(
      content: Text(
        text,
        style: const TextStyle(fontSize:16, color: Colors.white),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.fixed,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}