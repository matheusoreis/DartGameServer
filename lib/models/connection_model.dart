import 'dart:io';

import 'user_model.dart';
import '../server/server_memory.dart';

interface class ConnectionModel {
  ConnectionModel({
    required this.id,
    required this.socket,
    this.user,
  });

  final int id;
  final Socket socket;
  String? token;
  UserModel? user;

  bool isConnected() {
    return !ServerMemory().clientConnections.isSlotEmpty(id);
  }

  void update({
    String? token,
    UserModel? user,
  }) {
    this.token = token ?? this.token;
    this.user = user ?? this.user;

    ServerMemory().clientConnections.update(id, this);
  }

  ConnectionModel copyWith({
    int? id,
    Socket? socket,
    String? token,
    UserModel? user,
  }) {
    return ConnectionModel(
      id: id ?? this.id,
      socket: socket ?? this.socket,
      user: user ?? this.user,
    );
  }
}
