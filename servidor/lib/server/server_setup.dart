import 'dart:io';

import 'package:servidor/server/client_connection.dart';
import 'package:servidor/server/server_constants.dart';
import 'package:servidor/utils/logger/logger.dart';
import 'package:servidor/utils/logger/types/logger_type.dart';

/// Classe responsável por configurar e iniciar o servidor.
///
/// Esta classe encapsula a lógica necessária para configurar o socket e iniciar o
/// servidor de acordo com as configurações.
class ServerSetup {
  final _logger = Logger();

  /// Inicia o servidor.
  ///
  /// Este método é usado para iniciar o servidor. Ele chama o método privado `_startServer()`
  /// para configurar o socket e aguardar conexões.
  void call() {
    _startServer();
  }

  Future<void> _startServer() async {
    try {
      final ClientConnection clientConnection = ClientConnection();

      _logger(
        message: 'Iniciando servidor...',
        type: LoggerType.info,
      );

      _logger(
        message: 'Configurando o socket...',
        type: LoggerType.info,
      );

      final ServerSocket server = await ServerSocket.bind(
        ServerConfig.serverHost,
        ServerConfig.serverPort,
      );

      _logger(
        message: 'Servidor iniciado com sucesso!',
        type: LoggerType.info,
      );

      _logger(
        message: 'Endereço: ${server.address.host}',
        type: LoggerType.info,
      );

      _logger(
        message: 'Porta: ${server.port}',
        type: LoggerType.info,
      );

      _logger(
        message: 'Aguardando conexões...',
        type: LoggerType.info,
      );

      /// Aguarda novas conexões.
      ///
      /// Este loop aguarda continuamente por novas conexões ao servidor. Quando
      /// uma nova conexão é estabelecida, ele registra o socket remoto e instancia
      /// um novo `ClientConnection` para lidar com a conexão.
      await for (final socket in server) {
        final String remoteAddress = socket.remoteAddress.address;
        final int remotePort = socket.remotePort;

        _logger(
          message: 'Nova conexão recebida: $remoteAddress:$remotePort',
          type: LoggerType.info,
        );

        clientConnection(socket: socket);
      }
    } catch (e) {
      _logger(
        message: 'Ocorreu um erro ao iniciar o servidor: $e',
        type: LoggerType.error,
      );
    }
  }
}
