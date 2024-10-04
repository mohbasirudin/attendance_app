import 'package:flutter/material.dart';

class CError extends StatelessWidget {
  final String? message;
  final Function()? onReload;
  const CError({
    super.key,
    this.message,
    this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message ?? ''),
          TextButton(
            onPressed: onReload,
            child: const Text('Reload'),
          ),
        ],
      ),
    );
  }
}
