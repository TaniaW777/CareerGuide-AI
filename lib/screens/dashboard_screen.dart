import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/theme_provider.dart';
import 'profile_setup_screen.dart';
import 'advisor_chat_screen.dart';
import 'institutions_screen.dart';
import 'notifications_screen.dart';
import 'career_paths_screen.dart';
import 'series_guide_screen.dart';
import 'question_flow_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _progressAnimation = Tween<double>(begin: 0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOutQuart),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header
              Text('Bonjour,', style: TextStyle(fontSize: 16, color: isDark ? Colors.white60 : Colors.grey[600])),
              const SizedBox(height: 4),
              Text('Aminata Sawadogo', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
              const SizedBox(height: 4),
              Text('Terminale D - Ouagadougou', style: TextStyle(fontSize: 13, color: isDark ? Colors.white54 : Colors.grey[500])),
              const SizedBox(height: 24),

              // Circular Progress Card
              _buildProgressCircleCard(isDark),
              const SizedBox(height: 24),

              // Stats Row
              Row(
                children: [
                  Expanded(child: _buildStatCard(
                    icon: Icons.star,
                    iconBg: isDark ? const Color(0xFF1A3A5C) : const Color(0xFFE8F0FE),
                    iconColor: isDark ? const Color(0xFF64B5F6) : AppColors.primaryLight,
                    value: '3',
                    label: 'Filières recommandées',
                    isDark: isDark,
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard(
                    icon: Icons.school,
                    iconBg: isDark ? const Color(0xFF2D1A3A) : const Color(0xFFF3E8FF),
                    iconColor: isDark ? const Color(0xFFCE93D8) : const Color(0xFF7C3AED),
                    value: '5',
                    label: 'Établissements trouvés',
                    isDark: isDark,
                  )),
                ],
              ),
              const SizedBox(height: 16),

              // Alert Banner
              _buildNotificationBanner(isDark),
              const SizedBox(height: 28),

              // Actions rapides
              Text('Actions rapides', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
              const SizedBox(height: 16),

              // 2x2 Grid of quick actions
              Row(
                children: [
                  Expanded(child: _buildQuickAction(
                    icon: Icons.help,
                    label: 'Questionnaire',
                    subtitle: '5 questions',
                    iconBg: isDark ? const Color(0xFF1A3A5C) : const Color(0xFFE8F0FE),
                    iconColor: isDark ? const Color(0xFF64B5F6) : AppColors.primaryLight,
                    isDark: isDark,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuestionFlowScreen())),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: _buildQuickAction(
                    icon: Icons.star,
                    label: 'Mes reco.',
                    subtitle: 'Voir tout',
                    iconBg: isDark ? const Color(0xFF3D2E0A) : const Color(0xFFFFF8E1),
                    iconColor: isDark ? const Color(0xFFFFD54F) : const Color(0xFFE37B00),
                    isDark: isDark,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CareerPathsScreen())),
                  )),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildQuickAction(
                    icon: Icons.message,
                    label: 'Conseiller IA',
                    subtitle: 'Poser une question',
                    iconBg: isDark ? const Color(0xFF1A2A3A) : const Color(0xFFE0F2F1),
                    iconColor: isDark ? const Color(0xFF80CBC4) : const Color(0xFF00897B),
                    isDark: isDark,
                    onTap: () {}, // Handled by bottom nav or other action
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: _buildQuickAction(
                    icon: Icons.person,
                    label: 'Mon profil',
                    subtitle: 'Compléter',
                    iconBg: isDark ? const Color(0xFF2D1A3A) : const Color(0xFFF3E8FF),
                    iconColor: isDark ? const Color(0xFFCE93D8) : const Color(0xFF7C3AED),
                    isDark: isDark,
                    onTap: () {}, // Handled by bottom nav
                  )),
                ],
              ),
              const SizedBox(height: 28),

              // Prochaines échéances
              Text('Prochaines échéances', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
              const SizedBox(height: 16),
              _buildDeadlineItem('Dossier Université Ouaga I', '30 mai 2025', '18j', isDark),
              const SizedBox(height: 10),
              _buildDeadlineItem('Concours CFPR-Z Ziniaré', '15 juin 2025', '34j', isDark),
              const SizedBox(height: 28),

              // Commencer l'analyse - LAST element
              _buildAnalyseBanner(isDark),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Circular progress card with dual rings
  Widget _buildProgressCircleCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141E30) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: isDark ? Border.all(color: const Color(0xFF253545)) : null,
        boxShadow: isDark ? null : [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        children: [
          // The circular progress
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _DualRingPainter(
                      progress: _progressAnimation.value * 0.65,
                      outerColor: isDark ? const Color(0xFFE37B00) : const Color(0xFFE37B00),
                      innerColor: isDark ? const Color(0xFF4D86FF) : AppColors.primaryLight,
                      trackColor: isDark ? const Color(0xFF253545) : const Color(0xFFE8ECF0),
                      isDark: isDark,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(_progressAnimation.value * 65).toInt()}%',
                            style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'PROFIL COMPLÉTÉ',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: isDark ? Colors.white54 : Colors.grey[500]),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1A3A5C) : const Color(0xFFE8F0FE),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.verified, size: 14, color: isDark ? const Color(0xFF64B5F6) : AppColors.primaryLight),
                                const SizedBox(width: 4),
                                Text('Prêt', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF64B5F6) : AppColors.primaryLight)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendDot(const Color(0xFFE37B00), 'Orientation', isDark),
              const SizedBox(width: 20),
              _buildLegendDot(isDark ? const Color(0xFF4D86FF) : AppColors.primaryLight, 'Profil', isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label, bool isDark) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey[600])),
      ],
    );
  }

  Widget _buildStatCard({required IconData icon, required Color iconBg, required Color iconColor, required String value, required String label, required bool isDark}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: isDark ? Border.all(color: AppColors.borderDark) : null,
        boxShadow: isDark ? [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))] : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 14),
          Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildNotificationBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2210) : const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? const Color(0xFF5C4A1A) : const Color(0xFFFFE082)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: isDark ? const Color(0xFF3D2E0A) : const Color(0xFFFFECB3), borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.warning, color: isDark ? const Color(0xFFFFD54F) : Colors.amber[700], size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Concours MESRI - Dépôt de dossiers dans 18 jours - Vérifie tes documents !',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? const Color(0xFFFFE082) : Colors.amber[900], height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({required IconData icon, required String label, required String subtitle, required Color iconBg, required Color iconColor, required bool isDark, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isDark ? Border.all(color: AppColors.borderDark) : null,
          boxShadow: isDark ? [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 3))] : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.grey[500])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeadlineItem(String title, String date, String days, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: AppColors.borderDark) : null,
        boxShadow: isDark ? [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 3))] : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2210) : const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.event, color: isDark ? const Color(0xFFFFB74D) : const Color(0xFFE37B00), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
                const SizedBox(height: 2),
                Text(date, style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey[500])),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3D2E0A) : const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(days, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? const Color(0xFFFFB74D) : const Color(0xFFE37B00))),
          ),
        ],
      ),
    );
  }

  // Commencer l'analyse - bottom banner
  Widget _buildAnalyseBanner(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1A2A5C), const Color(0xFF0F1A40)]
              : [AppColors.primaryLight, const Color(0xFF1A56DB)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primaryLight.withOpacity(0.25), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.lightbulb, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text('Trouve ton orientation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Lance une analyse IA pour découvrir les meilleures filières pour toi.',
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileSetupScreen())),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryLight,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text('Commencer l\'analyse', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for dual-ring progress
class _DualRingPainter extends CustomPainter {
  final double progress;
  final Color outerColor;
  final Color innerColor;
  final Color trackColor;
  final bool isDark;

  _DualRingPainter({required this.progress, required this.outerColor, required this.innerColor, required this.trackColor, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2 - 8;
    final innerRadius = size.width / 2 - 28;
    const strokeWidth = 14.0;
    const startAngle = -math.pi / 2;

    // Outer track
    canvas.drawCircle(center, outerRadius, Paint()..color = trackColor..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round);
    // Inner track
    canvas.drawCircle(center, innerRadius, Paint()..color = trackColor..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round);

    // Outer progress (orange)
    final outerPaint = Paint()..color = outerColor..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: outerRadius), startAngle, 2 * math.pi * progress, false, outerPaint);

    // Inner progress (blue) - slightly less
    final innerPaint = Paint()..color = innerColor..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: innerRadius), startAngle, 2 * math.pi * (progress * 0.85), false, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _DualRingPainter oldDelegate) => oldDelegate.progress != progress;
}
