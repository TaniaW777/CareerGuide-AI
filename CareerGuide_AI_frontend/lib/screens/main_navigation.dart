import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'dashboard_screen.dart';
import 'institutions_screen.dart';
import 'advisor_chat_screen.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';
import 'question_flow_screen.dart';
import '../widgets/mode_indicator_banner.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  Offset _aiButtonPosition = const Offset(-1, -1);

  late AnimationController _pulseController;
  late AnimationController _floatController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatAnimation;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const InstitutionsScreen(),
    const QuestionFlowScreen(),
    const ProfileScreen(),
  ];

  final List<String> _titles = [
    'TABLEAU DE BORD',
    'ÉTABLISSEMENTS',
    'ANALYSE IA',
    'MON PROFIL',
  ];

  @override
  void initState() {
    super.initState();

    // Pulse glow animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Floating up/down animation
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _openAdvisorChat() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => const AdvisorChatScreen(),
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(curved),
            child: FadeTransition(opacity: curved, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
        backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
      body: Column(
        children: [
          const ModeIndicatorBanner(),
          Expanded(
            child: Stack(
              children: [
                IndexedStack(
                  index: _currentIndex,
                  children: _pages,
                ),
          // Floating AI Button (Movable)
          Positioned(
            left: _aiButtonPosition.dx == -1 ? null : _aiButtonPosition.dx,
            top: _aiButtonPosition.dy == -1 ? null : _aiButtonPosition.dy,
            right: _aiButtonPosition.dx == -1 ? 16 : null,
            bottom: _aiButtonPosition.dy == -1 ? 24 : null,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  if (_aiButtonPosition.dx == -1) {
                    // Initial conversion from right/bottom to left/top
                    _aiButtonPosition = Offset(size.width - 116, size.height - 200); 
                  }
                  
                  double newX = _aiButtonPosition.dx + details.delta.dx;
                  double newY = _aiButtonPosition.dy + details.delta.dy;
                  
                  // Constrain to screen to prevent it from going out of bounds
                  newX = newX.clamp(0.0, size.width - 100);
                  newY = newY.clamp(0.0, size.height - 180);
                  
                  _aiButtonPosition = Offset(newX, newY);
                });
              },
              child: AnimatedBuilder(
                animation: Listenable.merge([_pulseAnimation, _floatController.isAnimating ? _floatAnimation : _floatAnimation]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatAnimation.value),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Label chip
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.18), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                            border: Border.all(color: isDark ? AppColors.primaryDark.withValues(alpha: 0.28) : AppColors.primaryLight.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.smart_toy_outlined, size: 14, color: isDark ? AppColors.primaryDark : AppColors.primaryLight),
                              const SizedBox(width: 6),
                              Text('Conseiller IA', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.primaryDark : AppColors.primaryLight)),
                            ],
                          ),
                        ),
                        // The main button
                        GestureDetector(
                          onTap: _openAdvisorChat,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer pulse glow
                              Container(
                                width: 100 + (_pulseAnimation.value * 24),
                                height: 100 + (_pulseAnimation.value * 24),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      (isDark ? AppColors.primaryDark : AppColors.primaryLight).withValues(alpha: 0.2 * (1 - _pulseAnimation.value)),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              // Shadow
                              Container(
                                width: 86,
                                height: 86,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(color: (isDark ? AppColors.primaryDark : AppColors.primaryLight).withValues(alpha: 0.4), blurRadius: 28, spreadRadius: 4, offset: const Offset(0, 8)),
                                  ],
                                ),
                              ),
                              // Button body
                              Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: isDark
                                        ? [AppColors.primaryDark, AppColors.secondaryDark]
                                        : [AppColors.primaryLight, const Color(0xFF1976D2)],
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Sparkle icon
                                    const Icon(Icons.auto_awesome, color: Colors.white, size: 42),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      ),
      ],
    ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        selectedItemColor: isDark ? AppColors.accentDark : AppColors.primaryLight,
        unselectedItemColor: isDark ? AppColors.onSurfaceDark.withValues(alpha: 0.55) : Colors.grey,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'DASHBOARD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'ÉTABLISSEMENTS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology_outlined),
            activeIcon: Icon(Icons.psychology),
            label: 'ANALYSE IA',
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
}
