import 'package:flutter/material.dart';

class CommonUtils {
  static showSnackBar(context, String message) {
    ScaffoldMessenger.of(context as BuildContext)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
