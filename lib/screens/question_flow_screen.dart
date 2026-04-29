import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'processing_screen.dart';

class _Question {
  final String text;
  final List<String> options;
  final IconData icon;
  int? selectedIndex;

  _Question({required this.text, required this.options, required this.icon, this.selectedIndex});
}

class QuestionFlowScreen extends StatefulWidget {
  const QuestionFlowScreen({super.key});

  @override
  State<QuestionFlowScreen> createState() => _QuestionFlowScreenState();
}

class _QuestionFlowScreenState extends State<QuestionFlowScreen> {
  int _currentStep = 0;

  final List<_Question> _questions = [
    _Question(
      text: 'Quel domaine vous passionne le plus ?',
      options: ['Résoudre des problèmes complexes', 'Aider et soigner les gens', 'Créer des œuvres artistiques', 'Gérer et organiser des projets'],
      icon: Icons.psychology_outlined,
    ),
    _Question(
      text: 'Comment préférez-vous travailler ?',
      options: ['Seul, en autonomie', 'En équipe soudée', 'En contact avec le public', 'En milieu technique'],
      icon: Icons.groups_outlined,
    ),
    _Question(
      text: 'Quel environnement vous correspond ?',
      options: ['En plein air / terrain', 'En bureau / laboratoire', 'À domicile / distance', 'En déplacement constant'],
      icon: Icons.location_on_outlined,
    ),
    _Question(
      text: 'Quelles sont vos matières préférées ?',
      options: ['Mathématiques & Sciences', 'Lettres & Langues', 'Informatique & Tech', 'Arts & Culture'],
      icon: Icons.book_outlined,
    ),
    _Question(
      text: 'Quel est votre objectif principal ?',
      options: ['Trouver un emploi stable', 'Créer ma propre entreprise', 'Poursuivre des études avancées', 'Aider ma communauté'],
      icon: Icons.flag_outlined,
    ),
  ];

  int get _totalSteps => _questions.length;
  int get _answeredCount => _questions.where((q) => q.selectedIndex != null).length;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final q = _questions[_currentStep];
    final progress = (_currentStep + 1) / _totalSteps;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Blue header
          Positioned(
            top: 0, left: 0, right: 0,
            height: size.height * 0.28,
            child: Container(
              color: AppColors.primaryLight,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Questionnaire IA', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('Question ${_currentStep + 1} sur $_totalSteps  •  $_answeredCount/$_totalSteps répondues', style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 14),
                      // Dot indicators
                      Row(
                        children: List.generate(_totalSteps, (i) {
                          final answered = _questions[i].selectedIndex != null;
                          final current = i == _currentStep;
                          return GestureDetector(
                            onTap: () => setState(() => _currentStep = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.only(right: 8),
                              width: current ? 28 : 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: current ? Colors.white : (answered ? Colors.green.shade300 : Colors.white38),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Back button
          Positioned(
            top: 44, right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Content Card
          Positioned(
            bottom: 0, left: 0, right: 0,
            height: size.height * 0.77,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              ),
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 20),
              child: Column(
                children: [
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[100],
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
                      minHeight: 7,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Question
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(q.icon, color: AppColors.primaryLight, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(q.text, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, height: 1.4)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Options
                  Expanded(
                    child: ListView.separated(
                      itemCount: q.options.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final isSelected = q.selectedIndex == i;
                        return GestureDetector(
                          onTap: () => setState(() => q.selectedIndex = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryLight : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected ? AppColors.primaryLight : Colors.grey.shade200,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected ? [BoxShadow(color: AppColors.primaryLight.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))] : [],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    q.options[i],
                                    style: TextStyle(
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                      fontSize: 15,
                                      color: isSelected ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ),
                                Icon(
                                  isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                  color: isSelected ? Colors.white : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Navigation buttons
                  Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => setState(() => _currentStep--),
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('PRÉCÉDENT'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primaryLight,
                              side: const BorderSide(color: AppColors.primaryLight),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: _currentStep == _totalSteps - 1
                              ? () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProcessingScreen()))
                              : () => setState(() => _currentStep++),
                          icon: Icon(_currentStep == _totalSteps - 1 ? Icons.auto_awesome : Icons.arrow_forward),
                          label: Text(_currentStep == _totalSteps - 1 ? 'VOIR MES RÉSULTATS' : 'SUIVANT'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryLight,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
