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
  // Real user data from SharedPreferences
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
      _interests = prefs.getStringList('user_interests') ?? ['Sciences', 'Technologie'];
      
      // Update controllers
      _controllers.forEach((key, controller) {
        if (_userData.containsKey(key)) {
          controller.text = _userData[key]!;
        }
      });
      _isLoading = false;
    });
  }

  // Current recommended sector (influences the background)
  String _recommendedSector = 'Tech'; // Options: 'Tech', 'Agro', 'Health', 'Default'

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

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  LinearGradient _getHeaderGradient() {
    switch (_recommendedSector) {
      case 'Tech':
        return const LinearGradient(
          colors: [Color(0xFF1A56DB), Color(0xFF1E3A8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Agro':
        return const LinearGradient(
          colors: [Color(0xFF059669), Color(0xFF065F46)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Health':
        return const LinearGradient(
          colors: [Color(0xFFDC2626), Color(0xFF991B1B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [AppColors.primaryLight, AppColors.primaryLight.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Future<void> _saveEdits() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (final k in _controllers.keys) {
        if (_userData.containsKey(k)) {
          _userData[k] = _controllers[k]!.text;
          // Map internal keys to SharedPreferences keys
          String prefKey = 'user_$k';
          if (k == 'region') prefKey = 'user_ville';
          if (k == 'niveau') prefKey = 'user_classe';
          prefs.setString(prefKey, _controllers[k]!.text);
        }
      }
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil mis à jour ✓'), backgroundColor: AppColors.primaryLight),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subColor = isDark ? Colors.white70 : Colors.grey.shade600;
    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Mon Profil', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: _recommendedSector == 'Tech' ? const Color(0xFF1A56DB) : AppColors.primaryLight,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
        children: [
          // Header Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            decoration: BoxDecoration(
              gradient: _getHeaderGradient(),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              children: [
                // Avatar
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Accès à la galerie pour changer la photo...'),
                        backgroundColor: AppColors.primaryLight,
                      ),
                    );
                    // Mock update
                    Future.delayed(const Duration(seconds: 1), () {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Photo de profil mise à jour ✓')),
                        );
                      }
                    });
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        child: const Icon(Icons.person, size: 60, color: Colors.white),
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.accentLight,
                        child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${_userData['prenom']} ${_userData['nom']}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Recommandation: $_recommendedSector',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _statBadge('Niveau', _userData['niveau'] == 'Tle' ? 'Terminale' : (_userData['niveau'] ?? '-')),
                    const SizedBox(width: 20),
                    _statBadge('Région', _userData['region']?.split(' ').first ?? '-'),
                    const SizedBox(width: 20),
                    _statBadge('Âge', _userData['age'] ?? '-'),
                  ],
                ),
              ],
            ),
          ),

          Transform.translate(
            offset: const Offset(0, -20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Quick Action Cards
                  Row(
                    children: [
                      Expanded(
                        child: _actionCard(
                          context,
                          icon: Icons.quiz_outlined,
                          label: 'Questionnaire',
                          color: AppColors.primaryLight,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuestionFlowScreen())),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _actionCard(
                          context,
                          icon: Icons.auto_awesome,
                          label: 'Recommandations',
                          color: AppColors.accentLight,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CareerPathsScreen())),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Info Card
                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 16, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Informations personnelles', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                              IconButton(
                                icon: Icon(_isEditing ? Icons.close : Icons.edit_outlined, color: AppColors.primaryLight),
                                onPressed: () => setState(() => _isEditing = !_isEditing),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        _infoRow(context, Icons.person_outline, 'Nom', 'nom', textColor, subColor),
                        _infoRow(context, Icons.badge_outlined, 'Prénom', 'prenom', textColor, subColor),
                        _infoRow(context, Icons.calendar_today_outlined, 'Âge', 'age', textColor, subColor),
                        _infoRow(context, Icons.school_outlined, 'Niveau', 'niveau', textColor, subColor),
                        _infoRow(context, Icons.location_on_outlined, 'Région', 'region', textColor, subColor),
                        _infoRow(context, Icons.email_outlined, 'Email', 'email', textColor, subColor),
                        if (_isEditing)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: ElevatedButton.icon(
                              onPressed: _saveEdits,
                              icon: const Icon(Icons.save),
                              label: const Text('Sauvegarder'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryLight,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Profile actions
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.settings_outlined, color: AppColors.primaryLight),
                          ),
                          title: const Text('Paramètres', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: const Text('Gérer votre application et préférences'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.logout, color: Colors.red),
                          ),
                          title: const Text('Déconnexion', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: const Text('Retourner à l’écran d’accueil'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.clear();
                            if (mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                                (route) => false,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Interests
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Centres d\'intérêt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ['Sciences', 'Arts', 'Technologie', 'Santé', 'Social', 'Créatif'].map((interest) {
                            final isSelected = _interests.contains(interest);
                            return FilterChip(
                              label: Text(interest),
                              selected: isSelected,
                              onSelected: (v) {
                                setState(() {
                                  if (v) _interests.add(interest);
                                  else _interests.remove(interest);
                                });
                              },
                              selectedColor: AppColors.primaryLight.withValues(alpha: 0.15),
                              checkmarkColor: AppColors.primaryLight,
                              labelStyle: TextStyle(
                                color: isSelected ? AppColors.primaryLight : subColor,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
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

  Widget _statBadge(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
      ],
    );
  }

  Widget _actionCard(BuildContext context, {required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : Colors.black))),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, IconData icon, String label, String key, Color textColor, Color subColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: _isEditing
          ? TextField(
              controller: _controllers[key],
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey),
                prefixIcon: Icon(icon, color: AppColors.primaryLight),
                fillColor: isDark ? AppColors.surfaceDark : Colors.grey[50],
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            )
          : Row(
              children: [
                Icon(icon, size: 20, color: AppColors.primaryLight),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: TextStyle(fontSize: 11, color: subColor)),
                    const SizedBox(height: 2),
                    Text(_userData[key] ?? '-', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor)),
                  ],
                ),
              ],
            ),
    );
  }
}

