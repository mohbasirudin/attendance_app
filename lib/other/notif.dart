import 'package:flutter/material.dart';

void snackbar(
  BuildContext context, {
  bool isSuccess = true,
  String? message,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message ?? "failed"),
      duration: const Duration(seconds: 1),
      backgroundColor: isSuccess ? Colors.green : Colors.red,
    ),
  );
}
