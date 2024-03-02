import 'package:servidor/models/connection_model.dart';

/// Modelo de dados de uma mensagem para troca de dados entre o cliente e o servidor.
abstract interface class ReceiverMessageInterface {
  /// Método para tratar a mensagem.
  void receiver({
    required ConnectionModel client,
    required List<int> data,
  });
}
