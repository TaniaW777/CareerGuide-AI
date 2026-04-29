import 'package:flutter/material.dart';
import 'dart:async';
import '../core/theme/app_colors.dart';
import 'career_paths_screen.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  int _tipIndex = 0;
  final List<String> _tips = [
    "Analyse de vos préférences...",
    "Comparaison avec les filières locales...",
    "Évaluation des débouchés au Burkina...",
    "Génération de recommandations personnalisées..."
  ];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _tipIndex = (_tipIndex + 1) % _tips.length;
        });
      }
    });

    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CareerPathsScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 120,
                width: 120,
                child: CircularProgressIndicator(
                  strokeWidth: 8,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(height: 60),
              const Text(
                'Analyse en cours',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  _tips[_tipIndex],
                  key: ValueKey(_tips[_tipIndex]),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
