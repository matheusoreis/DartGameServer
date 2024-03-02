import 'dart:io';

import 'package:servidor/server/server_memory.dart';

/// modelos de dados de conexão do cliente.
///
/// Este modelo representa uma instância de cliente de rede.
interface class ConnectionModel {
  /// Cria uma nova instância de `ClientConnectionModel` com os dados do cliente.
  ConnectionModel({required this.id, required this.socket});

  /// Identificador do cliente.
  final int id;

  /// Socket do cliente.
  final Socket socket;

  /// Verifica se um determinado índice de slot está atualmente conectado.
  ///
  /// Este método retorna verdadeiro se o slot especificado estiver ocupado por um cliente conectado,
  /// caso contrário, retorna falso.
  ///
  /// Retorna verdadeiro se o slot estiver ocupado, falso caso contrário.
  bool isConnected() {
    return !ServerMemory().clientConnections.isSlotEmpty(id);
  }
}
