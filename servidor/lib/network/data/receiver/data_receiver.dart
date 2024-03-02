import 'package:servidor/interfaces/receiver_message_interface.dart';
import 'package:servidor/models/connection_model.dart';
import 'package:servidor/network/data/packets/client_packets.dart';
import 'package:servidor/network/data/receiver/messages/placeholder_handle.dart';
import 'package:servidor/network/server_buffer.dart';
import 'package:servidor/server/client_connection.dart';
import 'package:servidor/utils/logger/logger.dart';
import 'package:servidor/utils/logger/types/logger_type.dart';

/// Classe responsável por receber e processar dados enviados pelos clientes.
///
/// Esta classe gerencia a recepção de dados dos clientes, identifica o tipo de mensagem recebida
/// e encaminha a mensagem para o manipulador apropriado para processamento.
class DataReceiver {
  /// Construtor da classe `DataReceiver`.
  ///
  /// Inicializa as mensagens de tratamento de acordo com os tipos de pacotes definidos.
  DataReceiver() {
    _receiverDataMessage = List.filled(
      ClientPackets.values.length,
      PlaceholderHandler(),
    );

    _initMessages();
  }

  late List<ReceiverMessageInterface> _receiverDataMessage;

  /// Retorna a lista de manipuladores de mensagens de dados.
  ///
  /// Este getter fornece acesso à lista de manipuladores de mensagens de dados.
  List<ReceiverMessageInterface> get receiverDataMessage => _receiverDataMessage;

  final ServerBuffer _buffer = ServerBuffer();
  final Logger _logger = Logger();

  /// Inicializa as mensagens de tratamento de acordo com os tipos de pacotes definidos.
  void _initMessages() {
    _receiverDataMessage[ClientPackets.empty.index] = PlaceholderHandler();
  }

  /// Recebe e processa os dados enviados pelo cliente.
  ///
  /// Este método recebe dados de um cliente e os processa de acordo com o tipo de mensagem.
  /// Ele identifica o tipo de mensagem, verifica se está dentro do intervalo válido e encaminha
  /// a mensagem para o manipulador apropriado para processamento.
  ///
  /// Parâmetros:
  ///   - client: O modelo de conexão do cliente.
  ///   - data: Os dados recebidos do cliente.
  void receiverData({
    required ConnectionModel client,
    required List<int> data,
  }) {
    if (data.length < 4) return;

    _buffer
      ..writeBytes(data)
      ..readInteger();

    final int msgType = _buffer.readInteger();

    try {
      if (msgType < 0 || msgType >= ClientPackets.values.length) {
        _logger(
          message: 'msgType fora do intervalo válido: $msgType',
          type: LoggerType.error,
        );
      }

      _receiverDataMessage[msgType].receiver(
        client: client,
        data: _buffer.readBytes(
          length: _buffer.length,
        ),
      );
    } catch (e) {
      _logger(
        message: 'Erro: $e. Fechando a conexão com o cliente.',
        type: LoggerType.error,
      );

      ClientConnection.disconnectClient(client);
    }
  }
}
