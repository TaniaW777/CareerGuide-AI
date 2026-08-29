import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_colors.dart';
import 'processing_screen.dart';

class _Question {
  final String text;
  final List<String> options;
  final IconData icon;
  int? selectedIndex;

  _Question({
    required this.text,
    required this.options,
    required this.icon,
    this.selectedIndex,
  });
}

class QuestionFlowScreen extends StatefulWidget {
  final String selectedClasse;

  const QuestionFlowScreen({
    super.key,
    this.selectedClasse = '3ème',
  });

  @override
  State<QuestionFlowScreen> createState() => _QuestionFlowScreenState();
}

class _QuestionFlowScreenState extends State<QuestionFlowScreen>
    with SingleTickerProviderStateMixin {
  bool _levelChosen = false;
  String _selectedLevel = '';
  late List<_Question> _questions;
  int _currentIndex = 0;

  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  final _bepcQ = [
    _Question(
      text: 'Quel type d\'activite preferes-tu ?',
      icon: Icons.psychology_outlined,
      options: [
        'Resoudre des problemes de maths ou logique',
        'Lire, ecrire ou communiquer',
        'Dessiner, creer ou bricoler',
        'Aider les autres et conseiller',
      ],
    ),
    _Question(
      text: 'Comment aimes-tu travailler en classe ?',
      icon: Icons.groups_outlined,
      options: [
        'Seul, a mon rythme',
        'En groupe avec des camarades',
        'Avec un professeur qui explique',
        'En faisant des exercices pratiques',
      ],
    ),
    _Question(
      text: 'Qu\'est-ce qui te motive le plus ?',
      icon: Icons.emoji_objects_outlined,
      options: [
        'Comprendre comment les choses fonctionnent',
        'Decouvrir le monde et les cultures',
        'Construire ou fabriquer quelque chose',
        'Reussir et avoir un bon salaire',
      ],
    ),
    _Question(
      text: 'Quel metier t\'attire le plus ?',
      icon: Icons.work_outline_rounded,
      options: [
        'Ingenieur, technicien ou informaticien',
        'Medecin, infirmier ou pharmacien',
        'Professeur, journaliste ou avocat',
        'Commercant, entrepreneur ou gestionnaire',
      ],
    ),
    _Question(
      text: 'Apres le BEPC, que voudrais-tu faire ?',
      icon: Icons.flag_outlined,
      options: [
        'Aller en serie scientifique (C ou D)',
        'Aller en serie litteraire (A)',
        'Formation technique ou professionnelle',
        'Je ne sais pas encore',
      ],
    ),
  ];

  final _bacQ = [
    _Question(
      text: 'Quel domaine d\'etudes superieures t\'attire ?',
      icon: Icons.school_outlined,
      options: [
        'Sciences et Ingenierie',
        'Sante (Medecine, Pharmacie...)',
        'Droit, Economie et Gestion',
        'Lettres, Arts et Sciences Humaines',
      ],
    ),
    _Question(
      text: 'Comment envisages-tu ton parcours post-bac ?',
      icon: Icons.timeline_outlined,
      options: [
        'Universite publique au Burkina Faso',
        'Grande ecole ou institut specialise',
        'Formation courte (BTS, DUT)',
        'Etudes a l\'etranger si possible',
      ],
    ),
    _Question(
      text: 'Quel environnement professionnel te correspond ?',
      icon: Icons.location_on_outlined,
      options: [
        'Recherche et laboratoire',
        'Bureau, entreprise ou administration',
        'Terrain (hopital, chantier, agriculture)',
        'Independant / Entrepreneuriat',
      ],
    ),
    _Question(
      text: 'Quelle competence veux-tu developper en priorite ?',
      icon: Icons.trending_up_outlined,
      options: [
        'Competences techniques et scientifiques',
        'Leadership et gestion de projet',
        'Communication et relations humaines',
        'Creativite et innovation',
      ],
    ),
    _Question(
      text: 'Quel est ton objectif principal apres le BAC ?',
      icon: Icons.flag_outlined,
      options: [
        'Diplome reconnu et emploi stable',
        'Creer ma propre entreprise',
        'Etudes longues (Master, Doctorat)',
        'Contribuer au developpement de ma communaute',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Si selectedClasse est passé depuis dashboard, on l'utilise directement
    if (widget.selectedClasse != '3ème') {
      _selectedLevel = widget.selectedClasse;
      _questions = widget.selectedClasse == 'Terminale' ? _bacQ : _bepcQ;
      _levelChosen = true;
    } else {
      _questions = _bepcQ;
    }
    _setupAnim();
  }

  void _setupAnim() {
    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _slideAnim = Tween<Offset>(
      begin: const Offset(0.12, 0),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _fadeAnim =
        CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut);
    _slideCtrl.forward();
  }

  void _animNext() {
    _slideCtrl.reset();
    _slideCtrl.forward();
  }

  void _selectLevel(String level) {
    setState(() {
      _selectedLevel = level;
      _questions = level == 'Terminale' ? _bacQ : _bepcQ;
      _levelChosen = true;
      _currentIndex = 0;
    });
    _animNext();
  }

  void _selectOption(int i) {
    setState(() => _questions[_currentIndex].selectedIndex = i);
  }

  Future<void> _next() async {
    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
      _animNext();
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_classe', _selectedLevel);
      final answers = _questions
          .map((q) => q.selectedIndex?.toString() ?? '-1')
          .join(',');
      await prefs.setString('qa_answers', answers);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 450),
          pageBuilder: (_, __, ___) => const ProcessingScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    }
  }

  void _back() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
      _animNext();
    } else {
      setState(() {
        _levelChosen = false;
        _currentIndex = 0;
      });
    }
  }

  bool get _canProceed =>
      _questions[_currentIndex].selectedIndex != null;

  @override
  void dispose() {
    _slideCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_levelChosen) return _buildLevelSelector();
    return _buildQuestionScreen();
  }

  // ── Selecteur niveau ───────────────────────────────────────────────

  Widget _buildLevelSelector() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary =
        isDark ? AppColors.primaryDark : AppColors.primaryLight;
    final accent =
        isDark ? AppColors.accentDark : AppColors.accentLight;
    final bg =
        isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surface =
        isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border =
        isDark ? AppColors.borderDark : AppColors.borderLight;
    final textColor =
        isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 36),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceDark
                    : AppColors.primaryLight,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Questionnaire',
                    style: GoogleFonts.workSans(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Selectionne ton niveau scolaire pour commencer',
                    style: GoogleFonts.workSans(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
                child: Column(
                  children: [
                    _LevelCard(
                      title: '3eme — BEPC',
                      subtitle:
                          'Tu prepares ou viens d\'avoir le BEPC',
                      icon: Icons.auto_stories_rounded,
                      primary: primary,
                      accent: accent,
                      surface: surface,
                      border: border,
                      textColor: textColor,
                      onTap: () => _selectLevel('3eme'),
                    ),
                    const SizedBox(height: 16),
                    _LevelCard(
                      title: 'Terminale — BAC',
                      subtitle:
                          'Tu prepares ou viens d\'avoir le BAC',
                      icon: Icons.emoji_events_rounded,
                      primary: accent,
                      accent: primary,
                      surface: surface,
                      border: border,
                      textColor: textColor,
                      onTap: () => _selectLevel('Terminale'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Ecran questions ────────────────────────────────────────────────

  Widget _buildQuestionScreen() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary =
        isDark ? AppColors.primaryDark : AppColors.primaryLight;
    final accent =
        isDark ? AppColors.accentDark : AppColors.accentLight;
    final bg =
        isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surface =
        isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border =
        isDark ? AppColors.borderDark : AppColors.borderLight;
    final textColor =
        isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight;
    final q = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceDark
                    : AppColors.primaryLight,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _back,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 16),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _selectedLevel,
                          style: GoogleFonts.workSans(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${_currentIndex + 1} / ${_questions.length}',
                        style: GoogleFonts.workSans(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 5,
                      backgroundColor:
                          Colors.white.withOpacity(0.2),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(accent),
                    ),
                  ),
                ],
              ),
            ),

            // Question card
            Expanded(
              child: SlideTransition(
                position: _slideAnim,
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Container(
                    margin:
                        const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: primary.withOpacity(0.09),
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                              child: Icon(q.icon,
                                  color: primary, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                q.text,
                                style: GoogleFonts.workSans(
                                  color: textColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Expanded(
                          child: ListView.separated(
                            physics:
                                const NeverScrollableScrollPhysics(),
                            itemCount: q.options.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (_, i) {
                              final sel =
                                  q.selectedIndex == i;
                              return GestureDetector(
                                onTap: () => _selectOption(i),
                                child: AnimatedContainer(
                                  duration: const Duration(
                                      milliseconds: 200),
                                  padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 14),
                                  decoration: BoxDecoration(
                                    color: sel
                                        ? primary
                                        : primary
                                            .withOpacity(0.04),
                                    borderRadius:
                                        BorderRadius.circular(14),
                                    border: Border.all(
                                      color: sel ? primary : border,
                                      width: sel ? 2 : 1,
                                    ),
                                    boxShadow: sel
                                        ? [
                                            BoxShadow(
                                              color: primary
                                                  .withOpacity(0.2),
                                              blurRadius: 10,
                                              offset:
                                                  const Offset(0, 4),
                                            )
                                          ]
                                        : [],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          q.options[i],
                                          style:
                                              GoogleFonts.workSans(
                                            color: sel
                                                ? Colors.white
                                                : textColor,
                                            fontSize: 13,
                                            fontWeight:
                                                FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      AnimatedContainer(
                                        duration: const Duration(
                                            milliseconds: 200),
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: sel
                                              ? Colors.white
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: sel
                                                ? Colors.white
                                                : border,
                                            width: 2,
                                          ),
                                        ),
                                        child: sel
                                            ? Icon(
                                                Icons.check_rounded,
                                                color: primary,
                                                size: 12)
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bouton suivant
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: ElevatedButton(
                onPressed: _canProceed ? _next : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  disabledBackgroundColor:
                      primary.withOpacity(0.25),
                  foregroundColor: Colors.white,
                  minimumSize:
                      const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: Text(
                  _currentIndex == _questions.length - 1
                      ? 'Voir mes recommandations'
                      : 'Suivant',
                  style: GoogleFonts.workSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Widgets ───────────────────────────────────────────────────────────────────

class _LevelCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color primary;
  final Color accent;
  final Color surface;
  final Color border;
  final Color textColor;
  final VoidCallback onTap;

  const _LevelCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.primary,
    required this.accent,
    required this.surface,
    required this.border,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: primary, size: 26),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.workSans(
                      color: primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.workSans(
                      color: textColor.withOpacity(0.5),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: primary, size: 16),
          ],
        ),
      ),
    );
  }
}