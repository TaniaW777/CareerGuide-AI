import 'package:flutter/material.dart';
import '../services/user_data_service.dart';
import 'question_flow_screen.dart';
import 'main_navigation.dart';

class CareerPathsScreen extends StatefulWidget {
  final String userLevel;
  final List<Map<String, dynamic>> recommendations;

  // Peut être ouvert avec des données passées OU chargées depuis le cache
  const CareerPathsScreen({
    super.key,
    this.userLevel = '',
    this.recommendations = const [],
  });

  @override
  State<CareerPathsScreen> createState() => _CareerPathsScreenState();
}

class _CareerPathsScreenState extends State<CareerPathsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  List<Animation<double>> _itemAnimations = [];

  List<Map<String, dynamic>> _recommendations = [];
  String _userLevel = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _loadData();
  }

  Future<void> _loadData() async {
    List<Map<String, dynamic>> recs;
    String level;

    // Si des données sont passées en paramètre, on les utilise
    // Sinon on charge depuis le cache
    if (widget.recommendations.isNotEmpty) {
      recs = widget.recommendations;
      level = widget.userLevel;
    } else {
      recs = await UserDataService().getRecommendations();
      level = await UserDataService().getUserLevel();
    }

    _buildAnimations(recs.length);

    setState(() {
      _recommendations = recs;
      _userLevel = level;
      _loading = false;
    });

    _animCtrl.forward();
  }

  void _buildAnimations(int count) {
    final n = count == 0 ? 1 : count;
    _itemAnimations = List.generate(
      n,
      (i) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animCtrl,
          curve: Interval(
            i * 0.15,
            (i * 0.15 + 0.6).clamp(0.0, 1.0),
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animCtrl.dispose();
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
              Colors.white,
            ],
            stops: [0.0, 0.35, 0.55, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'CareerGuide ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              TextSpan(
                                text: 'AI',
                                style: TextStyle(
                                  color: Color(0xFFFF9800),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        if (_userLevel.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.3)),
                            ),
                            child: Text(
                              _userLevel,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tes recommandations 🎯',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _loading
                                ? 'Chargement...'
                                : _recommendations.isEmpty
                                    ? 'Aucune recommandation'
                                    : '${_recommendations.length} filière${_recommendations.length > 1 ? 's' : ''} identifiée${_recommendations.length > 1 ? 's' : ''} pour toi',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // ── Contenu ──────────────────────────────────────────────
              Expanded(
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF0F52BA),
                          strokeWidth: 2,
                        ),
                      )
                    : _recommendations.isEmpty
                        ? _buildEmpty()
                        : ListView.builder(
                            padding:
                                const EdgeInsets.fromLTRB(20, 8, 20, 20),
                            itemCount: _recommendations.length,
                            itemBuilder: (context, index) {
                              final animIndex =
                                  index.clamp(0, _itemAnimations.length - 1);
                              return AnimatedBuilder(
                                animation: _itemAnimations[animIndex],
                                builder: (context, child) {
                                  final v = _itemAnimations[animIndex].value;
                                  return Opacity(
                                    opacity: v,
                                    child: Transform.translate(
                                      offset: Offset(0, 30 * (1 - v)),
                                      child: child,
                                    ),
                                  );
                                },
                                child: _RecommendationCard(
                                  rec: _recommendations[index],
                                  isTop: index == 0,
                                  rank: index + 1,
                                ),
                              );
                            },
                          ),
              ),

              // ── Actions ───────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Bouton principal
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const MainNavigation()),
                      ),
                      icon: const Icon(Icons.explore_rounded, size: 20),
                      label: const Text(
                        "Explorer les établissements",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F52BA),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 4,
                        shadowColor:
                            const Color(0xFF0F52BA).withOpacity(0.35),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Bouton refaire
                    OutlinedButton.icon(
                      onPressed: () async {
                        // Reset questionnaire pour permettre de le refaire
                        await UserDataService().resetQuestionnaire();
                        if (!context.mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const QuestionFlowScreen()),
                        );
                      },
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text(
                        "Refaire le questionnaire",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0F52BA),
                        minimumSize: const Size(double.infinity, 48),
                        side: const BorderSide(
                            color: Color(0xFF0F52BA), width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF0F52BA).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                color: Color(0xFF0F52BA),
                size: 38,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Aucune recommandation",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F52BA),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Réponds au questionnaire pour obtenir tes recommandations personnalisées.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => const QuestionFlowScreen()),
              ),
              icon: const Icon(Icons.quiz_rounded, size: 18),
              label: const Text("Répondre au questionnaire"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F52BA),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Card recommandation ──────────────────────────────────────────────────────

class _RecommendationCard extends StatelessWidget {
  final Map<String, dynamic> rec;
  final bool isTop;
  final int rank;

  const _RecommendationCard({
    required this.rec,
    required this.isTop,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final schools = (rec["schools"] as List?) ?? [];
    final score = (rec["score"] as num?)?.toInt() ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isTop
            ? Border.all(color: const Color(0xFFFF9800), width: 2)
            : Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: isTop
                ? const Color(0xFFFF9800).withOpacity(0.12)
                : Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre + rang
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isTop
                        ? const Color(0xFFFF9800)
                        : const Color(0xFF0F52BA).withOpacity(0.09),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "#$rank",
                      style: TextStyle(
                        color: isTop ? Colors.white : const Color(0xFF0F52BA),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rec["program"] ?? "",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F52BA),
                        ),
                      ),
                      if (isTop) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFFF9800).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "🏆 Meilleur choix pour toi",
                            style: TextStyle(
                              color: Color(0xFFFF9800),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Score
            Row(
              children: [
                Text(
                  "Compatibilité",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  "$score%",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: score >= 80
                        ? const Color(0xFF0F52BA)
                        : const Color(0xFFFF9800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: score / 100,
                minHeight: 7,
                backgroundColor:
                    const Color(0xFF0F52BA).withOpacity(0.09),
                valueColor: AlwaysStoppedAnimation<Color>(
                  score >= 80
                      ? const Color(0xFF0F52BA)
                      : const Color(0xFFFF9800),
                ),
              ),
            ),

            // Écoles
            if (schools.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0xFFF0F0F0)),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.school_rounded,
                      size: 14, color: Color(0xFF0F52BA)),
                  const SizedBox(width: 6),
                  Text(
                    "Établissements au Burkina Faso",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...schools.map(
                (school) => Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 14, color: Color(0xFFFF9800)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "${school["name"]} — ${school["city"]}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1A1A2E),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}