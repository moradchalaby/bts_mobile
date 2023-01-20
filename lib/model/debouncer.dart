import 'dart:async';

import 'package:flutter/cupertino.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback action;

  Debouncer({required this.milliseconds, required this.action});

  run(VoidCallback action) {
    Timer timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class DebouncerMain {
  final int seconds;
  VoidCallback action;

  DebouncerMain({required this.seconds, required this.action});

  run(VoidCallback action) {
    Timer timer = Timer(Duration(seconds: seconds), action);
  }
}

class AdaptiveTextSize {
  const AdaptiveTextSize();

  getadaptiveTextSize(dynamic value) {
    // 720 is medium screen height
    return (value / 720);
  }
}
