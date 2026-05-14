import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final String selectedClasse;

  const QuestionFlowScreen({super.key, this.selectedClasse = '3ème'});

  @override
  State<QuestionFlowScreen> createState() => _QuestionFlowScreenState();
}

class _QuestionFlowScreenState extends State<QuestionFlowScreen> {
  int _currentStep = 0;

  late final List<_Question> _questions;

  // Questions for 3ème (orientation after BEPC - choosing a series)
  static final List<_Question> _questions3eme = [
    _Question(
      text: 'Quel type d\'activité préfères-tu faire ?',
      options: ['Résoudre des problèmes de maths ou de logique', 'Lire, écrire ou raconter des histoires', 'Dessiner, créer ou bricoler', 'Aider les autres, écouter et conseiller'],
      icon: Icons.psychology_outlined,
    ),
    _Question(
      text: 'Comment aimes-tu travailler en classe ?',
      options: ['Seul, à mon rythme', 'En groupe avec mes camarades', 'Avec un professeur qui m\'explique bien', 'En faisant des exercices pratiques'],
      icon: Icons.groups_outlined,
    ),
    _Question(
      text: 'Qu\'est-ce qui te motive le plus ?',
      options: ['Comprendre comment les choses fonctionnent', 'Découvrir le monde et les cultures', 'Construire ou fabriquer quelque chose', 'Gagner de l\'argent et réussir'],
      icon: Icons.emoji_objects_outlined,
    ),
    _Question(
      text: 'Quel métier t\'attire le plus ?',
      options: ['Ingénieur, technicien ou informaticien', 'Médecin, infirmier ou pharmacien', 'Professeur, journaliste ou avocat', 'Commerçant, entrepreneur ou gestionnaire'],
      icon: Icons.work_outline,
    ),
    _Question(
      text: 'Après le BEPC, que voudrais-tu faire ?',
      options: ['Aller en série scientifique (C ou D)', 'Aller en série littéraire (A)', 'Suivre une formation technique ou professionnelle', 'Je ne sais pas encore'],
      icon: Icons.flag_outlined,
    ),
  ];

  // Questions for Tle (orientation post-bac - higher education)
  static final List<_Question> _questionsTle = [
    _Question(
      text: 'Quel domaine d\'études supérieures vous attire le plus ?',
      options: ['Sciences et Ingénierie (Polytechnique, Génie civil...)', 'Santé (Médecine, Pharmacie, Biologie...)', 'Droit, Économie et Gestion', 'Lettres, Arts et Sciences Humaines'],
      icon: Icons.school_outlined,
    ),
    _Question(
      text: 'Comment envisagez-vous votre parcours post-bac ?',
      options: ['Université publique au Burkina Faso', 'Grande école ou institut spécialisé', 'Formation professionnelle courte (BTS, DUT)', 'Études à l\'étranger si possible'],
      icon: Icons.timeline_outlined,
    ),
    _Question(
      text: 'Quel environnement professionnel vous correspond ?',
      options: ['Recherche et laboratoire', 'Bureau, entreprise ou administration', 'Terrain (hôpital, chantier, agriculture)', 'Indépendant / Entrepreneuriat'],
      icon: Icons.location_on_outlined,
    ),
    _Question(
      text: 'Quelle compétence souhaitez-vous développer en priorité ?',
      options: ['Compétences techniques et scientifiques', 'Leadership et gestion de projet', 'Communication et relations humaines', 'Créativité et innovation'],
      icon: Icons.trending_up_outlined,
    ),
    _Question(
      text: 'Quel est votre objectif principal après le BAC ?',
      options: ['Obtenir un diplôme reconnu et trouver un emploi stable', 'Créer ma propre entreprise ou startup', 'Poursuivre des études longues (Master, Doctorat)', 'Contribuer au développement de ma communauté'],
      icon: Icons.flag_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _questions = widget.selectedClasse == 'Tle' ? _questionsTle : _questions3eme;
  }

  int get _totalSteps => _questions.length;
  int get _answeredCount => _questions.where((q) => q.selectedIndex != null).length;

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentStep];
    final progress = (_currentStep + 1) / _totalSteps;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF7F8FA),
      body: Column(
        children: [
          // Header
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
                Text('Question ${_currentStep + 1} sur $_totalSteps • $_answeredCount complétée(s)', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 20),
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

          // Content
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: isDark ? AppColors.borderDark : const Color(0xFFE8ECF0),
                        valueColor: AlwaysStoppedAnimation<Color>(isDark ? AppColors.primaryDark : AppColors.primaryLight),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Question header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.primaryDark.withValues(alpha: 0.16) : AppColors.primaryLight.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(q.icon, color: isDark ? AppColors.onPrimaryDark : AppColors.primaryLight, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(child: Text(q.text, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, height: 1.4, color: isDark ? AppColors.onSurfaceDark : Colors.black87))),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Options list
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
                                color: isSelected ? AppColors.primaryLight : (isDark ? AppColors.surfaceDark : Colors.white),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: isSelected ? AppColors.primaryLight : (isDark ? AppColors.borderDark : Colors.grey.shade200), width: isSelected ? 2 : 1),
                                boxShadow: isSelected ? [BoxShadow(color: AppColors.primaryLight.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))] : [],
                              ),
                              child: Row(
                                children: [
                                  Expanded(child: Text(q.options[i], style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, fontSize: 15, color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87)))),
                                  Icon(isSelected ? Icons.check_circle : Icons.radio_button_unchecked, color: isSelected ? Colors.white : (isDark ? Colors.white60 : Colors.grey)),
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
                              style: OutlinedButton.styleFrom(foregroundColor: AppColors.primaryLight, side: const BorderSide(color: AppColors.primaryLight), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                            ),
                          ),
                        if (_currentStep > 0) const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (_questions[_currentStep].selectedIndex == null) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez répondre à cette question avant de continuer.'), backgroundColor: Colors.redAccent));
                                return;
                              }
                              if (_currentStep == _totalSteps - 1) {
                                // Save answers to SharedPreferences for later recommendation processing
                                () async {
                                  final prefs = await SharedPreferences.getInstance();
                                  final answers = _questions.map((q) => q.selectedIndex?.toString() ?? '-1').toList();
                                  await prefs.setString('qa_answers', answers.join(','));
                                  await prefs.setString('user_classe', widget.selectedClasse);
                                  if (!mounted) return;
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProcessingScreen()));
                                }();
                              } else {
                                setState(() => _currentStep++);
                              }
                            },
                            icon: Icon(_currentStep == _totalSteps - 1 ? Icons.auto_awesome : Icons.arrow_forward),
                            label: Text(_currentStep == _totalSteps - 1 ? 'VOIR MES RÉSULTATS' : 'SUIVANT'),
                            style: ElevatedButton.styleFrom(backgroundColor: isDark ? AppColors.primaryDark : AppColors.primaryLight, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
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
