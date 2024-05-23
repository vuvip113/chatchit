import 'package:flutter/material.dart';
import 'package:chatchit/ui/common/app_colors.dart';

class Dialogs {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(msg),
          backgroundColor: orangeNormal,
          behavior: SnackBarBehavior.floating),
    );
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          color: orangeNormal,
          strokeWidth: 1,
        ),
      ),
    );
  }
}
