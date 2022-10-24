import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:takk/config/constants/app_text_styles.dart';

import '../pages/auth/view/auth_page.dart';

Future<T?> showSignInDialog<T>(BuildContext context) {
  if (Platform.isIOS || Platform.isMacOS) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Sorry'),
        content: const Text('You have to sign in to access more options'),
        actions: [
          CupertinoButton(
              child: Text(
                'Cancel',
                style: AppTextStyles.body15w5,
              ),
              onPressed: () => Navigator.pop(context)),
          CupertinoButton(
            child: Text('Sign in', style: AppTextStyles.body15w5),
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => AuthPage(),
                ),
                (r) => false),
          )
        ],
      ),
    );
  } else {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sorry'),
        content: const Text('You have to sign in to access more options'),
        actions: [
          TextButton(
              child: Text(
                'Cancel',
                style: AppTextStyles.body15w5,
              ),
              onPressed: () => Navigator.pop(context)),
          TextButton(
            child: Text(
              'Sign in',
              style: AppTextStyles.body15w5,
            ),
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => AuthPage(),
                ),
                (r) => false),
          )
        ],
      ),
    );
  }
}
