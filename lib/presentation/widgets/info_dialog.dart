import 'package:flutter/material.dart';

Future<T?> showInfoDialog<T>(BuildContext context, String infoText) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Info'),
          content: Text(infoText),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: const Text('OK'))
          ],
        );
      });
}
