import 'package:servidor/interfaces/receiver_message_interface.dart';
import 'package:servidor/models/connection_model.dart';

/// Implementação de um manipulador de mensagens de dados que atua como um marcador de posição.
///
/// Esta classe implementa a interface `HandleMessageModel` e serve como um marcador de posição
/// para preencher a lista de manipuladores de mensagens quando nenhum manipulador específico
/// está disponível para o tipo de pacote de dados recebido.
class PlaceholderHandler implements ReceiverMessageInterface {
  @override
  void receiver({required ConnectionModel client, required List<int> data}) {}
}
