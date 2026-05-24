import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_colors.dart';
import 'question_flow_screen.dart';
import 'career_paths_screen.dart';
import 'settings_screen.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool startEditing;
  const ProfileScreen({super.key, this.startEditing = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, String> _userData = {
    'nom': '',
    'prenom': '',
    'age': '',
    'niveau': '',
    'region': '',
    'email': '',
    'objectif': 'Orientation scolaire',
  };

  List<String> _interests = [];
  bool _isLoading = true;
  String _recommendedSector = 'Technologie';

  bool _isEditing = false;
  late Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.startEditing;
    _controllers = {
      'nom': TextEditingController(),
      'prenom': TextEditingController(),
      'age': TextEditingController(),
      'niveau': TextEditingController(),
      'region': TextEditingController(),
      'email': TextEditingController(),
    };
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userData = {
        'nom': prefs.getString('user_nom') ?? 'Kaboré',
        'prenom': prefs.getString('user_prenom') ?? 'Aminata',
        'age': prefs.getString('user_age') ?? '18',
        'niveau': prefs.getString('user_classe') ?? 'Terminale',
        'region': prefs.getString('user_ville') ?? 'Ouagadougou',
        'email': prefs.getString('user_email') ?? 'etudiant@example.com',
        'objectif': prefs.getString('user_objectif') ?? 'Orientation scolaire',
      };
      _interests = prefs.getStringList('user_interests') ?? ['Sciences', 'Technologie', 'Santé'];
      _recommendedSector = prefs.getString('user_sector') ?? 'Technologie';
      
      _controllers.forEach((key, controller) {
        if (_userData.containsKey(key)) {
          controller.text = _userData[key]!;
        }
      });
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _saveEdits() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (final k in _controllers.keys) {
        if (_userData.containsKey(k)) {
          _userData[k] = _controllers[k]!.text;
          String prefKey = 'user_$k';
          if (k == 'region') prefKey = 'user_ville';
          if (k == 'niveau') prefKey = 'user_classe';
          prefs.setString(prefKey, _controllers[k]!.text);
        }
      }
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil mis à jour ✓'),
        backgroundColor: AppColors.primaryLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF1F5F9),
      body: CustomScrollView(
        slivers: [
          // Dynamic Header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.primaryLight,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient Background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryLight,
                          AppColors.primaryLight.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // Abstract decorative shapes
                  Positioned(
                    top: -50,
                    right: -50,
                    child: CircleAvatar(radius: 100, backgroundColor: Colors.white.withValues(alpha: 0.05)),
                  ),
                  // Profile Content
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: CircleAvatar(
                                radius: 45, // Slightly smaller to avoid overflow
                                backgroundColor: AppColors.accentLight.withValues(alpha: 0.2),
                                child: const Icon(Icons.person_rounded, size: 55, color: AppColors.primaryLight),
                              ),
                            ),
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: AppColors.accentLight,
                              child: const Icon(Icons.edit, size: 12, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_userData['prenom']} ${_userData['nom']}',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        // Stats Row
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _headerStat('Âge', _userData['age']!),
                              _verticalDivider(),
                              _headerStat('Niveau', _userData['niveau'] == 'Tle' ? 'Terminale' : _userData['niveau']!),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section: Career Badge
                  _sectionTitle('Domaine Recommandé'),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.accentLight, AppColors.accentLight.withValues(alpha: 0.8)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: AppColors.accentLight.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('ANALYSE IA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.2)),
                              Text(
                                _recommendedSector,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CareerPathsScreen())),
                          style: TextButton.styleFrom(backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          child: const Text('Détails', style: TextStyle(color: AppColors.accentLight, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Section: Personal Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _sectionTitle('Informations'),
                      TextButton.icon(
                        onPressed: () => setState(() => _isEditing = !_isEditing),
                        icon: Icon(_isEditing ? Icons.close : Icons.edit_rounded, size: 18),
                        label: Text(_isEditing ? 'Annuler' : 'Modifier'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _infoCard(cardColor, isDark),

                  const SizedBox(height: 24),

                  // Section: Interests
                  _sectionTitle('Centres d\'intérêt'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _interests.map((interest) => Chip(
                      label: Text(interest),
                      backgroundColor: AppColors.primaryLight.withValues(alpha: 0.1),
                      side: BorderSide.none,
                      labelStyle: const TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.w600, fontSize: 13),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    )).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Section: Account Actions
                  _sectionTitle('Compte'),
                  const SizedBox(height: 12),
                  _menuItem(context, Icons.settings_rounded, 'Paramètres', 'Sécurité et préférences', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
                  const SizedBox(height: 12),
                  _menuItem(context, Icons.logout_rounded, 'Déconnexion', 'Quitter la session actuelle', _handleLogout, isDestructive: true),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(height: 30, width: 1, color: Colors.white.withValues(alpha: 0.2));
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryLight),
    );
  }

  Widget _infoCard(Color cardColor, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          _infoTile(Icons.person_rounded, 'Nom', 'nom', isLast: false),
          _infoTile(Icons.badge_rounded, 'Prénom', 'prenom', isLast: false),
          _infoTile(Icons.email_rounded, 'Email', 'email', isLast: true),
          if (_isEditing)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _saveEdits,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Sauvegarder les modifications', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String key, {required bool isLast}) {
    final value = _userData[key] ?? '-';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.primaryLight.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: AppColors.primaryLight),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _isEditing
                ? TextField(
                    controller: _controllers[key],
                    decoration: InputDecoration(labelText: label, border: InputBorder.none, isDense: true),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 2),
                      Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap, {bool isDestructive = false}) {
    final color = isDestructive ? Colors.red : AppColors.primaryLight;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDestructive ? Colors.red : Colors.black87)),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: isDestructive ? Colors.red.withValues(alpha: 0.7) : Colors.grey)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: color.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        (route) => false,
      );
    }
  }
}
