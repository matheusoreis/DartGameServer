/// Enumeração que define os tipos de pacotes de dados enviados pelo cliente.
///
/// Esta enumeração lista os diferentes tipos de pacotes de dados que podem ser enviados
/// pelo cliente para o servidor.
enum ClientPackets {
  /// Packet vazia.
  empty,
}

/// Extensão para fornecer funcionalidades adicionais ao enum `ClientPackets`.
///
/// Esta extensão permite acessar propriedades adicionais e métodos úteis
/// relacionados à enumeração `ClientPackets`.
extension ClientPacketsExtension on ClientPackets {
  /// Retorna o número total de tipos de pacotes de dados definidos neste enum.
  static int get count => ClientPackets.values.length;
}
