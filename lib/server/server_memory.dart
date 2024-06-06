import '../models/connection_model.dart';
import 'server_constants.dart';
import 'slot_manager.dart';

class ServerMemory {
  factory ServerMemory() {
    return _singletonInstance;
  }

  ServerMemory._();
  static final ServerMemory _singletonInstance = ServerMemory._();

  SlotManager<ConnectionModel> clientConnections = SlotManager(ServerConstants.maxPlayers);
}
