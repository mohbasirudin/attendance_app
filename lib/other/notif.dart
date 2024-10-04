import 'package:attendanceapp/base/colors.dart';
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
      backgroundColor: isSuccess ? BaseColors.success : BaseColors.error,
    ),
  );
}
