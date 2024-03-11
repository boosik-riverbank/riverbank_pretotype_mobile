import 'package:logger/logger.dart';

final logger = Logger();

class AppLogger {
  static d(String tag, String message) {
    logger.d('[$tag] $message');
  }

  static i(String tag, String message) {
    logger.i('[$tag] $message');
  }

  static e(String tag, String message) {
    logger.e('[$tag] $message');
  }
}