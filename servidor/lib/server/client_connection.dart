import 'dart:io';

import 'package:servidor/models/connection_model.dart';
import 'package:servidor/network/data/receiver/data_receiver.dart';
import 'package:servidor/server/server_memory.dart';
import 'package:servidor/utils/logger/logger.dart';
import 'package:servidor/utils/logger/types/logger_type.dart';

/// Classe responsável por gerenciar conexões dos clientes.
///
/// Esta classe gerencia a lógica para lidar com novos clientes que se
/// conectam ao servidor.
class ClientConnection {
  final _logger = Logger();

  /// Chama o método `_handleNewClient()` para lidar com uma nova conexão de cliente.
  ///
  /// Este método é chamado quando uma nova conexão de cliente é estabelecida com o servidor.
  /// Ele delega o tratamento da nova conexão ao método privado `_handleNewClient()`.
  ///
  /// Parâmetros:
  ///   - socket: O objeto Socket representando a nova conexão de cliente.
  void call({required Socket socket}) {
    _handleNewClient(socket);
  }

  /// Lida com uma nova conexão de cliente.
  ///
  /// Este método é chamado quando uma nova conexão de cliente é estabelecida com o servidor.
  /// Ele verifica se há slots disponíveis para conexões de clientes no servidor.
  ///
  /// Se todos os slots estiverem ocupados, a nova conexão será rejeitada e o método
  /// `_handleFullServer()` será chamado para lidar com a situação de servidor cheio.
  ///
  /// Se houver um slot disponível, a nova conexão será aceita e o método `_handleNewConnection()`
  /// será chamado para tratar a conexão e atribuir um índice para o cliente.
  ///
  /// Parâmetros:
  ///   - socket: O objeto Socket representando a nova conexão de cliente.
  void _handleNewClient(Socket socket) {
    final int? index = ServerMemory().clientConnections.getFirstEmptySlot();

    if (index == null) {
      _handleFullServer(socket);
    } else {
      _handleNewConnection(index: index, socket: socket);
    }
  }

  /// Lida com a situação de servidor cheio.
  ///
  /// Este método é chamado quando o servidor atinge o número máximo de conexões permitidas.
  /// Ele envia um alerta ao cliente indicando que o servidor está cheio e encerra a conexão com
  /// o cliente.
  ///
  /// Parâmetros:
  ///   - socket: O objeto Socket representando a conexão com o cliente.
  ///
  /// Retorna uma Future que completa quando a conexão é encerrada.
  Future<void> _handleFullServer(Socket socket) async {
    _logger(
      message: 'Número máximo de conexões alcançado',
      type: LoggerType.warning,
    );

    /// Limpa o buffer e encerra a conexão
    await socket.flush();
    await socket.close();

    _logger(
      message: 'Conexão com o socket ${socket.address} fechada',
      type: LoggerType.warning,
    );
  }

  /// Lida com uma nova conexão estabelecida com sucesso.
  ///
  /// Este método é chamado quando uma nova conexão de cliente é estabelecida com sucesso no servidor.
  /// Ele atribui um índice único para o cliente, adiciona o cliente à lista de conexões do servidor
  /// e inicia o gerenciamento da conexão do cliente.
  ///
  /// Parâmetros:
  ///   - index: O índice único atribuído ao cliente.
  ///   - socket: O objeto Socket representando a conexão com o cliente.
  void _handleNewConnection({required int index, required Socket socket}) {
    /// Cria uma instância de ClientHandler associada ao cliente especificado.
    final ConnectionModel client = ConnectionModel(
      id: index,
      socket: socket,
    );

    final ServerMemory serverMemory = ServerMemory();

    /// Adiciona o cliente à lista de clientes conectados no servidor.
    serverMemory.clientConnections.add(client);

    /// Inicia o gerenciamento da conexão do cliente.
    connectedClient(client);
  }

  /// Inicia o gerenciamento da conexão do cliente.
  ///
  /// Este método configura o tratamento de dados recebidos do cliente e ações a serem tomadas
  /// quando ocorrem eventos como erros ou desconexões.
  ///
  /// Parâmetros:
  ///   - client: O modelo de conexão do cliente.
  void connectedClient(ConnectionModel client) {
    final Logger logger = Logger();
    final DataReceiver dataHandler = DataReceiver();

    client.socket.listen(
      (data) {
        dataHandler.receiverData(client: client, data: data);
      },
      onError: (dynamic error) {
        logger(
          message: 'Ocorreu um erro: $error',
          type: LoggerType.error,
        );

        disconnectClient(client);
      },
      onDone: () {
        disconnectClient(client);
      },
    );
  }

  /// Desconecta o cliente do servidor.
  ///
  /// Este método é chamado para finalizar a conexão com o cliente.
  ///
  /// Parâmetros:
  ///   - client: O modelo de conexão do cliente.
  static void disconnectClient(ConnectionModel client) {
    final Logger logger = Logger();

    logger(
      message: 'Conexão com o jogador ${client.id} fechada',
      type: LoggerType.player,
    );

    ServerMemory().clientConnections.remove(client.id);

    client.socket.close();
  }
}
