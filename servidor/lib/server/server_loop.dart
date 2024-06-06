import 'package:servidor/server/server_globals.dart';

class ServerLoop {
  static Future<void> start() async {
    while (ServerGlobals.serverOpen) {
      final tick = DateTime.now().millisecondsSinceEpoch;

      print(tick);

      await Future.delayed(const Duration(milliseconds: 1));
    }
  }
}
