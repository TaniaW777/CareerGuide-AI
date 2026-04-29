import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'question_flow_screen.dart';
import 'career_paths_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock user data (to be replaced by real persistence later)
  final Map<String, String> _userData = {
    'nom': 'Kaboré',
    'prenom': 'Aminata',
    'age': '18',
    'niveau': 'Terminale',
    'region': 'Centre (Ouagadougou)',
    'email': 'aminata@example.com',
    'objectif': 'Orientation scolaire',
  };

  final List<String> _interests = ['Sciences', 'Technologie', 'Santé'];

  bool _isEditing = false;
  late Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = _userData.map((k, v) => MapEntry(k, TextEditingController(text: v)));
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _saveEdits() {
    setState(() {
      for (final k in _userData.keys) {
        _userData[k] = _controllers[k]!.text;
      }
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil mis à jour ✓'), backgroundColor: AppColors.primaryLight),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subColor = isDark ? Colors.white70 : Colors.grey.shade600;
    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          // Header Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryLight, AppColors.primaryLight.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                // Avatar
                Stack(
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
                const SizedBox(height: 12),
                Text(
                  '${_userData['prenom']} ${_userData['nom']}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  _userData['niveau'] ?? '',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _statBadge('Niveau', _userData['niveau'] ?? '-'),
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
                          label: 'Mes Recommandations',
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: _isEditing
          ? TextField(
              controller: _controllers[key],
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: label,
                prefixIcon: Icon(icon, color: AppColors.primaryLight),
                fillColor: Colors.white,
                filled: true,
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
