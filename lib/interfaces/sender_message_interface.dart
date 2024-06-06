import 'package:servidor/models/connection_model.dart';

abstract class SenderMessageInterface<T> {
  void send({
    required ConnectionModel client,
    required T data,
  });
}
