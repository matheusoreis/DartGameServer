import 'dart:isolate';
import 'package:servidor/server/server_globals.dart';

class ServerLoop {
  static Future<void> start() async {
    await Isolate.spawn(_loop, null);
  }

  static void _loop(_) {
    while (ServerGlobals.serverOpen) {
      final tick = DateTime.now().millisecondsSinceEpoch;

      print(tick);

      Future.delayed(const Duration(milliseconds: 1));
    }
  }
}
