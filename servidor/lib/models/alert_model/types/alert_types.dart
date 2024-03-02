/// Enumeração que representa os tipos de alerta disponíveis.
///
/// Esta enumeração define os tipos de alerta que podem ser utilizados.
enum AlertType {
  /// Tipo de alerta para informações gerais.
  info,

  /// Tipo de alerta para avisos.
  warning,

  /// Tipo de alerta para erros.
  error,

  /// Tipo de alerta para sucessos.
  success,
}

/// Extensão para fornecer funcionalidades adicionais ao enum `AlertType`.
///
/// Esta extensão permite acessar propriedades adicionais e métodos úteis
/// relacionados à enumeração `AlertType`.
extension AlertTypeExtension on AlertType {
  /// Obtém o número total de tipos de alerta disponíveis.
  static int get count => AlertType.values.length;
}
