import 'package:careerguide_ai/services/local_ia/enhanced_chat_service.dart';
import 'package:careerguide_ai/services/local_ia/gemma_engine.dart';

/// Wrapper that decides which AI backend to use.
///
/// - Tries to contact the CareerGuide backend (running Gemma model).
/// - If the request fails (server down or unreachable) it falls back
///   to the rule‑based `EnhancedChatService` which works 100 % offline.
class OfflineAIEngine {
  /// Generate a chat reply.
  /// Returns the generated text.
  static Future<String> generateChatReply(String message, Map<String, dynamic> profile) async {
    // Try the backend (Gemma) first
    try {
      final reply = await GemmaEngine.generate(message, profile);
      if (reply != null && reply.isNotEmpty) {
        return reply;
      }
    } catch (_) {
      // ignore – fallback below
    }
    // Fallback to the existing rule‑based service (100% offline)
    return await EnhancedChatService.generateSmartReply(message, profile);
  }
}
