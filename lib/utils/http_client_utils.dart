import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class HttpClientUtils {
  static Future<http.Response> get({
    required String url,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
    String? bearerToken,
  }) async {
    final uri = Uri.parse(url).replace(queryParameters: queryParameters);
    final Response response = await http.get(
      uri,
      headers: _addAuthorizationHeader(headers, bearerToken),
    );

    return response;
  }

  static Future<http.Response> post({
    required String url,
    required dynamic body,
    Map<String, String>? headers,
    String? bearerToken,
  }) async {
    final Response response = await http.post(
      Uri.parse(url),
      headers: _addAuthorizationHeader(headers, bearerToken),
      body: jsonEncode(body),
    );

    return response;
  }

  static Future<http.Response> put({
    required String url,
    required dynamic body,
    Map<String, String>? headers,
    String? bearerToken,
  }) async {
    final Response response = await http.put(
      Uri.parse(url),
      headers: _addAuthorizationHeader(headers, bearerToken),
      body: jsonEncode(body),
    );

    return response;
  }

  static Future<http.Response> patch({
    required String url,
    required dynamic body,
    Map<String, String>? headers,
    String? bearerToken,
  }) async {
    final Response response = await http.patch(
      Uri.parse(url),
      headers: _addAuthorizationHeader(headers, bearerToken),
      body: jsonEncode(body),
    );

    return response;
  }

  static Future<http.Response> delete({
    required String url,
    dynamic body,
    Map<String, String>? headers,
    String? bearerToken,
  }) async {
    final Response response = await http.delete(
      Uri.parse(url),
      headers: _addAuthorizationHeader(headers, bearerToken),
      body: jsonEncode(body),
    );

    return response;
  }

  static Map<String, String> _addAuthorizationHeader(
    Map<String, String>? headers,
    String? bearerToken,
  ) {
    final Map<String, String> updatedHeaders = Map.from(headers ?? {});

    if (bearerToken != null) {
      updatedHeaders['Authorization'] = 'Bearer $bearerToken';
    }

    updatedHeaders['Content-Type'] = 'application/json';

    return updatedHeaders;
  }
}
