import 'dart:convert';
import 'package:http/http.dart' as http;

/// Simple wrapper around a local Ollama server.
///
/// The server must be running on http://127.0.0.1:11434 and a model
/// (e.g. `gemma:2b` or `llama2:7b`) must be pulled beforehand.
/// If the request fails the caller will fall back to the rule‑based
/// `EnhancedChatService`.
class OllamaEngine {
  static const String _defaultModel = 'gemma:2b';
  static const String _url = 'http://127.0.0.1:11434/api/chat';

  /// Generate a reply using Ollama. Returns `null` on any error.
  static Future<String?> generate(String userMessage, Map<String, dynamic> profile) async {
    try {
      final systemPrompt = _buildSystemPrompt(profile);
      final body = json.encode({
        'model': _defaultModel,
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': userMessage},
        ],
        'stream': false,
      });

      final response = await http
          .post(Uri.parse(_url),
              headers: {'Content-Type': 'application/json'}, body: body)
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Ollama returns {"message": {"content": "..."}}
        if (data is Map && data['message'] is Map && data['message']['content'] != null) {
          final content = data['message']['content'];
          return content.toString().trim();
        }
        // Fallback for older schema
        if (data is Map && data['response'] != null) {
          return data['response'].toString().trim();
        }
      }
    } catch (_) {
      // Silently ignore – caller will use fallback.
    }
    return null;
  }

  static String _buildSystemPrompt(Map<String, dynamic> profile) {
    final name = profile['first_name'] ?? 'l\'ami';
    final level = profile['class_level'] ?? '3ème';
    final stream = profile['stream'] ?? '';
    final subjects = (profile['favorite_subjects'] as List<dynamic>?)?.join(', ') ?? '';
    final interests = (profile['interests'] as List<dynamic>?)?.join(', ') ?? '';
    return 'Tu es un conseiller d\'orientation scolaire hors‑ligne. '
        'Réponds de façon claire, empathique et courte. '
        'Le profil de l\'utilisateur : $name, niveau $level ($stream), '
        'matières favorites : $subjects, intérêts : $interests. '
        'Donne des conseils pertinents et pose une question ouverte à la fin.';
  }
}
