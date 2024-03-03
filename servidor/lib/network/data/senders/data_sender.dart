import 'package:servidor/models/connection_model.dart';
import 'package:servidor/network/server_buffer.dart';
import 'package:servidor/server/server_memory.dart';
import 'package:servidor/utils/logger/logger.dart';
import 'package:servidor/utils/logger/types/logger_type.dart';

/// Classe responsável por enviar dados para clientes conectados.
///
/// Esta classe fornece métodos para enviar dados para clientes conectados
/// por meio de uma conexão de socket.
class DataSender {
  final _logger = Logger();

  /// Envia dados para um cliente específico.
  ///
  /// Este método envia os dados fornecidos para um cliente específico. Ele
  /// prepara os dados, adicionando o tamanho dos dados e os envia para o
  /// cliente por meio da socket.
  void sendDataTo({
    required ConnectionModel client,
    required List<int> data,
  }) {
    final buffer = ServerBuffer();

    try {
      buffer
        ..writeInteger(data.length)
        ..writeBytes(data);

      client.socket.add(buffer.getArray());
    } catch (e) {
      _logger(
        message: 'Erro ao enviar dados para o cliente ${client.id}: $e',
        type: LoggerType.error,
      );
    }
  }

  /// Envia dados para todos os clientes conectados.
  ///
  /// Este método envia os dados fornecidos para todos os clientes conectados
  /// ao servidor. Ele obtém a lista de slots preenchidos do gerenciador de
  /// memória do servidor e, para cada slot preenchido, envia os dados para
  /// o cliente associado.
  void sendDataToAll({
    required List<int> data,
  }) {
    final Iterable<int> filledSlots = ServerMemory().clientConnections.getFilledSlots();

    for (final i in filledSlots) {
      final slots = ServerMemory().clientConnections[i];

      if (slots?.isConnected() ?? false) {
        if (slots != null) {
          sendDataTo(client: slots, data: data);
        }
      }
    }
  }

  /// Envia dados para todos os clientes conectados, exceto um cliente
  /// específico.
  ///
  /// Este método envia os dados fornecidos para todos os clientes conectados
  /// ao servidor, exceto para um cliente específico. Ele obtém a lista de slots
  /// preenchidos do gerenciador de memória do servidor e, para cada slot
  /// preenchido, envia os dados para o cliente associado, desde que o cliente
  /// não seja o cliente especificado.
  void sendDataToAllBut({
    required ConnectionModel client,
    required List<int> data,
  }) {
    final filledSlots = ServerMemory().clientConnections.getFilledSlots();

    for (final i in filledSlots) {
      final slots = ServerMemory().clientConnections[i];

      if (slots?.isConnected() ?? false) {
        if (slots != null && slots.id != client.id) {
          sendDataTo(client: slots, data: data);
        }
      }
    }
  }
}
