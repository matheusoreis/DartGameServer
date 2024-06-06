import 'package:servidor/interfaces/receiver_message_interface.dart';
import 'package:servidor/models/connection_model.dart';

class PlaceholderReceiverMessage implements ReceiverMessageInterface {
  @override
  void receiver({required ConnectionModel client, required List<int> data}) {}
}
