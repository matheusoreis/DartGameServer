import 'package:servidor/models/connection_model.dart';
import 'package:servidor/server/server_constants.dart';
import 'package:servidor/server/slot_manager.dart';

/// Classe responsável por armazenar e gerenciar informações relacionadas ao servidor.
///
/// Esta classe fornece funcionalidades para acessar e manipular informações relacionados à memória
/// temporária do servidor.
///
/// Ela é implementada como um Singleton, garantindo que haja apenas uma instância da classe
/// em toda a aplicação. Isso permite o compartilhamento global de recursos e informações
/// relacionadas a memória temporária do servidor.
class ServerMemory {
  /// Construtor de fábrica para criar instâncias da classe `ServerMemory`.
  factory ServerMemory() {
    return _singletonInstance;
  }

  ServerMemory._();

  static final ServerMemory _singletonInstance = ServerMemory._();

  /// Gerenciador de slots para as conexões dos clientes.
  SlotManager<ConnectionModel> clientConnections = SlotManager(
    ServerConfig.maxPlayers,
  );
}
