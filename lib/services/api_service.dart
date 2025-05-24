import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:8080';

  final http.Client _client;
  String? _authToken; // token pt autorizare backend

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<http.Response> getRequest(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    return await _client.get(url);
  }

  Future<http.Response> postRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    return await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  Future<http.Response> deleteRequest(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    return await _client.delete(url);
  }
}
