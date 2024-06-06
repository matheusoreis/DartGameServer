import 'dart:io';
import 'package:ansicolor/ansicolor.dart';

enum LoggerTypes {
  info,
  warning,
  error,
  player,
}

class LoggerUtils {
  static void log({required String message, required LoggerTypes type}) {
    final AnsiPen pen = AnsiPen();

    late String prefix;

    switch (type) {
      case LoggerTypes.info:
        pen
          ..white()
          ..xterm(10);
        prefix = '[INFO]';
      case LoggerTypes.warning:
        pen
          ..white()
          ..xterm(3);
        prefix = '[WARNING]';
      case LoggerTypes.error:
        pen
          ..white()
          ..xterm(9);
        prefix = '[ERROR]';
      case LoggerTypes.player:
        pen
          ..white()
          ..xterm(14);
        prefix = '[PLAYER]';
    }

    stdout.writeln('${pen(prefix)} ${pen(message)}');
  }
}
