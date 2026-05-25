import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/config/backend_config.dart';
import '../core/theme/app_colors.dart';
import 'processing_screen.dart';

class QuestionFlowScreen extends StatefulWidget {
  final String selectedClasse;

  const QuestionFlowScreen({super.key, this.selectedClasse = '3ème'});

  @override
  State<QuestionFlowScreen> createState() => _QuestionFlowScreenState();
}

class _QuestionFlowScreenState extends State<QuestionFlowScreen> {
  int _currentStep = 0;
  bool _isLoading = true;
  String? _errorMessage;
  List<String> _questions = [];
  final List<TextEditingController> _controllers = [];

  static const List<String> _fallbackQuestions3eme = [
    'Quelles matières te passionnent le plus et pourquoi ?',
    'Comment préfères-tu apprendre : en expérimentant, en lisant, en discutant ou en observant ?',
    'Quelles activités te donnent le plus envie de te lever le matin ?',
    'Quel métier t\'a déjà fait rêver, même indirectement ?',
    'Après le BEPC, préférerais-tu une filière scientifique, littéraire ou technique ? Explique en quelques mots.'
  ];

  static const List<String> _fallbackQuestionsTle = [
    'Quelles matières de Terminale te motivent le plus actuellement ?',
    'Préférerais-tu des études longues, une formation professionnalisante ou une voie très pratique ?',
    'Quelles valeurs souhaitent donner du sens à ta future carrière ?',
    'Quel environnement de travail imagines-tu pour ton avenir ?',
    'Quelles compétences aimerais-tu développer après le BAC ?'
  ];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final level = widget.selectedClasse;
    final fallback = level == 'Tle' ? _fallbackQuestionsTle : _fallbackQuestions3eme;
    List<String> questions = List.from(fallback);

    try {
      final uri = Uri.parse('${BackendConfig.baseUrl}/model/generate-questions?level=${Uri.encodeQueryComponent(level)}');
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is List) {
          final generated = decoded.map((item) => item.toString().trim()).where((text) => text.isNotEmpty).toList();
          if (generated.isNotEmpty) {
            questions = generated;
          }
        }
      }
    } catch (error) {
      _errorMessage = 'Impossible de charger le questionnaire dynamique. Utilisation d\'un questionnaire local.';
    }

    if (questions.isEmpty) {
      questions = fallback;
    }

    _questions = questions.take(5).toList();
    _controllers.clear();
    for (int i = 0; i < _questions.length; i++) {
      _controllers.add(TextEditingController());
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  int get _totalSteps => _questions.length;
  String get _currentQuestion => _questions[_currentStep];

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _nextStep() async {
    final answer = _controllers[_currentStep].text.trim();
    if (answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez répondre à cette question avant de continuer.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_currentStep == _totalSteps - 1) {
      final prefs = await SharedPreferences.getInstance();
      final answers = _controllers.map((c) => c.text.trim()).toList();
      await prefs.setString('qa_answers', json.encode(answers));
      await prefs.setString('user_classe', widget.selectedClasse);

      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProcessingScreen()));
      return;
    }

    setState(() {
      _currentStep++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final progress = (_currentStep + 1) / _totalSteps;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF7F8FA),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(36), bottomRight: Radius.circular(36)),
            ),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 24, left: 24, right: 24, bottom: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(child: Text('Questionnaire IA', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold))),
                    IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const SizedBox(height: 10),
                Text('Question ${_currentStep + 1} sur $_totalSteps', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: isDark ? AppColors.borderDark : const Color(0xFFE8ECF0),
                    valueColor: AlwaysStoppedAnimation<Color>(isDark ? AppColors.primaryLight : AppColors.primaryDark),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(36), topRight: Radius.circular(36)),
                  border: Border.all(color: isDark ? AppColors.borderDark : Colors.transparent),
                ),
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(_errorMessage!, style: const TextStyle(color: Colors.orangeAccent, fontSize: 14)),
                      ),
                    Text(_currentQuestion, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                    const SizedBox(height: 20),
                    Expanded(
                      child: TextFormField(
                        controller: _controllers[_currentStep],
                        maxLines: null,
                        minLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Écris ta réponse ici...',
                          filled: true,
                          fillColor: isDark ? AppColors.backgroundDark : const Color(0xFFF2F4F7),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        if (_currentStep > 0)
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => setState(() => _currentStep--),
                              icon: const Icon(Icons.arrow_back),
                              label: const Text('PRÉCÉDENT'),
                            ),
                          ),
                        if (_currentStep > 0) const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _nextStep,
                            icon: Icon(_currentStep == _totalSteps - 1 ? Icons.auto_awesome : Icons.arrow_forward),
                            label: Text(_currentStep == _totalSteps - 1 ? 'VOIR MES RÉSULTATS' : 'SUIVANT'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
