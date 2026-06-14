import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/theme_provider.dart';
import '../core/theme/notification_provider.dart';
import '../core/theme/connectivity_provider.dart';
import 'profile_screen.dart';
import 'annex_screens.dart';
import 'welcome_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir la langue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Français'),
              leading: Radio<String>(value: 'fr', groupValue: 'fr', onChanged: (v) {}),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('English'),
              leading: Radio<String>(value: 'en', groupValue: 'fr', onChanged: (v) {}),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Mooré'),
              leading: Radio<String>(value: 'moore', groupValue: 'fr', onChanged: (v) {}),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Dioula'),
              leading: Radio<String>(value: 'dioula', groupValue: 'fr', onChanged: (v) {}),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Paramètres des notifications mis à jour')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Paramètres', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionHeader('APPARENCE'),
          _buildSettingItem(
            context,
            isDark ? 'Mode sombre' : 'Mode clair',
            Icons.brightness_6_outlined,
            isDark ? AppColors.primaryLight : Colors.grey,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isDark ? 'Sombre' : 'Clair', style: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700], fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Switch.adaptive(
                  value: isDark,
                  onChanged: (v) => themeProvider.toggleTheme(),
                  activeColor: AppColors.primaryLight,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _sectionHeader('COMPTE'),
          _buildSettingItem(
            context, 
            'Modifier mon profil', 
            Icons.person_outline, 
            Colors.blue,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen(startEditing: true))),
          ),
          _buildSettingItem(context, 'Changer de mot de passe', Icons.lock_outline, Colors.orange, onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fonctionnalité bientôt disponible')));
          }),
          _buildSettingItem(
            context, 
            'Confidentialité', 
            Icons.security_outlined, 
            Colors.green,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SimpleTextScreen(
              title: 'Confidentialité',
              content: 'Votre vie privée et vos données sont protégées. Nous ne partageons vos données qu\'avec votre consentement pour vous fournir de meilleures recommandations.',
            ))),
          ),
          const SizedBox(height: 24),
          _sectionHeader('PRÉFÉRENCES'),
          _buildSettingItem(
            context, 
            'Centres d\'intérêt', 
            Icons.favorite_outline, 
            Colors.pink,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InterestsSettingsScreen())),
          ),
          _buildSettingItem(
            context, 
            'Langue', 
            Icons.language_outlined, 
            Colors.purple, 
            trailing: const Text('Français', style: TextStyle(color: Colors.grey)),
            onTap: () => _showLanguageDialog(context),
          ),
          Consumer<NotificationProvider>(
            builder: (context, notifyProvider, child) => _buildSettingItem(
              context, 
              'Notifications', 
              Icons.notifications_none_outlined, 
              Colors.red, 
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(notifyProvider.notificationsEnabled ? 'Activé' : 'Désactivé', style: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700], fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  Switch.adaptive(
                    value: notifyProvider.notificationsEnabled,
                    onChanged: (v) => notifyProvider.toggleNotifications(),
                    activeColor: AppColors.primaryLight,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _sectionHeader('CONNECTIVITÉ'),
          Consumer<ConnectivityProvider>(
            builder: (context, connectivityProvider, child) => _buildSettingItem(
              context,
              'Connexion IA',
              Icons.wifi_outlined,
              Colors.blueAccent,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    connectivityProvider.offlineFirstMode ? 'Hors-ligne' : 'Connecté',
                    style: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700], fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Switch.adaptive(
                    value: !connectivityProvider.offlineFirstMode,
                    onChanged: (v) async {
                      await connectivityProvider.setOfflineFirstMode(!v);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(v ? '🟢 Connecté au conseiller IA' : '🔴 Déconnecté (Mode Hors-ligne)')),
                        );
                      }
                    },
                    activeColor: AppColors.primaryLight,
                  ),
                ],
              ),
            ),
          ),
          Consumer<ConnectivityProvider>(
            builder: (context, connectivityProvider, child) => _buildSettingItem(
              context,
              connectivityProvider.connectionLabel,
              Icons.signal_cellular_alt,
              connectivityProvider.isConnected ? Colors.green : Colors.red,
              trailing: Text(
                connectivityProvider.isConnected ? 'Connecté' : 'Déconnecté',
                style: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700], fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                await connectivityProvider.forceCheckConnectivity();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✓ Connectivité vérifiée')),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 24),
          _sectionHeader('SUPPORT'),
          _buildSettingItem(
            context, 
            'Centre d\'aide', 
            Icons.help_outline, 
            Colors.teal,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SimpleTextScreen(
              title: 'Centre d\'aide',
              content: 'Si vous avez des difficultés, contactez notre équipe de support à support@careerguide.bf.',
            ))),
          ),
          _buildSettingItem(
            context, 
            'À propos de CareerGuide AI', 
            Icons.info_outline, 
            Colors.blueGrey,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SimpleTextScreen(
              title: 'À propos',
              content: 'CareerGuide AI v1.0.0\n\nCréé pour aider les étudiants du Burkina Faso à trouver leur voie professionnelle.',
            ))),
          ),
          const SizedBox(height: 40),
          Center(
            child: Text(
              'Version 1.0.0 (Build 2024)',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Déconnexion', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, String title, IconData icon, Color color, {Widget? trailing, VoidCallback? onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        trailing: trailing ?? const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
