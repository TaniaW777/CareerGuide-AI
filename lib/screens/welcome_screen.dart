import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'profile_setup_screen.dart';
import 'main_navigation.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F52BA), // Top deep blue
              Color(0xFF4A90E2), // Lighter blue
              Color(0xFFF0F4F8), // Transition to light gray/white
              Colors.white,
              Colors.white,
            ],
            stops: [0.0, 0.35, 0.55, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Main Image
                SizedBox(
                  height: size.height * 0.45,
                  child: Image.asset(
                    'assets/images/home_image.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: size.height * 0.45,
                      alignment: Alignment.center,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported, size: 80, color: Colors.black26),
                          SizedBox(height: 10),
                          Text('Veuillez ajouter home_image.png\ndans assets/images/', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Title
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'CareerGuide ',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: const Color(0xFF0F52BA), // Dark blue matching the text in the screenshot
                              fontWeight: FontWeight.w800,
                              fontSize: 28,
                            ),
                      ),
                      TextSpan(
                        text: 'AI',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: const Color(0xFFFF9800), // Orange matching the screenshot
                              fontWeight: FontWeight.w800,
                              fontSize: 28,
                            ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Subtitle text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    'Ton avenir commence ici! Ton guide simple\nPour choisir ta voie apres le BEPC ou le BAC\nBURKINA FASO',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileSetupScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F52BA), // Deep blue
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Commencer',
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Se connecter link
                GestureDetector(
                  onTap: () {
                    // Navigate to the main application directly or a login screen
                    // Currently using MainNavigation as a placeholder for logged in state
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainNavigation(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Déjà inscrit ? ',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        'Se connecter',
                        style: TextStyle(
                          color: Color(0xFF0F52BA),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF0F52BA),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
