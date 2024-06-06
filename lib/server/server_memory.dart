import 'package:servidor/models/connection_model.dart';
import 'package:servidor/server/server_constants.dart';
import 'package:servidor/server/slot_manager.dart';

class ServerMemory {
  factory ServerMemory() {
    return _singletonInstance;
  }

  ServerMemory._();
  static final ServerMemory _singletonInstance = ServerMemory._();

  SlotManager<ConnectionModel> clientConnections = SlotManager(ServerConstants.maxPlayers);
}
