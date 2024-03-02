import 'package:servidor/models/alert_model/types/alert_types.dart';

/// Modelo de alerta.
///
/// Este modelo representa um alerta que pode ser exibido para o usuário.
interface class AlertModel {
  /// Cria uma novo `AlertModel` com o título, mensagem e tipo especificados.
  AlertModel({required this.title, required this.message, required this.type});

  /// O título do alerta.
  final String title;

  /// A mensagem do alerta.
  final String message;

  /// O tipo de alerta.
  final AlertType type;
}
