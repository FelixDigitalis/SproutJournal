import 'package:logger/logger.dart';

class Log {
  static final Log _singleton = Log._internal();

  late Logger _logger;

  factory Log() {
    return _singleton;
  }

  Log._internal() {
    _logger = Logger(
      printer: PrettyPrinter(),
    );
  }

  void i(String message) {
    _logger.i(message);
  }

  void w(String message) {
    _logger.w(message);
  }

  void e(String message) {
    _logger.e(message);
  }

  void d(String message) {
    _logger.d(message);
  }

  void t(String message) {
    _logger.t(message);
  }
}
