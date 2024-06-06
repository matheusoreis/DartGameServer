import 'dart:io';

import 'package:servidor/server/client_connection.dart';
import 'package:servidor/server/server_constants.dart';
import 'package:servidor/utils/logger_utils.dart';

class ServerSetup {
  Future<void> startServer() async {
    try {
      final ClientConnection clientConnection = ClientConnection();

      LoggerUtils.log(
        message: 'Iniciando servidor...',
        type: LoggerTypes.info,
      );

      LoggerUtils.log(
        message: 'Configurando o socket...',
        type: LoggerTypes.info,
      );

      final ServerSocket server = await ServerSocket.bind(
        ServerConstants.serverHost,
        ServerConstants.serverPort,
      );

      LoggerUtils.log(
        message: 'Servidor iniciado com sucesso!',
        type: LoggerTypes.info,
      );

      LoggerUtils.log(
        message: 'Endereço: ${server.address.host}',
        type: LoggerTypes.info,
      );

      LoggerUtils.log(
        message: 'Porta: ${server.port}',
        type: LoggerTypes.info,
      );

      LoggerUtils.log(
        message: 'Aguardando conexões...',
        type: LoggerTypes.info,
      );

      await for (final Socket socket in server) {
        final String remoteAddress = socket.remoteAddress.address;
        final int remotePort = socket.remotePort;

        LoggerUtils.log(
          message: 'Nova conexão recebida: $remoteAddress:$remotePort',
          type: LoggerTypes.info,
        );

        clientConnection.handleNewClient(socket);
      }
    } catch (e) {
      LoggerUtils.log(
        message: 'Ocorreu um erro ao iniciar o servidor: $e',
        type: LoggerTypes.error,
      );
    }
  }
}
