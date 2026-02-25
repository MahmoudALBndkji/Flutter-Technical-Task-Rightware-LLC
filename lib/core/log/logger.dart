import 'package:flutter/foundation.dart' show kDebugMode;
import 'dart:developer' as developer;

class Logger {
  static const _reset = '\x1B[0m';
  static const _red = '\x1B[31m';
  static const _yellow = '\x1B[33m';
  static const _green = '\x1B[32m';
  static const _blue = '\x1B[34m';

  static void log(String message, {String tag = 'MyApp-Log'}) {
    if (kDebugMode) {
      developer.log('$_blue[$tag] $message$_reset');
    }
  }

  static void error(String message, {String tag = 'MyApp-Error'}) {
    if (kDebugMode) {
      developer.log('$_red[$tag] $message$_reset');
    }
  }

  static void warning(String message, {String tag = 'MyApp-Warning'}) {
    if (kDebugMode) {
      developer.log('$_yellow[$tag] $message$_reset');
    }
  }

  static void info(String message, {String tag = 'MyApp-Info'}) {
    if (kDebugMode) {
      developer.log('$_green[$tag] $message$_reset');
    }
  }
}
