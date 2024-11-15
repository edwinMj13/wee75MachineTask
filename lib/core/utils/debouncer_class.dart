import 'dart:async';

import 'package:flutter/widgets.dart';

class Debouncer {
  final int milliseconds;
  Timer? timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
    timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
