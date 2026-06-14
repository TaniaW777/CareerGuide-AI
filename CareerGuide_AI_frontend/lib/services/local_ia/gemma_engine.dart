import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_gemma/core/model_response.dart';

/// GemmaEngine loads the Gemma model using flutter_gemma and provides a simple generate method.
class GemmaEngine {
  static bool _initialized = false;
  static late final InferenceModel _model;

  /// Initialise the model. Must be called once (e.g., from main before AI init).
  static Future<void> initialize() async {
    if (_initialized) return;
    try {
      // Initialise the flutter_gemma plugin (required on some platforms).
      await FlutterGemma.initialize();
      // Verify that the model asset exists before attempting installation.
      bool assetExists = false;
      try {
        await rootBundle.load('assets/models/gemma/gemma-2b-it.gguf');
        assetExists = true;
      } catch (e) {
        debugPrint('⚠️ Gemma model asset not found: $e');
        assetExists = false;
      }
      if (assetExists) {
        await FlutterGemma.installModel(modelType: ModelType.gemmaIt)
            .fromAsset('assets/models/gemma/gemma-2b-it.gguf')
            .install();
      } else {
        debugPrint('⚠️ Skipping Gemma model installation because asset is missing.');
      }
      // Load the active model after installation.
      _model = await FlutterGemma.getActiveModel(maxTokens: 512);
      _initialized = true;
      debugPrint('✅ Gemma model installed and loaded');
    } catch (e) {
      // If the asset is missing or installation fails, keep _initialized false.
      debugPrint('⚠️ GemmaEngine initialization failed (model may be missing): $e');
    }
  }

  /// Generate a response given a prompt and user profile.
  /// Returns `null` if the model is not loaded or an error occurs.
  static Future<String?> generate(String prompt, Map<String, dynamic> profile) async {
    if (!_initialized) return null;
    try {
      final contextJson = jsonEncode(profile);
      final fullPrompt = "User profile: $contextJson\n\nPrompt: $prompt";
      // Create a chat session for this inference.
      final chat = await _model.createChat();
      // Add the user's prompt to the chat.
      await chat.addQueryChunk(Message.text(text: fullPrompt, isUser: true));
      // Generate the response.
       final response = await chat.generateChatResponse();
       if (response is TextResponse) {
         return response.token.trim();
       }
       return null;
    } catch (e) {
      debugPrint('⚠️ GemmaEngine generation error: $e');
      return null;
    }
  }
}
