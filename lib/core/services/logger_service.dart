import 'package:flutter/material.dart';

class LoggerService {
  void log(String message) {
    debugPrint('[LOG] $message');
  }
}
