import 'dart:io';
import 'dart:typed_data';

import '../models/connection_model.dart';
import '../network/packet_buffer.dart';
import '../network/receivers/data_receiver.dart';
import '../network/ring_buffer.dart';
import 'server_memory.dart';
import '../utils/logger_utils.dart';

class ClientConnection {
  void handleNewClient(Socket socket) {
    final int? index = ServerMemory().clientConnections.getFirstEmptySlot();

    if (index == null) {
      _handleFullServer(socket);
    } else {
      _handleNewConnection(index: index, socket: socket);
    }
  }

  Future<void> _handleFullServer(Socket socket) async {
    LoggerUtils.log(
      message: 'Número máximo de conexões alcançado',
      type: LoggerTypes.warning,
    );

    // TODO: Implementar resposta para o cliente

    await socket.flush();
    await socket.close();

    LoggerUtils.log(
      message: 'Conexão com o socket ${socket.address} fechada',
      type: LoggerTypes.warning,
    );
  }

  void _handleNewConnection({required int index, required Socket socket}) {
    final ServerMemory serverMemory = ServerMemory();

    final ConnectionModel client = ConnectionModel(
      id: index,
      socket: socket,
    );

    serverMemory.clientConnections.add(client);

    connectedClient(client);
  }

  void connectedClient(ConnectionModel client) {
    final DataReceiver dataReceiver = DataReceiver();
    final PacketBuffer packetBuffer = PacketBuffer();
    final RingBuffer ringBuffer = RingBuffer(1024);

    int packetSize = -1;

    client.socket.listen(
      (List<int> data) {
        final ByteReader reader = packetBuffer.reader;
        final ByteWriter writer = packetBuffer.writer;

        try {
          data.forEach(ringBuffer.add);
        } catch (e) {
          disconnectClient(client);
          return;
        }

        if (packetSize == -1 && ringBuffer.length >= 4) {
          final Uint8List sizeBytes = ringBuffer.take(4);

          writer.putBytes(sizeBytes);

          packetSize = reader.get32();
        }

        if (packetSize != -1 && ringBuffer.length >= packetSize) {
          final Uint8List packet = ringBuffer.take(
            packetSize,
          );

          dataReceiver.receiverData(
            client: client,
            data: packet,
          );

          packetSize = -1;
        }
      },
      onDone: () {
        disconnectClient(client);
      },
      onError: (Object error) {
        disconnectClient(client);
      },
    );
  }

  static void disconnectClient(ConnectionModel client) {
    LoggerUtils.log(
      message: 'Conexão com o jogador ${client.id} fechada',
      type: LoggerTypes.player,
    );

    ServerMemory().clientConnections.remove(client.id);

    client.socket.close();
  }
}
