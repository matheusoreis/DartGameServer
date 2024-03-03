// ignore_for_file: directives_ordering

import 'package:pocketbase/pocketbase.dart';
import 'package:servidor/utils/logger/logger.dart';
import 'package:servidor/utils/logger/types/logger_type.dart';
import 'package:servidor/utils/result.dart';

/// Classe responsável por lidar com a autenticação de usuários.
///
/// Esta classe fornece métodos para realizar operações de autenticação,
/// como login (signIn) e registro (signUp).
class AuthRepository {
  final PocketBase _pb = PocketBase('http://127.0.0.1:8081');
  final Logger _logger = Logger();

  /// Realiza o login de um usuário.
  ///
  /// Este método autentica um usuário com as credenciais fornecidas.
  Future<Result<ClientException, RecordAuth>> signIn({
    required String identity,
    required String password,
  }) async {
    try {
      final recordAuth = await _pb.collection('users').authWithPassword(identity, password);

      return (null, recordAuth);
    } catch (error) {
      if (error is ClientException) {
        return (error, null);
      }

      _logger(message: 'Ocorreu um erro desconhecido ao realizar o login: $error', type: LoggerType.error);
      return (null, null);
    }
  }

  /// Registra um novo usuário.
  ///
  /// Este método cria um novo usuário com as credenciais fornecidas.
  Future<Result<ClientException, RecordModel>> signUp({
    required String username,
    required String password,
    required String repeatPassword,
  }) async {
    final Map<String, dynamic> body = {
      'username': username,
      'password': password,
      'passwordConfirm': repeatPassword,
    };

    try {
      final RecordModel recordModel = await _pb.collection('users').create(body: body);

      return (null, recordModel);
    } catch (error) {
      if (error is ClientException) {
        return (error, null);
      }

      _logger(message: 'Ocorreu um erro desconhecido ao realizar o login: $error', type: LoggerType.error);
      return (null, null);
    }
  }
}
