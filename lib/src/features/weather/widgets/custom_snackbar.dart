import 'package:flutter/material.dart';

class CustomSnackBar {
  static void show(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.red,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.zero, 
          duration: duration,
          content: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      );
  }
}