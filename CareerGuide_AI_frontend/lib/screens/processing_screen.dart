import 'package:careerguide_ai/core/theme/connectivity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import '../core/theme/app_colors.dart';
import '../services/local_ia/local_ai_service.dart';
import '../services/profile_mapper.dart';
import 'career_paths_screen.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  int _tipIndex = 0;
  final List<String> _tips = [
    "L'IA analyse tes réponses...",
    "Recherche des meilleures options...",
    "Préparation des recommandations..."
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

    _fetchRecommendations();
  }

  Future<void> _fetchRecommendations() async {
    final connectivity = Provider.of<ConnectivityProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    final userLevel = prefs.getString('user_classe') ?? '3ème';
    final rawAnswers = prefs.getString('qa_answers') ?? '';

    final answers = <String>[];
    if (rawAnswers.isNotEmpty) {
      try {
        final decoded = json.decode(rawAnswers);
        if (decoded is List) {
          answers.addAll(decoded.map((value) => value.toString()));
        } else {
          answers.add(rawAnswers);
        }
      } catch (_) {
        answers.addAll(rawAnswers.split(','));
      }
    }

    final profile = buildStudentProfile(userLevel, answers);
    
    // Utilisation du mode hybride
    final bool useOnline = connectivity.isConnected && !connectivity.offlineFirstMode;
    
    final result = await LocalAIService.getRecommendations(
      profile, 
      onlineMode: useOnline
    );
    
    final List<Map<String, dynamic>> recommendations = List<Map<String, dynamic>>.from(result['recommendations'] ?? []);
    final String aiAnalysis = result['analysis'] ?? '';
    
    final offline = !useOnline || recommendations.isEmpty;

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CareerPathsScreen(
            userLevel: userLevel,
            backendRecommendations: recommendations,
            aiAnalysis: aiAnalysis,
            offlineMode: offline,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                'Enregistrement de ton profil',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  _tips[_tipIndex],
                  key: ValueKey(_tips[_tipIndex]),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              SpinKitSpinningLines(
                color: AppColors.primaryLight,
                size: 120.0,
                lineWidth: 4.0,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
