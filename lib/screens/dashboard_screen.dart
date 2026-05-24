import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/theme_provider.dart';
import '../core/theme/notification_provider.dart';
import '../core/theme/connectivity_provider.dart';
import 'institutions_screen.dart';
import 'notifications_screen.dart';
import 'career_paths_screen.dart';
import 'series_guide_screen.dart';
import 'university_fields_screen.dart';
import 'question_flow_screen.dart';
import 'profile_screen.dart';
import '../services/local_ia/local_ai_service.dart';
import '../core/widgets/app_button.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  String _userName = 'Utilisateur';
  String _userLevel = '3ème';
  String _userClassInfo = 'Chargement...';
  List<Map<String, dynamic>> _recommendations = [];
  bool _isLoading = true;
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
    _loadUserData();
    _animationController.forward();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    
    final profile = {
      'first_name': prefs.getString('user_prenom') ?? 'Étudiant',
      'class_level': prefs.getString('user_classe') ?? '3ème',
      'stream': prefs.getString('user_serie') ?? '',
      'favorite_subjects': prefs.getStringList('user_subjects') ?? [],
      'interests': prefs.getStringList('user_interests') ?? [],
    };

    setState(() {
      _userName = '${prefs.getString('user_prenom') ?? ''} ${prefs.getString('user_nom') ?? ''}'.trim();
      if (_userName.isEmpty) _userName = 'Élève';
      
      _userLevel = profile['class_level'] as String;
      final serie = profile['stream'] as String;
      final ville = prefs.getString('user_ville') ?? 'Burkina Faso';
      
      if (_userLevel == 'Tle') {
        _userClassInfo = 'Terminale $serie · $ville';
      } else if (_userLevel == '3ème') {
        _userClassInfo = 'Classe de 3ème · $ville';
      } else {
        final autre = prefs.getString('user_classe_autre') ?? '';
        _userClassInfo = '$autre · $ville';
      }
    });

    try {
        final connectivity = Provider.of<ConnectivityProvider>(context, listen: false);
        final useOnline = connectivity.isConnected && !connectivity.offlineFirstMode;
        final results = await LocalAIService.getRecommendations(profile, onlineMode: useOnline);
        if (mounted) {
          setState(() {
            _recommendations = List<Map<String, dynamic>>.from(results['recommendations'] ?? []);
            _isLoading = false;
          });
        }
    } catch (e) {
      debugPrint('Error getting local recommendations: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showQuickNotify(BuildContext context, String message) {
    final notifyProvider = Provider.of<NotificationProvider>(context, listen: false);
    if (notifyProvider.notificationsEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subColor = isDark ? AppColors.onSurfaceVariantDark : Colors.white70;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC),
        elevation: 0,
        leadingWidth: 140,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 12, bottom: 12),
          child: Row(
            children: [
              Icon(Icons.auto_awesome, color: isDark ? AppColors.accentDark : AppColors.primaryLight, size: 24),
              const SizedBox(width: 8),
              Text('CareerGuide', style: TextStyle(
                color: isDark ? Colors.white : AppColors.primaryLight,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              )),
            ],
          ),
        ),
        actions: [
          _buildNotificationIcon(isDark),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- PREMIUM BANNER (EPUREE) ---
              _buildPremiumBanner(isDark, subColor),
              const SizedBox(height: 28),

              // Progress Circle Card
              _buildProgressCircleCard(isDark),
              const SizedBox(height: 24),

              // Quick Stats Row
              Row(
                children: [
                  Expanded(child: _buildStatCard(
                    icon: Icons.auto_awesome_rounded,
                    iconBg: (isDark ? AppColors.accentDark : AppColors.accentLight).withValues(alpha: 0.15),
                    iconColor: isDark ? AppColors.accentDark : const Color(0xFFD97706),
                    value: _userLevel == '3ème' ? '4' : '3',
                    label: 'Séries suggérées',
                    isDark: isDark,
                  )),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard(
                    icon: Icons.school_rounded,
                    iconBg: (isDark ? AppColors.primaryDark : AppColors.primaryLight).withValues(alpha: 0.15),
                    iconColor: isDark ? AppColors.primaryDark : AppColors.primaryLight,
                    value: _userLevel == '3ème' ? '12' : '8',
                    label: 'Écoles trouvées',
                    isDark: isDark,
                  )),
                ],
              ),
              const SizedBox(height: 32),

              // Actions
              const Text('Actions recommandées', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_recommendations.isEmpty)
                _buildQuickAction(
                  icon: Icons.psychology_outlined,
                  label: 'Relancer l\'analyse IA',
                  subtitle: 'Mettre à jour tes recommandations',
                  color: AppColors.primaryLight,
                  isDark: isDark,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuestionFlowScreen(selectedClasse: _userLevel))),
                )
              else
                ..._recommendations.map((rec) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildQuickAction(
                    icon: Icons.auto_awesome,
                    label: rec['program'],
                    subtitle: 'Score de match: ${rec['score']}%',
                    color: AppColors.primaryLight,
                    isDark: isDark,
                    onTap: () => _showQuickNotify(context, 'Analyse des écoles pour ${rec['program']}...'),
                  ),
                )),
              const SizedBox(height: 12),
              _buildQuickAction(
                icon: Icons.map_outlined,
                label: 'Explorer les métiers',
                subtitle: 'Découvrir les débouchés réels',
                color: AppColors.secondaryLight,
                isDark: isDark,
                onTap: () => _showQuickNotify(context, 'Guide des métiers en cours de chargement...'),
              ),
              const SizedBox(height: 32),

              // Alert Banner
              const Text('Dernière alerte', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildNotificationBanner(isDark, context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      // AI ADVISOR BUTTON REMOVED
      );
      }

  Widget _buildNotificationIcon(bool isDark) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, size: 28),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
        ),
        Positioned(
          right: 12,
          top: 12,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
              border: Border.all(color: isDark ? AppColors.backgroundDark : Colors.white, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumBanner(bool isDark, Color subColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark 
            ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
            : [AppColors.primaryLight, const Color(0xFF1E40AF)],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : AppColors.primaryLight).withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bonjour 👋', style: TextStyle(fontSize: 16, color: subColor, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(_userName, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.school_outlined, color: Colors.white, size: 14),
                const SizedBox(width: 8),
                Text(_userClassInfo, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCircleCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: _DualRingPainter(
                    progress: _progressAnimation.value * 0.75,
                    outerColor: isDark ? AppColors.accentDark : AppColors.accentLight,
                    innerColor: isDark ? AppColors.primaryDark : AppColors.primaryLight,
                    trackColor: isDark ? AppColors.borderDark : const Color(0xFFF1F5F9),
                  ),
                  child: Center(
                    child: Text(
                      '${(_progressAnimation.value * 75).toInt()}%',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ANALYSE DU PROFIL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: AppColors.accentLight)),
                const SizedBox(height: 6),
                const Text('Dossier complet à 75%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Ajoute tes matières préférées pour affiner le résultat.', style: TextStyle(fontSize: 12, color: isDark ? AppColors.onSurfaceVariantDark : Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({required IconData icon, required Color iconBg, required Color iconColor, required String value, required String label, required bool isDark}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.transparent),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: isDark ? AppColors.onSurfaceVariantDark : Colors.grey[600], height: 1.2)),
        ],
      ),
    );
  }

  Widget _buildQuickAction({required IconData icon, required String label, required String subtitle, required Color color, required bool isDark, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? AppColors.onSurfaceVariantDark : Colors.grey[600])),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: isDark ? Colors.white24 : Colors.grey[300]),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationBanner(bool isDark, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1B4B) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.blue.withValues(alpha: 0.2) : Colors.blue.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.blue, size: 24),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Concours d\'excellence : les inscriptions sont ouvertes jusqu\'au 15 juin.',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, height: 1.4),
            ),
          ),
          TextButton(
            onPressed: () => _showQuickNotify(context, 'Ouverture du portail MESRI...'),
            child: const Text('Détails'),
          ),
        ],
      ),
    );
  }
}

class _DualRingPainter extends CustomPainter {
  final double progress;
  final Color outerColor;
  final Color innerColor;
  final Color trackColor;

  _DualRingPainter({required this.progress, required this.outerColor, required this.innerColor, required this.trackColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2 - 4;
    final innerRadius = size.width / 2 - 12;
    const strokeWidth = 6.0;
    final startAngle = -math.pi / 2;

    final trackPaint = Paint()..color = trackColor..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, outerRadius, trackPaint);
    canvas.drawCircle(center, innerRadius, trackPaint);

    final outerPaint = Paint()..color = outerColor..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: outerRadius), startAngle, 2 * math.pi * progress, false, outerPaint);

    final innerPaint = Paint()..color = innerColor..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: innerRadius), startAngle, 2 * math.pi * (progress * 0.8), false, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _DualRingPainter oldDelegate) => oldDelegate.progress != progress;
}
