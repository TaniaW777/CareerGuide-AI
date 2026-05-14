import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/theme_provider.dart';
import 'institutions_screen.dart';
import 'notifications_screen.dart';
import 'career_paths_screen.dart';
import 'series_guide_screen.dart';
import 'university_fields_screen.dart';
import 'question_flow_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  String _userName = 'Utilisateur';
  String _userLevel = '3ème';
  String _userClassInfo = 'Chargement...';
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
    setState(() {
      _userName = '${prefs.getString('user_prenom') ?? ''} ${prefs.getString('user_nom') ?? ''}'.trim();
      if (_userName.isEmpty) _userName = 'Éleve';
      
      _userLevel = prefs.getString('user_classe') ?? '3ème';
      final serie = prefs.getString('user_serie') ?? '';
      final ville = prefs.getString('user_ville') ?? 'Burkina Faso';
      
      if (_userLevel == 'Tle') {
        _userClassInfo = 'Terminale $serie - $ville';
      } else if (_userLevel == '3ème') {
        _userClassInfo = 'Classe de 3ème - $ville';
      } else {
        final autre = prefs.getString('user_classe_autre') ?? '';
        _userClassInfo = '$autre - $ville';
      }
    });
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Header Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bonjour,', style: TextStyle(fontSize: 16, color: isDark ? AppColors.onSurfaceDark.withValues(alpha: 0.75) : Colors.grey[600])),
                      const SizedBox(height: 4),
                      Text(_userName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? AppColors.onSurfaceDark : AppColors.primaryLight)),
                    ],
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications_active_rounded, color: isDark ? AppColors.onSurfaceDark : Colors.black87, size: 28),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(color: isDark ? AppColors.accentDark : AppColors.primaryLight, shape: BoxShape.circle, border: Border.all(color: isDark ? AppColors.onSurfaceDark.withValues(alpha: 0.15) : Colors.white, width: 1.5)),
                          constraints: const BoxConstraints(minWidth: 10, minHeight: 10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(_userClassInfo, style: TextStyle(fontSize: 13, color: isDark ? AppColors.onSurfaceDark.withValues(alpha: 0.68) : Colors.grey[500])),
              const SizedBox(height: 24),

              // Circular Progress Card
              _buildProgressCircleCard(isDark),
              const SizedBox(height: 24),

              // Stats Row
              Row(
                children: [
                  Expanded(child: _buildStatCard(
                    icon: Icons.auto_awesome_rounded,
                    iconBg: isDark ? const Color(0xFF1A3A5C) : const Color(0xFFE8F0FE),
                    iconColor: isDark ? const Color(0xFF64B5F6) : AppColors.primaryLight,
                    value: _userLevel == '3ème' ? '4' : '3',
                    label: _userLevel == '3ème' ? 'Séries suggérées' : 'Filières recommandées',
                    isDark: isDark,
                    onTap: () => _showCardInfoDialog(
                      'Séries recommandées',
                      _userLevel == '3ème'
                          ? 'Ces séries sont suggérées en fonction de ton profil scolaire et de tes intérêts.'
                          : 'Ces filières sont recommandées selon ton niveau et tes réponses précédentes.',
                    ),
                  )),

                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard(
                    icon: Icons.school_rounded,
                    iconBg: isDark ? const Color(0xFF2D1A3A) : const Color(0xFFF3E8FF),
                    iconColor: isDark ? const Color(0xFFCE93D8) : const Color(0xFF7C3AED),
                    value: _userLevel == '3ème' ? '8' : '5',
                    label: _userLevel == '3ème' ? 'Lycées trouvés' : 'Établissements trouvés',
                    isDark: isDark,
                    onTap: () => _showCardInfoDialog(
                      'Établissements adaptés',
                      _userLevel == '3ème'
                          ? 'Voici les lycées qui correspondent le mieux à ton projet d’orientation.'
                          : 'Voici les établissements supérieurs les plus adaptés à ton profil.',
                    ),
                  )),

                ],
              ),
              const SizedBox(height: 16),

              // Alert Banner (Latest Notification Preview) - show MESRI details on tap
              GestureDetector(
                onTap: () => _showMesriDialog(),
                child: _buildNotificationBanner(isDark),
              ),
              const SizedBox(height: 28),

              // Actions rapides
              Text('Actions rapides', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
              const SizedBox(height: 16),

              // 1x2 Grid of quick actions
              Row(
                children: [
                  Expanded(child: _buildQuickAction(
                    icon: Icons.auto_awesome,
                    label: _userLevel == '3ème' ? 'Mes Séries' : 'Mes Reco.',
                    subtitle: _userLevel == '3ème' ? 'Séries recommandées' : 'Filières recommandées',
                    iconBg: isDark ? const Color(0xFF3D2E0A) : const Color(0xFFFFF8E1),
                    iconColor: isDark ? const Color(0xFFFFD54F) : const Color(0xFFE37B00),
                    isDark: isDark,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CareerPathsScreen(userLevel: _userLevel))),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: _buildQuickAction(
                    icon: Icons.explore_outlined,
                    label: _userLevel == '3ème' ? 'Guide des Séries' : 'Guide Métiers',
                    subtitle: 'Découverte',
                    iconBg: isDark ? const Color(0xFF1A2A3A) : const Color(0xFFE0F2F1),
                    iconColor: isDark ? const Color(0xFF80CBC4) : const Color(0xFF00897B),
                    isDark: isDark,
                    onTap: () {
                      if (_userLevel == 'Tle' || _userLevel == 'Tle') {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const UniversityFieldsScreen()));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SeriesGuideScreen()));
                      }
                    },
                  )),
                ],
              ),
              const SizedBox(height: 28),

              // Prochaines échéances
              Text('Prochaines échéances', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
              const SizedBox(height: 16),
              if (_userLevel == '3ème') ...[
                _buildDeadlineItem(
                'Dépôt dossiers Orientation',
                '10 juin 2025',
                '29j',
                isDark,
                Icons.description,
                onTap: () => _showCardInfoDialog(
                  'Dépôt dossiers Orientation',
                  'Prépare ton dossier d’orientation avant le 10 juin 2025 pour ne pas rater les inscriptions.',
                ),
              ),
                const SizedBox(height: 10),
                _buildDeadlineItem(
                  'Examens BEPC',
                  '02 juin 2025',
                  '21j',
                  isDark,
                  Icons.edit_document,
                  onTap: () => _showCardInfoDialog(
                    'Examens BEPC',
                    'Les examens approchent. Révise bien les matières principales pour réussir.',
                  ),
                ),
              ] else ...[
                _buildDeadlineItem(
                  'Dossier Université Ouaga I',
                  '30 mai 2025',
                  '18j',
                  isDark,
                  Icons.school,
                  onTap: () => _showCardInfoDialog(
                    'Dossier Université Ouaga I',
                    'Soumets ton dossier avant le 30 mai pour avoir une meilleure chance d’admission.',
                  ),
                ),
                const SizedBox(height: 10),
                _buildDeadlineItem(
                  'Concours CFPR-Z Ziniaré',
                  '15 juin 2025',
                  '34j',
                  isDark,
                  Icons.work_outline,
                  onTap: () => _showCardInfoDialog(
                    'Concours CFPR-Z Ziniaré',
                    'Prépare-toi pour le concours du CFPR-Z avec un plan de révision structuré.',
                  ),
                ),
              ],
              const SizedBox(height: 28),

              // Commencer l'analyse - LAST element
              _buildSmallOfflineIndicator(isDark),
              const SizedBox(height: 16),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: AppColors.borderDark) : null,
        boxShadow: isDark ? [BoxShadow(color: Colors.black.withValues(alpha: 0.14), blurRadius: 20, offset: const Offset(0, 8))] : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          // The circular progress (smaller)
          SizedBox(
            width: 90,
            height: 90,
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: _DualRingPainter(
                    progress: _progressAnimation.value * 0.65,
                    outerColor: AppColors.accentLight, // Gold
                    innerColor: AppColors.primaryLight, // Blue
                    trackColor: isDark ? AppColors.borderDark : const Color(0xFFE8ECF0),
                    isDark: isDark,
                  ),
                  child: Center(
                    child: Text(
                      '${(_progressAnimation.value * 65).toInt()}%',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? AppColors.onSurfaceDark : Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 20),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PROFIL COMPLÉTÉ',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: isDark ? AppColors.onSurfaceDark.withValues(alpha: 0.7) : Colors.grey[500]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ton dossier est presque prêt pour l\'analyse.',
                  style: TextStyle(fontSize: 13, color: isDark ? AppColors.onSurfaceDark : Colors.black87, height: 1.4),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildLegendDot(AppColors.accentLight, 'Orientation', isDark),
                    const SizedBox(width: 16),
                    _buildLegendDot(AppColors.primaryLight, 'Profil', isDark),
                  ],
                ),
              ],
            ),
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
        Text(label, style: TextStyle(fontSize: 12, color: isDark ? AppColors.onSurfaceDark.withValues(alpha: 0.72) : Colors.grey[600])),
      ],
    );
  }

  void _showCardInfoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showMesriDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Concours MESRI - Informations'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Date limite : 30 juin 2025'),
              SizedBox(height: 8),
              Text('Conditions : dossier scolaire, relevés de notes, lettre de motivation et pièces d\'identité.'),
              SizedBox(height: 8),
              Text('Comment se préparer : réviser les matières de base, suivre les annales et préparer un CV scolaire.'),
              SizedBox(height: 12),
              Text('''Informations pratiques :
• Lieu : Centres d'examen locaux
• Frais : gratuit ou faible selon l'année
• Contact : mesri@example.gov
'''),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                builder: (_) => Container(
                  padding: const EdgeInsets.all(20),
                  height: 220,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Dossier de candidature', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      const Text('''- Relevés de notes
- Lettre de motivation
- Pièce d'identité
- CV scolaire''', style: TextStyle(height: 1.6)),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Téléchargement du modèle de dossier (placeholder)')));
                          },
                          child: const Text('Télécharger le modèle de dossier'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: const Text('Voir dossier'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({required IconData icon, required Color iconBg, required Color iconColor, required String value, required String label, required bool isDark, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: isDark ? Border.all(color: AppColors.borderDark) : null,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.04), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 16),
            Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isDark ? AppColors.onSurfaceDark : Colors.black87)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: isDark ? AppColors.onSurfaceDark.withValues(alpha: 0.72) : Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryDark.withValues(alpha: 0.12) : const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.primaryDark.withValues(alpha: 0.22) : const Color(0xFFFFE082)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: isDark ? AppColors.accentDark.withValues(alpha: 0.18) : const Color(0xFFFFECB3), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.notifications_active_rounded, color: AppColors.accentDark, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Concours MESRI : ton dossier est en cours de préparation. Raison : ton profil correspond bien aux attentes du CIOSPB.',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppColors.onSurfaceDark.withValues(alpha: 0.88) : Colors.amber[900], height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallOfflineIndicator(bool isDark) {
    return GestureDetector(
      onTap: () => _showOfflineShareDialog(context, isDark),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.04), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, color: AppColors.accentLight, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mode hors-ligne actif', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.onSurfaceDark : Colors.black87)),
                  const SizedBox(height: 2),
                  Text('Recommandations accessibles localement', style: TextStyle(fontSize: 11, color: isDark ? AppColors.onSurfaceDark.withValues(alpha: 0.6) : Colors.grey[600])),
                ],
              ),
            ),
            Icon(Icons.share_outlined, size: 20, color: isDark ? AppColors.onSurfaceDark.withValues(alpha: 0.5) : Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showOfflineShareDialog(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: isDark ? Colors.white12 : Colors.grey[300], borderRadius: BorderRadius.circular(3)))),
            const SizedBox(height: 20),
            const Text('Partager sans connexion', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              'Cette option permet de simuler un partage local de l’application via Bluetooth ou Wi-Fi direct. Aucune donnée n’est envoyée sur Internet.',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade700, fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fonctionnalité de partage hors-ligne en préparation.')));
                    },
                    icon: const Icon(Icons.bluetooth),
                    label: const Text('Bluetooth'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryLight,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
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
          borderRadius: BorderRadius.circular(18),
          border: isDark ? Border.all(color: AppColors.borderDark) : Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.04), blurRadius: 14, offset: const Offset(0, 6))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? AppColors.onSurfaceDark : Colors.black87)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? AppColors.onSurfaceDark.withValues(alpha: 0.68) : Colors.grey[600], height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeadlineItem(String title, String date, String days, bool isDark, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: isDark ? Border.all(color: AppColors.borderDark) : Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.04), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.primaryDark.withValues(alpha: 0.18) : const Color(0xFFE8F0FE),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primaryDark, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? AppColors.onSurfaceDark : Colors.black87)),
                const SizedBox(height: 4),
                Text(date, style: TextStyle(fontSize: 12, color: isDark ? AppColors.onSurfaceDark.withValues(alpha: 0.6) : Colors.grey[500])),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? AppColors.accentDark.withValues(alpha: 0.18) : const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(days, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? AppColors.accentDark : const Color(0xFFE37B00))),
          ),
        ],
      ),
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
              ? [AppColors.primaryDark, AppColors.accentDark]
              : [AppColors.primaryLight, const Color(0xFF4B7BFE)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppColors.primaryDark.withValues(alpha: 0.16), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.psychology, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text('Trouve ton orientation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Lance une analyse IA pour découvrir les meilleures filières pour toi.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.88), fontSize: 13, height: 1.55),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuestionFlowScreen(selectedClasse: _userLevel))),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryDark,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
    final outerRadius = size.width / 2 - 4;
    final innerRadius = size.width / 2 - 14;
    const strokeWidth = 8.0;
    const startAngle = -math.pi / 2;

    // Outer track
    canvas.drawCircle(center, outerRadius, Paint()..color = trackColor..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round);
    // Inner track
    canvas.drawCircle(center, innerRadius, Paint()..color = trackColor..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round);

    // Outer progress
    final outerPaint = Paint()..color = outerColor..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: outerRadius), startAngle, 2 * math.pi * progress, false, outerPaint);

    // Inner progress
    final innerPaint = Paint()..color = innerColor..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: innerRadius), startAngle, 2 * math.pi * (progress * 0.85), false, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _DualRingPainter oldDelegate) => oldDelegate.progress != progress;
}
