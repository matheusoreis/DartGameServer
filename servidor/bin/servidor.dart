import 'package:servidor/server/server_setup.dart';
import 'package:servidor/servidor.dart';

void main(List<String> arguments) {
  final ServerSetup serverSetup = ServerSetup();

  /// Inicia o servidor;
  ///
  /// Ao iniciar o programa o servidor será iniciado chamando o método `_startServer` atráves
  /// do callable object `serverSetup`.;
  serverSetup();
}
