import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../services/recommendation_service.dart';
import '../services/user_data_service.dart';
import 'career_paths_screen.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen>
    with SingleTickerProviderStateMixin {
  int _tipIndex = 0;
  late Timer _tipTimer;
  late AnimationController _rotateCtrl;

  final List<String> _tips = [
    "Analyse de tes réponses...",
    "Recherche des meilleures filières...",
    "Consultation des universités du Burkina...",
    "Préparation de tes recommandations...",
  ];

  @override
  void initState() {
    super.initState();
    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _tipTimer = Timer.periodic(const Duration(milliseconds: 1800), (_) {
      if (mounted) setState(() => _tipIndex = (_tipIndex + 1) % _tips.length);
    });

    _processAndNavigate();
  }

  Future<void> _processAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final prefs = await SharedPreferences.getInstance();
    final userLevel = prefs.getString('user_classe') ?? '3ème';
    final answersRaw = prefs.getString('qa_answers') ?? '';

    print('[PROCESSING] userLevel=$userLevel answers=$answersRaw');

    final answerIndices = answersRaw.isNotEmpty
        ? answersRaw.split(',').map((e) => int.tryParse(e) ?? -1).toList()
        : <int>[];

    final level =
        userLevel == 'Terminale' ? 'Terminale (BAC)' : '3ème (BEPC)';

    const interestMap = ['Technologie', 'Santé', 'Lettres', 'Business'];
    const seriesMap = ['C', 'D', 'A', 'B'];
    const subjectsMap = [
      ['Math', 'Informatique'],
      ['SVT', 'PC'],
      ['Philosophie', 'Anglais'],
      ['Economie', 'Anglais'],
    ];

    final q4Index =
        answerIndices.length > 3 ? answerIndices[3] : 0;
    final safeIndex = (q4Index >= 0 && q4Index < 4) ? q4Index : 0;

    final interest = interestMap[safeIndex];
    final series = seriesMap[safeIndex];
    final subjects = List<String>.from(subjectsMap[safeIndex]);

    print('[PROCESSING] interest=$interest series=$series subjects=$subjects');

    List<Map<String, dynamic>> results = [];
    try {
      results = await RecommendationService().getRecommendations(
        level: level,
        series: series,
        subjects: subjects,
        interest: interest,
      );
      print('[PROCESSING] Backend results: $results');
    } catch (e) {
      print('[PROCESSING] Backend error: $e — fallback');
      results = _fallbackRecommendations(interest);
    }

    // ✅ Sauvegarde persistante — ne redemandera plus le questionnaire
    await UserDataService().saveRecommendations(results, userLevel);
    print('[PROCESSING] Saved to UserDataService');

    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final screen = CareerPathsScreen(
      userLevel: userLevel,
      recommendations: results,
    );

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: CurvedAnimation(
              parent: animation, curve: Curves.easeOutCubic),
          child: child,
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _fallbackRecommendations(String interest) {
    final data = <String, List<Map<String, dynamic>>>{
      'Santé': [
        {
          "program": "Médecine",
          "score": 88,
          "schools": [
            {"name": "Université Joseph Ki-Zerbo", "city": "Ouagadougou"},
            {"name": "Université Nazi Boni", "city": "Bobo-Dioulasso"},
          ]
        },
        {
          "program": "Pharmacie",
          "score": 74,
          "schools": [
            {"name": "UFR/SDS Ouagadougou", "city": "Ouagadougou"},
          ]
        },
      ],
      'Technologie': [
        {
          "program": "Informatique / Génie Logiciel",
          "score": 90,
          "schools": [
            {
              "name": "Institut Supérieur de Technologie",
              "city": "Ouagadougou"
            },
            {"name": "ESI Burkina", "city": "Ouagadougou"},
          ]
        },
        {
          "program": "Génie Civil",
          "score": 72,
          "schools": [
            {
              "name": "Université Polytechnique de Bobo",
              "city": "Bobo-Dioulasso"
            },
          ]
        },
      ],
      'Business': [
        {
          "program": "Gestion / Commerce",
          "score": 85,
          "schools": [
            {"name": "ISG Burkina", "city": "Ouagadougou"},
            {"name": "ISCAM", "city": "Ouagadougou"},
          ]
        },
        {
          "program": "Droit des Affaires",
          "score": 70,
          "schools": [
            {"name": "Université Joseph Ki-Zerbo", "city": "Ouagadougou"},
          ]
        },
      ],
      'Lettres': [
        {
          "program": "Droit / Sciences Politiques",
          "score": 82,
          "schools": [
            {"name": "Université Joseph Ki-Zerbo", "city": "Ouagadougou"},
          ]
        },
        {
          "program": "Journalisme / Communication",
          "score": 75,
          "schools": [
            {"name": "ISTIC Ouagadougou", "city": "Ouagadougou"},
          ]
        },
      ],
    };

    return data[interest] ??
        [
          {
            "program": "Formation Générale",
            "score": 65,
            "schools": [
              {
                "name": "Université Joseph Ki-Zerbo",
                "city": "Ouagadougou"
              },
            ]
          }
        ];
  }

  @override
  void dispose() {
    _tipTimer.cancel();
    _rotateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F52BA),
              Color(0xFF4A90E2),
              Color(0xFFF0F4F8),
              Colors.white,
            ],
            stops: [0.0, 0.4, 0.65, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Icône animée
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.12),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.18),
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F52BA).withOpacity(0.25),
                          blurRadius: 28,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: RotationTransition(
                      turns: _rotateCtrl,
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Color(0xFF0F52BA),
                        size: 38,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 44),

              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Analyse ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800),
                    ),
                    TextSpan(
                      text: 'en cours',
                      style: TextStyle(
                          color: Color(0xFFFF9800),
                          fontSize: 26,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.15),
                      end: Offset.zero,
                    ).animate(anim),
                    child: child,
                  ),
                ),
                child: Text(
                  _tips[_tipIndex],
                  key: ValueKey(_tipIndex),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.78),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 52),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 52),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    minHeight: 5,
                    backgroundColor: Colors.white.withOpacity(0.18),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF9800)),
                  ),
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(bottom: 36),
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'CareerGuide ',
                        style: TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                            fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: 'AI',
                        style: TextStyle(
                            color: Color(0xFFFF9800),
                            fontSize: 13,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}