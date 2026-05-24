import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/backend_config.dart';

/// Wrapper that calls the CareerGuide backend (which runs Gemma or
/// falls back to rule-based) via HTTP.
///
/// When the user is "online" the backend at [BackendConfig.baseUrl] is
/// contacted.  If the request fails the caller will fall back to the
/// rule-based `EnhancedChatService`.
class GemmaEngine {
  /// Generate a reply via the backend. Returns `null` on any error.
  static Future<String?> generate(String userMessage, Map<String, dynamic> profile) async {
    try {
      final body = json.encode({
        'message': userMessage,
        'profile': profile,
      });

      final response = await http
          .post(
            BackendConfig.chatUri(),
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['reply']?.toString().trim();
      }
    } catch (e) {
      print("GemmaEngine error: $e");
      // Silently ignore – caller will use fallback.
    }
    return null;
  }
}
