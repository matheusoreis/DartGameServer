/// Enumeração que define os tipos de pacotes de dados enviados pelo servidor.
///
/// Esta enumeração lista os diferentes tipos de pacotes de dados que podem ser enviados
/// pelo servidor para o cliente.
enum ServerPackets {
  /// Packet vazia.
  empty,
}

/// Extensão para fornecer funcionalidades adicionais ao enum `ServerPackets`.
///
/// Esta extensão permite acessar propriedades adicionais e métodos úteis
/// relacionados à enumeração `ServerPackets`.
extension ServerPacketsExtension on ServerPackets {
  /// Retorna o número total de tipos de pacotes de dados definidos neste enum.
  static int get count => ServerPackets.values.length;
}
