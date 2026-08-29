import 'package:flutter_gemma/flutter_gemma_interface.dart';
import 'package:flutter_gemma/core/model.dart';
import 'package:flutter_gemma/core/message.dart';
import 'package:flutter_gemma/core/chat.dart';
import 'model_service.dart';
import 'orientation_engine.dart';

class LlmService {
  static final LlmService _instance = LlmService._internal();
  factory LlmService() => _instance;
  LlmService._internal();

  bool _isInitialized = false;
  bool _isInitializing = false;
  InferenceModel? _model;
  InferenceChat? _chat;

  Future<void> initialize() async {
    if (_isInitialized) return;
    if (_isInitializing) {
      while (_isInitializing) await Future.delayed(const Duration(milliseconds: 80));
      return;
    }

    _isInitializing = true;
    print('[LLM] Initializing Gemma...');

    try {
      final modelPath = await ModelService().getModelPath();
      await FlutterGemmaPlugin.instance.modelManager.setModelPath(modelPath);

      _model = await FlutterGemmaPlugin.instance.createModel(
        modelType: ModelType.gemmaIt,
        maxTokens: 775,
      );

      await _createNewChat();
      _isInitialized = true;
      print('[LLM] Ready');
    } catch (e) {
      print('[LLM] Init error: $e');
      rethrow;
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> _createNewChat() async {
    _chat = await _model!.createChat(
      temperature: 0.42,
      topK: 24,
      topP: 0.80,
      tokenBuffer: 10,
    );
  }

  Future<String> generate(String userMessage) async {
    print('[LLM] Query: "$userMessage"');

    if (!_isInitialized) await initialize();
    if (_chat == null) await _createNewChat();

    try {
      final analyse = OrientationEngine.analyserEtOrienter(
        AnalyseInput(message: userMessage),
      );

      // Construction dynamique des intérêts
      final interetsStr = analyse.interetsDetectes
          .map((e) => e.name)
          .join(", ");

      final filieresStr = analyse.filieres.isNotEmpty 
          ? analyse.filieres.map((f) => "${f.nom} (${f.etablissement})").join(" | ") 
          : "Informatique (UJKZ), Génie Civil (2iE), Sciences Économiques (UNZ)";

      final strictPrompt = """
Tu es un conseiller d'orientation sérieux et direct au Burkina Faso.
Utilise UNIQUEMENT ces informations :

Niveau : ${analyse.niveauDetecte == NiveauEtude.postBepc ? "Après BEPC" : "Après BAC"}
Intérêts détectés : $interetsStr
Filières recommandées : $filieresStr

Règles strictes :
- Réponds en français clair, max 4 phrases.
- Propose les filières avec leur établissement.
- Justifie brièvement en lien avec les intérêts de l'élève.
- Termine par UNE seule question pertinente.
- Sois concret, professionnel, sans phrases vides ("ravi", "plaisir", "opportunité"...).
""";

      await _chat!.addQueryChunk(Message(
        text: "$strictPrompt\n\nÉlève: $userMessage",
        isUser: true,
      ));

      final buffer = StringBuffer();
      await for (final token in _chat!.generateChatResponseAsync()) {
        buffer.write(token);
      }

      String result = buffer.toString().trim();

      // Fallback fort
      if (result.isEmpty || result.length < 55 || result.contains("ravi") || result.contains("plaisir")) {
        return "${analyse.messagePersonnalise}\n\n${analyse.questionRelance}";
      }

      return result;
    } catch (e) {
      print('[LLM] Error: $e');
      await _createNewChat();

      final analyse = OrientationEngine.analyserEtOrienter(AnalyseInput(message: userMessage));
      return "${analyse.messagePersonnalise}\n\n${analyse.questionRelance}";
    }
  }

  bool get isReady => _isInitialized;

  Future<void> resetChat() async {
    if (_isInitialized && _model != null) {
      await _createNewChat();
    }
  }

  Future<void> dispose() async {
    await _model?.close();
    _isInitialized = false;
    _model = null;
    _chat = null;
  }
}
