import 'package:flutter/material.dart';
import 'package:project_blueprint/presentation/components/loading.dart';

Future<T?> showLoadingDialog<T>(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Wrap(
            alignment: WrapAlignment.center,
            children: const [LoadingWidget()],
          ),
        );
      });
}
