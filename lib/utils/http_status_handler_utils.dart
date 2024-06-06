import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import '../models/error_response_model.dart';
import '../models/success_response_model.dart';
import 'result_utils.dart';

class HttpStatusHandler {
  static Future<ResultUtils<ErrorResponseModel, SuccessResponseModel<T>>> handleResponse<T>({
    required Response response,
    required T Function(dynamic) fromJsonT,
  }) async {
    final Map<String, dynamic> body = jsonDecode(response.body);
    final int statusCode = response.statusCode;

    final Map<int, (ErrorResponseModel?, SuccessResponseModel<T>?) Function()> statusHandlers = {
      HttpStatus.ok: () {
        final SuccessResponseModel<T> success = SuccessResponseModel<T>.fromJson(
          body,
          fromJsonT,
        );
        return (null, success);
      },
      HttpStatus.created: () {
        final SuccessResponseModel<T> success = SuccessResponseModel<T>.fromJson(
          body,
          fromJsonT,
        );
        return (null, success);
      },
      HttpStatus.badRequest: () {
        return (ErrorResponseModel.fromJson(body), null);
      },
      HttpStatus.conflict: () {
        return (ErrorResponseModel.fromJson(body), null);
      },
      HttpStatus.unauthorized: () {
        return (ErrorResponseModel.fromJson(body), null);
      },
    };

    if (statusHandlers.containsKey(statusCode)) {
      return statusHandlers[statusCode]!();
    } else {
      return (
        ErrorResponseModel(
          status: HttpStatus.internalServerError,
          title: 'Erro interno, tente novamente mais tarde.',
        ),
        null,
      );
    }
  }
}
