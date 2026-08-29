import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/theme_provider.dart';
import '../services/user_data_service.dart';
import 'institutions_screen.dart';
import 'notifications_screen.dart';
import 'career_paths_screen.dart';
import 'series_guide_screen.dart';
import 'university_fields_screen.dart';
import 'question_flow_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  String _userName = 'Élève';
  String _userLevel = '3ème';
  String _userClassInfo = '';
  List<Map<String, dynamic>> _recommendations = [];
  int _profileCompletion = 0;
  bool _hasCompletedQuestionnaire = false;
  bool _isLoading = true;

  late AnimationController _animCtrl;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _progressAnim = Tween<double>(begin: 0, end: 1.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOutQuart),
    );
    _loadData();
  }

  Future<void> _loadData() async {
    final userDataService = UserDataService();

    // Profil
    final profile = await userDataService.getProfile();
    final name = profile['name'] ?? '';
    final region = profile['region'] ?? '';

    // Niveau
    final level = await userDataService.getUserLevel();

    // Recommandations
    final recs = await userDataService.getRecommendations();

    // Questionnaire
    final questionnaireCompleted =
        await userDataService.isQuestionnaireCompleted();

    // % profil dynamique
    final completion = await userDataService.getProfileCompletionPercent();

    if (!mounted) return;

    setState(() {
      _userName = name.isNotEmpty ? name : 'Élève';
      _userLevel = level;
      _recommendations = recs;
      _hasCompletedQuestionnaire = questionnaireCompleted;
      _profileCompletion = completion;

      // Info classe
      final regionStr = region.isNotEmpty ? region : 'Burkina Faso';
      if (level.contains('Terminale')) {
        _userClassInfo = 'Terminale — $regionStr';
      } else {
        _userClassInfo = '3ème — $regionStr';
      }

      _isLoading = false;
    });

    _animCtrl.forward();
  }

  // Navigue vers CareerPathsScreen avec les données réelles
  void _openRecommendations() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CareerPathsScreen(
          userLevel: _userLevel,
          recommendations: _recommendations,
        ),
      ),
    );
  }

  // Navigue vers InstitutionsScreen filtrée par filière recommandée
  void _openEtablissements() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const InstitutionsScreen()),
    );
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    if (_isLoading) {
      return Scaffold(
        backgroundColor:
            isDark ? AppColors.backgroundDark : const Color(0xFFF5F5F5),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF0F52BA)),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: const Color(0xFF0F52BA),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
                horizontal: 20.0, vertical: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ─────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bonjour,',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? AppColors.onSurfaceDark.withOpacity(0.75)
                                : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _userName,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.onSurfaceDark
                                : AppColors.primaryLight,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.notifications_active_rounded,
                        color: isDark ? AppColors.onSurfaceDark : Colors.black87,
                        size: 28,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const NotificationsScreen()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _userClassInfo,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.onSurfaceDark.withOpacity(0.6)
                        : Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Cercle profil ───────────────────────────────────────
                _buildProgressCard(isDark),
                const SizedBox(height: 20),

                // ── Stats ───────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.auto_awesome_rounded,
                        iconBg: isDark
                            ? const Color(0xFF1A3A5C)
                            : const Color(0xFFE8F0FE),
                        iconColor: isDark
                            ? const Color(0xFF64B5F6)
                            : AppColors.primaryLight,
                        value: _recommendations.isNotEmpty
                            ? _recommendations.length.toString()
                            : '0',
                        label: 'Filières recommandées',
                        isDark: isDark,
                        onTap: _recommendations.isNotEmpty
                            ? _openRecommendations
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.school_rounded,
                        iconBg: isDark
                            ? const Color(0xFF2D1A3A)
                            : const Color(0xFFF3E8FF),
                        iconColor: isDark
                            ? const Color(0xFFCE93D8)
                            : const Color(0xFF7C3AED),
                        value: _recommendations.isNotEmpty ? '8' : '0',
                        label: 'Établissements trouvés',
                        isDark: isDark,
                        onTap: _openEtablissements,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ── Filière top recommandée ─────────────────────────────
                if (_recommendations.isNotEmpty) ...[
                  _buildTopRecommendationCard(isDark),
                  const SizedBox(height: 24),
                ],

                // ── Actions rapides ─────────────────────────────────────
                Text(
                  'Actions rapides',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: _buildQuickAction(
                        icon: Icons.auto_awesome,
                        label: 'Mes Recommandations',
                        subtitle: 'Voir tes filières',
                        iconBg: isDark
                            ? const Color(0xFF3D2E0A)
                            : const Color(0xFFFFF8E1),
                        iconColor: isDark
                            ? const Color(0xFFFFD54F)
                            : const Color(0xFFE37B00),
                        isDark: isDark,
                        onTap: _openRecommendations,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickAction(
                        icon: Icons.explore_outlined,
                        label: _userLevel.contains('Terminale')
                            ? 'Guide Métiers'
                            : 'Guide des Séries',
                        subtitle: 'Découverte',
                        iconBg: isDark
                            ? const Color(0xFF1A2A3A)
                            : const Color(0xFFE0F2F1),
                        iconColor: isDark
                            ? const Color(0xFF80CBC4)
                            : const Color(0xFF00897B),
                        isDark: isDark,
                        onTap: () {
                          if (_userLevel.contains('Terminale')) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const UniversityFieldsScreen()),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SeriesGuideScreen()),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Bannière questionnaire si pas encore fait ───────────
                if (!_hasCompletedQuestionnaire) ...[
                  _buildQuestionnaireBanner(isDark),
                  const SizedBox(height: 20),
                ],

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Cercle progression profil ─────────────────────────────────────────────

  Widget _buildProgressCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.14 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            height: 90,
            child: AnimatedBuilder(
              animation: _progressAnim,
              builder: (context, child) => CustomPaint(
                painter: _DualRingPainter(
                  progress: _progressAnim.value * (_profileCompletion / 100),
                  outerColor: AppColors.accentLight,
                  innerColor: AppColors.primaryLight,
                  trackColor: isDark
                      ? AppColors.borderDark
                      : const Color(0xFFE8ECF0),
                  isDark: isDark,
                ),
                child: Center(
                  child: Text(
                    '$_profileCompletion%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.onSurfaceDark
                          : Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PROFIL COMPLÉTÉ',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: isDark
                        ? AppColors.onSurfaceDark.withOpacity(0.6)
                        : Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _profileCompletion == 100
                      ? 'Profil complet ✓'
                      : _hasCompletedQuestionnaire
                          ? 'Complète ton profil pour 100%'
                          : 'Réponds au questionnaire pour tes recommandations.',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.onSurfaceDark
                        : Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                // Indicateurs des étapes
                _buildProgressSteps(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSteps(bool isDark) {
    return Column(
      children: [
        _buildStep(
          label: 'Questionnaire',
          done: _hasCompletedQuestionnaire,
          isDark: isDark,
        ),
        const SizedBox(height: 4),
        _buildStep(
          label: 'Nom renseigné',
          done: _userName != 'Élève',
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildStep({
    required String label,
    required bool done,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: done
                ? const Color(0xFF0F52BA)
                : Colors.grey.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: done
              ? const Icon(Icons.check_rounded,
                  color: Colors.white, size: 10)
              : null,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: done
                ? (isDark ? Colors.white70 : Colors.black54)
                : Colors.grey,
            fontWeight:
                done ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  // ── Top recommandation ────────────────────────────────────────────────────

  Widget _buildTopRecommendationCard(bool isDark) {
    final top = _recommendations.first;
    final program = top['program'] as String? ?? '';
    final score = (top['score'] as num?)?.toInt() ?? 0;
    final schools = (top['schools'] as List?) ?? [];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F52BA), Color(0xFF4A90E2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F52BA).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.auto_awesome,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'Ta meilleure filière',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$score%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            program,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (schools.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              '📍 ${(schools.first as Map)['name']} — ${(schools.first as Map)['city']}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _openRecommendations,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Voir toutes mes recommandations',
                    style: TextStyle(
                      color: Color(0xFF0F52BA),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded,
                      color: Color(0xFF0F52BA), size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stat card ─────────────────────────────────────────────────────────────

  Widget _buildStatCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String value,
    required String label,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.18 : 0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: onTap != null
              ? Border.all(
                  color: const Color(0xFF0F52BA).withOpacity(0.15))
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 14),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.onSurfaceDark : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.onSurfaceDark.withOpacity(0.7)
                    : Colors.grey[600],
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(height: 8),
              Text(
                'Appuyer pour voir →',
                style: TextStyle(
                  fontSize: 10,
                  color: const Color(0xFF0F52BA).withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Quick action ──────────────────────────────────────────────────────────

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color iconBg,
    required Color iconColor,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.18 : 0.04),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isDark
                          ? AppColors.onSurfaceDark
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.onSurfaceDark.withOpacity(0.6)
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: isDark ? Colors.white30 : Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  // ── Bannière questionnaire ────────────────────────────────────────────────

  Widget _buildQuestionnaireBanner(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.primaryDark, AppColors.accentDark]
              : [AppColors.primaryLight, const Color(0xFF4B7BFE)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F52BA).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.psychology,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Trouve ton orientation',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Réponds au questionnaire pour découvrir les meilleures filières adaptées à ton profil.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const QuestionFlowScreen()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0F52BA),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Text(
                'Commencer maintenant',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Dual Ring Painter ─────────────────────────────────────────────────────────

class _DualRingPainter extends CustomPainter {
  final double progress;
  final Color outerColor;
  final Color innerColor;
  final Color trackColor;
  final bool isDark;

  const _DualRingPainter({
    required this.progress,
    required this.outerColor,
    required this.innerColor,
    required this.trackColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2 - 4;
    final innerRadius = size.width / 2 - 14;
    const strokeWidth = 8.0;
    const startAngle = -math.pi / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, outerRadius, trackPaint);
    canvas.drawCircle(center, innerRadius, trackPaint);

    if (progress > 0) {
      final outerPaint = Paint()
        ..color = outerColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerRadius),
        startAngle,
        2 * math.pi * progress,
        false,
        outerPaint,
      );

      final innerPaint = Paint()
        ..color = innerColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: innerRadius),
        startAngle,
        2 * math.pi * (progress * 0.85),
        false,
        innerPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DualRingPainter old) =>
      old.progress != progress;
}