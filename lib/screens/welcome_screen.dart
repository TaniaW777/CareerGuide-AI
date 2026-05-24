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
                SizedBox(
                  width: size.width * 0.7, // Ajustement de la largeur (70% de l'écran)
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileSetupScreen(),
                        ),
                      );
                    },
                    child: const Text('Commencer'),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Se connecter link
                GestureDetector(
                  onTap: () {
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
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6) ?? Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Se connecter',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Theme.of(context).colorScheme.primary,
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
