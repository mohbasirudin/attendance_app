import 'package:flutter/material.dart';

class CLoading extends StatelessWidget {
  const CLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
