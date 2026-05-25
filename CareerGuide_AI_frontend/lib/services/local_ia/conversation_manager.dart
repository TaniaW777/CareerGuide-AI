import 'package:flutter/foundation.dart';
import '../database/local_db.dart';

class ConversationManager {
  /// Save conversation turn locally
  static Future<void> saveConversationTurn({
    required String userMessage,
    required String aiResponse,
    required int userId,
  }) async {
    try {
      final db = await LocalDatabase.database;
      await db.insert('chat_messages', {
        'user_id': userId,
        'message': userMessage,
        'reply': aiResponse,
        'timestamp': DateTime.now().toIso8601String(),
      });
      debugPrint("✅ Conversation sauvegardée localement");
    } catch (e) {
      debugPrint("⚠️ Erreur sauvegarde: $e");
    }
  }

  /// Get full conversation history for context
  static Future<List<Map<String, dynamic>>> getConversationHistory(
    int userId, {
    int limit = 10,
  }) async {
    try {
      final db = await LocalDatabase.database;
      final results = await db.query(
        'chat_messages',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'timestamp DESC',
        limit: limit,
      );
      return results.reversed.toList(); // Return chronological order
    } catch (e) {
      debugPrint("⚠️ Erreur récupération historique: $e");
      return [];
    }
  }

  /// Get recent conversation summary for context
  static Future<String> getConversationContext(int userId) async {
    try {
      final history = await getConversationHistory(userId, limit: 5);
      if (history.isEmpty) return "";

      final context = history
          .map((h) => "Utilisateur: ${h['message']}\nIA: ${h['reply']}")
          .join("\n\n");

      return "Contexte récent:\n$context";
    } catch (e) {
      debugPrint("⚠️ Erreur contexte: $e");
      return "";
    }
  }

  /// Clear old conversations (keep data fresh and storage clean)
  static Future<void> clearOldConversations({int olderThanDays = 30}) async {
    try {
      final db = await LocalDatabase.database;
      final cutoffDate = DateTime.now().subtract(Duration(days: olderThanDays));
      
      final deleted = await db.delete(
        'chat_messages',
        where: 'timestamp < ?',
        whereArgs: [cutoffDate.toIso8601String()],
      );

      debugPrint("✅ $deleted conversations anciennes supprimées");
    } catch (e) {
      debugPrint("⚠️ Erreur suppression: $e");
    }
  }

  /// Export conversation for sharing/backup
  static Future<String> exportConversation(int userId) async {
    try {
      final history = await getConversationHistory(userId, limit: 999);
      
      final export = StringBuffer();
      export.writeln("=== EXPORT DE CONVERSATION ===");
      export.writeln("Date: ${DateTime.now()}");
      export.writeln("=========================================\n");

      for (var msg in history) {
        export.writeln("📝 ${msg['timestamp']}");
        export.writeln("👤 Moi: ${msg['message']}");
        export.writeln("🤖 IA: ${msg['reply']}");
        export.writeln("---");
      }

      return export.toString();
    } catch (e) {
      debugPrint("⚠️ Erreur export: $e");
      return "Erreur lors de l'export";
    }
  }

  /// Get conversation statistics
  static Future<Map<String, dynamic>> getConversationStats(int userId) async {
    try {
      final history = await getConversationHistory(userId, limit: 999);

      int totalMessages = history.length;
      int totalCharacters = history
          .fold(0, (sum, msg) => sum + (msg['message'] as String).length);

      return {
        'totalMessages': totalMessages,
        'totalCharacters': totalCharacters,
        'averageMessageLength':
            totalMessages > 0 ? totalCharacters ~/ totalMessages : 0,
        'firstMessage': history.isNotEmpty ? history.first['timestamp'] : null,
        'lastMessage': history.isNotEmpty ? history.last['timestamp'] : null,
      };
    } catch (e) {
      debugPrint("⚠️ Erreur stats: $e");
      return {};
    }
  }

  /// Search in conversation history
  static Future<List<Map<String, dynamic>>> searchConversation(
    int userId,
    String query,
  ) async {
    try {
      final db = await LocalDatabase.database;
      final results = await db.query(
        'chat_messages',
        where: 'user_id = ? AND (message LIKE ? OR reply LIKE ?)',
        whereArgs: [userId, '%$query%', '%$query%'],
        orderBy: 'timestamp DESC',
      );
      return results;
    } catch (e) {
      debugPrint("⚠️ Erreur recherche: $e");
      return [];
    }
  }
}
