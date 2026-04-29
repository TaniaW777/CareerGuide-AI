import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_header.dart';
import 'auth_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      body: Stack(
        children: [
          // Top Blue Section with Illustration
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.6,
            child: Container(
              color: AppColors.primaryLight,
              child: SafeArea(
                child: Center(
                  child: Hero(
                    tag: 'student_hero',
                    child: Image.asset(
                      'assets/images/student_hero_cutout_1777423096626.png',
                      height: size.height * 0.45,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.school,
                        size: 150,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom White Section with Curve
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: size.height * 0.48, // Slightly taller to account for curve
            child: ClipPath(
              clipper: ConvexCurveClipper(),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(40.0, 80.0, 40.0, 40.0), // Extra top padding for the curve
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'CareerGuide ',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: AppColors.primaryLight,
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                        ),
                        TextSpan(
                          text: 'AI',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: AppColors.accentLight,
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Ton avenir commence ici! Ton guide simple Pour choisir ta voie apres le BEPC ou le BAC BURKINA FASO',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[500],
                          height: 1.6,
                          fontSize: 16,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AuthScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryLight,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                      minimumSize: const Size(double.infinity, 70),
                    ),
                    child: const Text(
                      'Commencer',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }
}
