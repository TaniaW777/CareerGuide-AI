import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'main_navigation.dart';
import 'profile_setup_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      body: Stack(
        children: [
          // Blue Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.35,
            child: Container(
              color: AppColors.primaryLight,
              child: SafeArea(
                child: Center(
                  child: Hero(
                    tag: 'student_hero',
                    child: Image.asset(
                      'assets/images/student_hero_cutout_1777423096626.png',
                      height: size.height * 0.25,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Auth Card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: size.height * 0.7,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    // Pill Tabs
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildTab(
                              title: 'CONNEXION',
                              isActive: isLogin,
                              activeColor: Colors.white,
                              textColor: AppColors.primaryLight,
                              onTap: () => setState(() => isLogin = true),
                            ),
                          ),
                          Expanded(
                            child: _buildTab(
                              title: 'CREATION',
                              isActive: !isLogin,
                              activeColor: AppColors.accentLight,
                              textColor: Colors.white,
                              onTap: () => setState(() => isLogin = false),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Forms
                    if (isLogin) _buildLoginForm() else _buildRegisterForm(),

                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: () {
                        if (isLogin) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const MainNavigation()),
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
                          );
                        }
                      },
                      child: Text(isLogin ? 'SE CONNECTER' : 'CRÉER MON COMPTE'),
                    ),

                    const SizedBox(height: 16),
                    if (isLogin)
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Mot de passe oublié ?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          // Back Button
          Positioned(
            top: 48,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white24,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required String title,
    required bool isActive,
    required VoidCallback onTap,
    required Color activeColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isActive ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ] : null,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? textColor : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String hint, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          obscureText: isPassword,
          style: const TextStyle(color: Colors.black, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            fillColor: Colors.white,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        _buildField('Email', 'exemple@gmail.com'),
        const SizedBox(height: 24),
        _buildField('Mot de Passe', '********************', isPassword: true),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Mot de Passe oublié ?',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      children: [
        _buildField('Email', 'exemple@gmail.com'),
        const SizedBox(height: 24),
        _buildField('Mot de Passe', '********************', isPassword: true),
        const SizedBox(height: 24),
        _buildField('Confirmer Mot de Passe', '********************', isPassword: true),
      ],
    );
  }
}
