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
  Map<String, String> _userData = {};
  List<String> _interests = [];
  bool _isLoading = true;
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
        'nom': prefs.getString('user_nom') ?? '',
        'prenom': prefs.getString('user_prenom') ?? '',
        'age': prefs.getString('user_age') ?? '',
        'niveau': prefs.getString('user_classe') ?? '',
        'region': prefs.getString('user_ville') ?? '',
        'email': prefs.getString('user_email') ?? '',
        'objectif': 'Orientation scolaire',
      };

      _interests = prefs.getStringList('user_interests') ?? [];

      // Remplir les controllers
      _controllers.forEach((key, controller) {
        controller.text = _userData[key] ?? '';
      });

      _isLoading = false;
    });
  }

  Future<void> _saveEdits() async {
    final prefs = await SharedPreferences.getInstance();

    for (final entry in _controllers.entries) {
      final value = entry.value.text.trim();
      _userData[entry.key] = value;

      String prefKey = 'user_${entry.key}';
      if (entry.key == 'region') prefKey = 'user_ville';
      if (entry.key == 'niveau') prefKey = 'user_classe';

      await prefs.setString(prefKey, value);
    }

    await prefs.setStringList('user_interests', _interests);

    setState(() => _isEditing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil mis à jour avec succès'),
        backgroundColor: AppColors.primaryLight,
      ),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers.values) c.dispose();
    super.dispose();
  }

  LinearGradient _getHeaderGradient() {
    return const LinearGradient(
      colors: [Color(0xFF1A56DB), Color(0xFF0F52BA)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subColor = isDark ? Colors.white70 : Colors.grey.shade600;
    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;

    final fullName = "${_userData['prenom'] ?? ''} ${_userData['nom'] ?? ''}".trim();
    final displayName = fullName.isEmpty ? "Utilisateur" : fullName;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Mon Profil', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A56DB),
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
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
              decoration: BoxDecoration(
                gradient: _getHeaderGradient(),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Photo de profil (fonctionnalité future)')),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 52,
                          backgroundColor: Colors.white.withOpacity(0.2),
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
                    displayName,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _statBadge('Niveau', _userData['niveau']?.isNotEmpty == true ? _userData['niveau']! : '-'),
                      const SizedBox(width: 20),
                      _statBadge('Région', _userData['region']?.isNotEmpty == true ? _userData['region']! : '-'),
                      const SizedBox(width: 20),
                      _statBadge('Âge', _userData['age']?.isNotEmpty == true ? _userData['age']! : '-'),
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
                    // Quick Actions
                    Row(
                      children: [
                        Expanded(
                          child: _actionCard(
                            icon: Icons.quiz_outlined,
                            label: 'Refaire le questionnaire',
                            color: AppColors.primaryLight,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuestionFlowScreen())),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _actionCard(
                            icon: Icons.auto_awesome,
                            label: 'Mes recommandations',
                            color: AppColors.accentLight,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CareerPathsScreen())),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Informations personnelles
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 4))],
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
                          _infoRow(Icons.person_outline, 'Nom', 'nom', textColor, subColor),
                          _infoRow(Icons.badge_outlined, 'Prénom', 'prenom', textColor, subColor),
                          _infoRow(Icons.calendar_today_outlined, 'Âge', 'age', textColor, subColor),
                          _infoRow(Icons.school_outlined, 'Niveau', 'niveau', textColor, subColor),
                          _infoRow(Icons.location_on_outlined, 'Région / Ville', 'region', textColor, subColor),
                          _infoRow(Icons.email_outlined, 'Email', 'email', textColor, subColor),

                          if (_isEditing)
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: ElevatedButton.icon(
                                onPressed: _saveEdits,
                                icon: const Icon(Icons.save),
                                label: const Text('Sauvegarder les modifications'),
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

                    // Centres d'intérêt
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Centres d\'intérêt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: ['Sciences', 'Technologie', 'Santé', 'Business', 'Agriculture', 'Arts'].map((interest) {
                              final isSelected = _interests.contains(interest);
                              return FilterChip(
                                label: Text(interest),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) _interests.add(interest);
                                    else _interests.remove(interest);
                                  });
                                },
                                selectedColor: AppColors.primaryLight.withOpacity(0.15),
                                checkmarkColor: AppColors.primaryLight,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Autres actions
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: AppColors.primaryLight.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.settings_outlined, color: AppColors.primaryLight),
                            ),
                            title: const Text('Paramètres'),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.logout, color: Colors.red),
                            ),
                            title: const Text('Retour à l\'accueil'),
                            onTap: () async {
                              final prefs = await SharedPreferences.getInstance();
                              // Ne pas tout clear si tu veux garder les réponses du questionnaire
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                                (route) => false,
                              );
                            },
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
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _actionCard({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String key, Color textColor, Color subColor) {
    final controller = _controllers[key];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: _isEditing
          ? TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                prefixIcon: Icon(icon, color: AppColors.primaryLight),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                    Text(_userData[key]?.isNotEmpty == true ? _userData[key]! : '-', 
                         style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor)),
                  ],
                ),
              ],
            ),
    );
  }
}