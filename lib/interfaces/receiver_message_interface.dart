import '../models/connection_model.dart';

abstract class ReceiverMessageInterface {
  void receiver({
    required ConnectionModel client,
    required List<int> data,
  });
}
