import 'dart:convert';

import 'package:http/http.dart' as http;

class ChatApi {
  final http.Client _client;

  ChatApi({http.Client? client}) : _client = client ?? http.Client();

  Future<String> send({
    required String baseUrl,
    required String token,
    required String model,
    required List<Map<String, String>> messages,
  }) async {
    final uri = Uri.parse('$baseUrl/v1/chat/completions');
    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'model': model,
        'messages': messages,
      }),
    );

    if (response.statusCode >= 400) {
      throw Exception('Chat error ${response.statusCode}: ${response.body}');
    }

    final map = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = map['choices'];
    if (choices is List && choices.isNotEmpty) {
      final first = choices.first as Map<String, dynamic>;
      final message = first['message'];
      if (message is Map<String, dynamic>) {
        return (message['content'] ?? '').toString();
      }
    }
    return 'Sin respuesta del backend.';
  }
}
