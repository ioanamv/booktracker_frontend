import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:8080';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  String? _authToken;
  void setAuthToken(String? token) {
    _authToken = token;
  }

  Future<http.Response> getRequest(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    return await _client.get(
      url,
      headers: {
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<http.Response> postRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    return await _client.post(
      url,
      headers: {
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> deleteRequest(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    return await _client.delete(
      url,
      headers: {
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
        'Content-Type': 'application/json',
      },
    );
  }
}
