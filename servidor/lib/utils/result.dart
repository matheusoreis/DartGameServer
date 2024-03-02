/// `Result` é um typedef para uma função que aceita dois parâmetros opcionais: `exception` e `data`.
/// `exception` é do tipo `Failure` e representa um erro ou exceção que pode ter ocorrido.
/// `data` é do tipo `Success` e representa os dados de sucesso que podem ter sido retornados.
typedef Result<Failure, Success> = (Failure? exception, Success? data);

/// `ResultExtension` é uma extensão na função `Result`.
/// Ela adiciona métodos e getters adicionais para lidar com o resultado de uma operação.
extension ResultExtension<Failure, Success> on Result<Failure, Success> {
  /// `fold` é um método que aceita duas funções opcionais: `success` e `failure`.
  /// Se `exception` não for nulo, a função `failure` é chamada com `exception`.
  /// Se `data` não for nulo, a função `success` é chamada com `data`.
  Result? fold({
    Function(Success)? success,
    Function(Failure)? failure,
  }) {
    if (this.$1 != null) {
      failure?.call(this.$1 as Failure);
    } else if (this.$2 != null) {
      success?.call(this.$2 as Success);
    }
    return this;
  }

  /// `isSuccess` é um getter que retorna `true` se `data` não for nulo.
  bool get isSuccess => this.$2 != null;

  /// `isFailure` é um getter que retorna `true` se `exception` não for nulo.
  bool get isFailure => this.$1 != null;

  /// `getSuccess` é um getter que retorna `data`.
  Success? get getSuccess => this.$2;

  /// `getFailure` é um getter que retorna `exception`.
  Failure? get getFailure => this.$1;
}
