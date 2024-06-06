import 'package:servidor/interfaces/receiver_message_interface.dart';
import 'package:servidor/models/connection_model.dart';
import 'package:servidor/network/packet_buffer.dart';
import 'package:servidor/network/packets/client_packets.dart';
import 'package:servidor/network/receivers/messages/placeholder_message.dart';
import 'package:servidor/server/client_connection.dart';
import 'package:servidor/utils/logger_utils.dart';

class DataReceiver {
  DataReceiver() {
    _receiverDataMessage = List.filled(
      ClientPackets.values.length,
      PlaceholderReceiverMessage(),
    );

    _processMessages();
  }

  late List<ReceiverMessageInterface> _receiverDataMessage;

  void _processMessages() {
    _receiverDataMessage[ClientPackets.empty.index] = PlaceholderReceiverMessage();
  }

  void receiverData({
    required ConnectionModel client,
    required List<int> data,
  }) {
    final PacketBuffer buffer = PacketBuffer();
    final ByteReader reader = buffer.reader;
    final ByteWriter writer = buffer.writer;

    if (data.length < 4) {
      LoggerUtils.log(
        message: 'O pacote recebido é menor que 4 bytes. Fechando a conexão com o cliente.',
        type: LoggerTypes.error,
      );

      ClientConnection.disconnectClient(client);
    }

    writer.putBytes(data);

    final int msgType = reader.get32();

    try {
      if (msgType < 0 || msgType >= ClientPackets.values.length) {
        LoggerUtils.log(
          message: 'msgType fora do intervalo válido: $msgType',
          type: LoggerTypes.error,
        );

        ClientConnection.disconnectClient(client);
      } else {
        _receiverDataMessage[msgType].receiver(
          client: client,
          data: reader.getBytes(length: buffer.length),
        );
      }
    } catch (e) {
      LoggerUtils.log(
        message: 'Erro: $e. Fechando a conexão com o cliente.',
        type: LoggerTypes.error,
      );

      ClientConnection.disconnectClient(client);
    }
  }
}
