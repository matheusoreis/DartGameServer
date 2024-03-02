/// Classe responsável por armazenar as configurações do servidor.
///
/// Esta classe fornece constantes para configurar diversos aspectos do servidor,
/// como o nome do servidor, o número máximo de jogadores suportados, o host entre outros.
class ServerConfig {
  /// Nome do servidor.
  static const String serverName = 'Phoenix Game Server';

  /// Número máximo de jogadores suportados.
  static const int maxPlayers = 2;

  /// Host do servidor.
  static const String serverHost = '127.0.0.1';

  /// Porta do servidor.
  static const int serverPort = 8090;
}
