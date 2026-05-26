import 'package:flutter/material.dart';

/// Shows a toast-like SnackBar that floats above the bottom navigation bar.
void showToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Semantics(
        label: message,
        child: Text(message),
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: kBottomNavigationBarHeight + 32,
        left: 16,
        right: 16,
      ),
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
