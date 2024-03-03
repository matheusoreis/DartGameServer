import 'package:pocketbase/pocketbase.dart';
import 'package:servidor/database/repositories/auth_repository.dart';
import 'package:servidor/utils/result.dart';

/// Classe responsável por fornecer serviços de autenticação.
///
/// Esta classe atua como uma camada intermediária entre os dados do usuário
/// e a camada de negócios para realizar operações de autenticação.
class AuthService {
  final AuthRepository _authRepository = AuthRepository();

  /// Realiza o login de um usuário.
  ///
  /// Este método delega a operação de login para o `AuthRepository`, que
  /// interage com o serviço remoto para autenticar o usuário com as credenciais
  /// fornecidas.
  Future<Result<ClientException, RecordAuth>> sigIn({
    required String identity,
    required String password,
  }) async {
    final (ClientException?, RecordAuth?) response = await _authRepository.signIn(
      identity: identity,
      password: password,
    );

    if (response.isSuccess) {
      return (null, response.getSuccess);
    } else {
      return (response.getFailure, null);
    }
  }

  /// Registra um novo usuário.
  ///
  /// Este método delega a operação de registro para o `AuthRepository`, que
  /// interage com o serviço remoto para criar um novo usuário com as credenciais
  /// fornecidas.
  Future<Result<ClientException, RecordModel>> signUp({
    required String username,
    required String password,
    required String repeatPassword,
  }) async {
    final (ClientException?, RecordModel?) response = await _authRepository.signUp(
      username: username,
      password: password,
      repeatPassword: repeatPassword,
    );

    if (response.isSuccess) {
      return (null, response.getSuccess);
    } else {
      return (response.getFailure, null);
    }
  }
}
