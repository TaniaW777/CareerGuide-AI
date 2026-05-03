import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/theme_provider.dart';
import 'dashboard_screen.dart';
import 'institutions_screen.dart';
import 'advisor_chat_screen.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';
import 'question_flow_screen.dart';
import 'career_paths_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const AdvisorChatScreen(),
    const InstitutionsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0 ? 'TABLEAU DE BORD' : _currentIndex == 1 ? 'CONSEILLER' : _currentIndex == 2 ? 'ÉTABLISSEMENTS' : 'MON PROFIL',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
            onPressed: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen())),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        selectedItemColor: isDark ? AppColors.primaryDark : AppColors.primaryLight,
        unselectedItemColor: isDark ? Colors.white38 : Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'DASHBOARD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'CONSEILLER',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'ÉTABLISSEMENTS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'PROFIL',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      child: Container(
        color: isDark ? AppColors.backgroundDark : Colors.white,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 3); // Go to Profile tab
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 60, bottom: 30, left: 24, right: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark 
                      ? [AppColors.surfaceDark, AppColors.backgroundDark]
                      : [AppColors.primaryLight, AppColors.primaryLight.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5)),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, size: 40, color: AppColors.primaryLight),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.accentLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Jean Traoré', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
                    const SizedBox(height: 4),
                    Text('jean.traore@email.bf', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildDrawerItem(context, icon: Icons.dashboard_outlined, title: 'Dashboard', onTap: () {
                    Navigator.pop(context);
                    setState(() => _currentIndex = 0);
                  }, isDark: isDark),
                  _buildDrawerItem(context, icon: Icons.quiz_outlined, title: 'Configuration du Profil', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const QuestionFlowScreen()));
                  }, isDark: isDark),
                  _buildDrawerItem(context, icon: Icons.auto_awesome, title: 'Mes Recommandations', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CareerPathsScreen()));
                  }, isDark: isDark),
                  _buildDrawerItem(context, icon: Icons.notifications_none, title: 'Notifications', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
                  }, isDark: isDark),
                  _buildDrawerItem(context, icon: Icons.settings_outlined, title: 'Paramètres', onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
                  }, isDark: isDark),
                ],
              ),
            ),
            const Divider(indent: 24, endIndent: 24),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildDrawerItem(context, icon: Icons.logout, title: 'Déconnexion', isDestructive: true, onTap: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }, isDark: isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap, required bool isDark, bool isDestructive = false}) {
    final color = isDestructive ? Colors.redAccent : (isDark ? Colors.white70 : Colors.black87);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isDestructive ? Colors.redAccent.withOpacity(0.1) : Colors.transparent,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive ? Colors.transparent : (isDark ? Colors.white10 : Colors.grey.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(title, style: TextStyle(color: color, fontWeight: isDestructive ? FontWeight.bold : FontWeight.w600, fontSize: 15)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onTap: onTap,
        hoverColor: isDark ? Colors.white10 : Colors.grey.withOpacity(0.05),
      ),
    );
  }
}
