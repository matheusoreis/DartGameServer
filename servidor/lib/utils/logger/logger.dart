import 'dart:io';
import 'package:ansicolor/ansicolor.dart';
import 'package:servidor/utils/logger/types/logger_type.dart';

/// Classe responsável por registrar mensagens de log.
///
/// Esta classe fornece métodos para registrar mensagens de log com diferentes níveis de gravidade,
/// como informações, avisos, erros e mensagens específicas de jogadores.
class Logger {
  final AnsiPen _pen = AnsiPen();

  /// Registra uma mensagem de log com o nível de gravidade especificado.
  ///
  /// Parâmetros:
  ///   - message: A mensagem a ser registrada.
  ///   - type: O tipo de mensagem de log (info, warning, error, player).
  void call({required String message, required LoggerType type}) {
    _log(message: message, type: type);
  }

  /// Registra uma mensagem de log com o nível de gravidade especificado.
  ///
  /// Parâmetros:
  ///   - message: A mensagem a ser registrada.
  ///   - type: O tipo de mensagem de log (info, warning, error, player).
  void _log({required String message, required LoggerType type}) {
    late String prefix;

    switch (type) {
      case LoggerType.info:
        _pen
          ..white()
          ..xterm(10);

        prefix = '[INFO]';
      case LoggerType.warning:
        _pen
          ..white()
          ..xterm(3);

        prefix = '[WARNING]';
      case LoggerType.error:
        _pen
          ..white()
          ..xterm(9);

        prefix = '[ERROR]';
      case LoggerType.player:
        _pen
          ..white()
          ..xterm(14);

        prefix = '[PLAYER]';
    }

    stdout.writeln('${_pen(prefix)} ${_pen(message)}');
  }
}
