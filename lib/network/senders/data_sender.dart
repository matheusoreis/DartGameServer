import 'package:servidor/models/connection_model.dart';
import 'package:servidor/network/packet_buffer.dart';
import 'package:servidor/server/server_memory.dart';
import 'package:servidor/utils/logger_utils.dart';

class DataSender {
  Future<void> sendDataTo({
    required ConnectionModel client,
    required List<int> data,
  }) async {
    final PacketBuffer packetBuffer = PacketBuffer();

    final ByteWriter writer = packetBuffer.writer;

    try {
      writer
        ..put32(data.length)
        ..putBytes(data);

      client.socket.add(packetBuffer.bufferArray);
    } catch (e) {
      LoggerUtils.log(
        message: 'Erro ao enviar dados para o cliente ${client.id}: $e',
        type: LoggerTypes.error,
      );
    }
  }

  void sendDataToAll(
    List<int> data,
  ) {
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

  void sendDataToAllExcept({
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
