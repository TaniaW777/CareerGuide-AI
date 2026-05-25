import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_colors.dart';
import 'annex_screens.dart';
import 'main_navigation.dart';

// ... (rest of the file unchanged)


class CareerPathsScreen extends StatefulWidget {
  final String userLevel; // Passed from profile/processing
  final List<Map<String, dynamic>> backendRecommendations;
  final String aiAnalysis;
  final bool offlineMode;

  const CareerPathsScreen({
    super.key,
    this.userLevel = 'Terminale',
    this.backendRecommendations = const [],
    this.aiAnalysis = '',
    this.offlineMode = false,
  });

  @override
  State<CareerPathsScreen> createState() => _CareerPathsScreenState();
}

class _CareerPathsScreenState extends State<CareerPathsScreen> {
  void _showShareDialog(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: isDark ? Colors.white12 : Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            const Text('Partager cette recommandation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Partagez vos résultats pour "$title" avec vos amis ou conseillers.', textAlign: TextAlign.center, style: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700])),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _shareOption(context, Icons.message, 'WhatsApp', Colors.green),
                _shareOption(context, Icons.facebook, 'Facebook', Colors.blue),
                _shareOption(context, Icons.link, 'Copier', Colors.grey),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _shareOption(BuildContext context, IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Partage sur $label en cours...'),
            backgroundColor: color,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Column(
        children: [
          CircleAvatar(radius: 28, backgroundColor: color.withValues(alpha: 0.1), child: Icon(icon, color: color, size: 28)),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF7F8FA);
    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;

    final bool is3eme = widget.userLevel == '3ème';

    // Load career paths from asset JSON
    Future<List<Map<String, dynamic>>> loadPaths() async {
      try {
        final data = await DefaultAssetBundle.of(context).loadString('assets/data/career_paths.json');
        return List<Map<String, dynamic>>.from(json.decode(data));
      } catch (_) {
        return [];
      }
    }

    // Load questionnaire answers
    Future<List<String>> loadAnswers() async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final raw = prefs.getString('qa_answers') ?? '';
        if (raw.isEmpty) return [];
        try {
          final decoded = json.decode(raw);
          if (decoded is List) {
            return decoded.map((value) => value.toString()).toList();
          }
        } catch (_) {
          // Fallback to legacy comma-separated answers
        }
        return raw.split(',');
      } catch (_) {
        return [];
      }
    }

    // Combine both async loads
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([loadPaths(), loadAnswers()]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: bgColor,
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        final loadedPaths = snapshot.data![0] as List<Map<String, dynamic>>;
        final answers = snapshot.data![1] as List<String>;

        // Base static paths (existing hard‑coded entries) – kept for detailed UI fields
        List<Map<String, dynamic>> staticPaths = is3eme ? [
          {
            'title': 'Série C (Sciences Exactes)',
            'institution': 'Lycée Scientifique National / Lycée Bogodogo',
            'match': '98%',
            'passion': 95,
            'skills': 99,
            'tag': 'Excellence Scientifique',
            'reason': "Forte affinité avec les mathématiques et les sciences exactes ainsi qu'un profil orienté vers les filières d'ingénierie.",
            'desc': "La voie royale pour les passionnés de mathématiques et de physique. Idéal pour les futurs ingénieurs.",
            'outlets': 'Ingénierie, Recherche, Architecture, Statistiques.',
            'advantages': "Accès prioritaire aux grandes écoles, bourses d'excellence.",
            'icon': Icons.functions,
            'color': Colors.blue,
          },
          {
            'title': 'Série D (Sciences de la Vie et de la Terre)',
            'institution': 'Lycée Nelson Mandela / Lycée Philippe Zinda Kaboré',
            'match': '92%',
            'passion': 94,
            'skills': 88,
            'tag': 'Sciences & Santé',
            'reason': "Profil très bien adapté aux matières de sciences de la vie et à une orientation vers le secteur sanitaire.",
            'desc': "Idéal pour ceux qui aiment la biologie, la chimie et les sciences naturelles.",
            'outlets': 'Médecine, Agronomie, Environnement, Pharmacie.',
            'advantages': "Large choix de débouchés post-bac, formation polyvalente.",
            'icon': Icons.science,
            'color': Colors.green,
          },
          {
            'title': 'Série A4 (Littéraire)',
            'institution': "Lycée Marien N'Gouabi",
            'match': '85%',
            'passion': 90,
            'skills': 80,
            'tag': 'Lettres & Langues',
            'reason': "Bonne compatibilité avec les compétences rédactionnelles et l'intérêt pour les matières littéraires.",
            'desc': "Pour les esprits créatifs, passionnés par la littérature, la philosophie et les langues.",
            'outlets': 'Droit, Journalisme, Enseignement, Diplomatie.',
            'advantages': "Développement de l'esprit critique et des capacités de communication.",
            'icon': Icons.menu_book,
            'color': Colors.orange,
          },
        ] : [
          {
            'title': 'Génie Logiciel & Intelligence Artificielle',
            'higher_ed': 'Université Joseph Ki-Zerbo / ESI (Bobo)',
            'match': '96%',
            'passion': 98,
            'skills': 92,
            'tag': 'Technologie du Futur',
            'reason': "Profil très orienté vers l'analyse, la logique et l'innovation technologique.",
            'desc': "Le secteur le plus dynamique pour transformer l'économie numérique du Burkina Faso.",
            'metiers': 'Développeur Fullstack, Data Scientist, Expert en Cybersécurité.',
            'outlets': 'Startups, Banques, Administrations, Freelance International.',
            'icon': Icons.code,
            'color': AppColors.primaryLight,
          },
          {
            'title': 'Médecine Générale & Spécialisée',
            'higher_ed': 'UFR/SDS (Ouagadougou) / UNB (Bobo)',
            'match': '94%',
            'passion': 96,
            'skills': 90,
            'tag': 'Secteur de la Santé',
            'reason': "Forte affinité avec le service aux autres et une excellente stabilité professionnelle.",
            'desc': "Un engagement noble pour le bien-être des populations burkinabè.",
            'metiers': 'Médecin, Chirurgien, Spécialiste en santé publique.',
            'outlets': 'Hôpitaux publics, Cliniques privées, ONG internationales.',
            'icon': Icons.local_hospital,
            'color': Colors.red,
          },
          {
            'title': 'Management & Entrepreneuriat Agricole',
            'higher_ed': 'Université Nazi Boni / Instituts Spécialisés',
            'match': '89%',
            'passion': 85,
            'skills': 93,
            'tag': 'Développement Rural',
            'reason': "Profil orienté vers l'impact social et l'optimisation des ressources naturelles.",
            'desc': "Moderniser l'agriculture pour assurer la souveraineté alimentaire.",
            'metiers': "Chef d'exploitation, Consultant agro-pastoral, Manager de coopérative.",
            'outlets': 'Agrobusiness, Projets de développement, Entrepreneuriat.',
            'icon': Icons.nature_people,
            'color': Colors.green,
          },
        ];

        // Merge static entries with loaded JSON entries (ensure unique titles)
        List<Map<String, dynamic>> merged = List.from(staticPaths);
        for (var entry in loadedPaths) {
          if (!merged.any((e) => e['title'] == entry['name'])) {
            merged.add({
              'title': entry['name'],
              'institution': entry['description'], // placeholder for institution field
              'higher_ed': entry['description'],
              'match': '80%', // default match, will be boosted later
              'passion': 70,
              'skills': 70,
              'tag': entry['category'],
              'reason': entry['description'],
              'desc': entry['description'],
              'outlets': '',
              'advantages': '',
              'icon': Icons.star,
              'color': Colors.purple,
            });
          }
        }

        // Adjust match based on questionnaire answers (simple boost logic)
        final baseBoost = answers.where((a) => a != '-1').length * 2; // each valid answer adds 2%
        for (var p in merged) {
          final base = int.tryParse((p['match'] as String).replaceAll('%', '')) ?? 80;
          p['match'] = "${(base + baseBoost).clamp(0, 100)}%";
        }

        // Sort and take top 5
        merged.sort((a, b) {
          return int.parse((b['match'] as String).replaceAll('%', '')).compareTo(int.parse((a['match'] as String).replaceAll('%', '')));
        });
        final top = merged.take(5).toList();

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            title: const Text('Mes Recommandations', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: isDark ? Colors.white : Colors.black,
            actions: [
              IconButton(
                icon: const Icon(Icons.home_outlined),
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigation())),
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark ? [AppColors.primaryDark, AppColors.accentDark] : [AppColors.primaryLight, const Color(0xFF1A56DB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(color: (isDark ? AppColors.accentDark : AppColors.primaryLight).withValues(alpha: 0.22), blurRadius: 18, offset: const Offset(0, 10))],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Analyse Terminée !', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                                SizedBox(height: 4),
                                Text('Filières correspondant à votre profil', style: TextStyle(color: Colors.white70, fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (widget.aiAnalysis.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(Icons.psychology, color: Colors.white, size: 18),
                                  SizedBox(width: 8),
                                  Text("Analyse du Conseiller IA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.aiAnalysis,
                                style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              // Recommendation cards
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: List.generate(top.length, (i) {
                      final p = top[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: _buildCard(context, p, cardColor),
                      );
                    }),
                  ),
                ),
              ),
              // Bottom button
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigation())),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryLight,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.dashboard_customize, size: 18),
                        SizedBox(width: 8),
                        Flexible(child: Text('ACCÉDER AU TABLEAU DE BORD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center)),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackendResultCard(Map<String, dynamic> item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final details = _programDetailMap(item['program'] as String);
    final color = details['color'] as Color;
    final schoolNames = (item['schools'] as List<dynamic>?)?.map((s) => s['name'] as String).toList() ?? [];
    final schoolLabel = schoolNames.isNotEmpty ? schoolNames.join(', ') : details['subTitle'] as String;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['program'] as String,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '${item['score']}%',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            details['summary'] as String,
            style: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700], height: 1.5),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.school_outlined, size: 16, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  schoolLabel,
                  style: TextStyle(color: isDark ? Colors.white60 : Colors.grey[600], fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _programDetailMap(String program) {
    final normalized = program.toLowerCase();
    if (normalized.contains('médecine')) {
      return {
        'color': Colors.red,
        'summary': 'Une filière stable et reconnue, adaptée aux profils qui aiment aider et apprendre.',
        'subTitle': 'Hôpitaux, universités et centres de santé locaux',
      };
    }
    if (normalized.contains('informatique')) {
      return {
        'color': AppColors.primaryLight,
        'summary': 'Un parcours tourné vers l’innovation, le développement logiciel et l’intelligence artificielle.',
        'subTitle': 'Entreprises tech, startups et projets numériques',
      };
    }
    if (normalized.contains('pharmacie')) {
      return {
        'color': Colors.green,
        'summary': 'Un domaine scientifique stable avec de nombreux débouchés en santé et industrie.',
        'subTitle': 'Laboratoires, pharmacies et services de santé',
      };
    }
    if (normalized.contains('agronomie')) {
      return {
        'color': Colors.green.shade700,
        'summary': 'Une voie concrète vers l’agriculture moderne et le développement durable.',
        'subTitle': 'Coopératives, projets ruraux et agro-industries',
      };
    }

    return {
      'color': Colors.blueGrey,
      'summary': 'Une option intéressante basée sur les résultats de l’IA et vos réponses.',
      'subTitle': 'Options recommandées en fonction de votre profil',
    };
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> p, Color cardColor) {
    final color = p['color'] as Color;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool is3eme = widget.userLevel == '3ème';

    void navigateToDetails() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CareerDetailScreen(
            title: p['title'] as String,
            match: p['match'] as String,
            tag: p['tag'] as String,
            desc: p['desc'] as String,
            color: color,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: navigateToDetails,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(28),
          border: isDark ? Border.all(color: AppColors.borderDark, width: 1) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.16 : 0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(p['icon'] as IconData, color: color, size: 28),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(p['match'] as String, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 24)),
                    const Text('MATCH', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(p['title'] as String, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: isDark ? AppColors.onSurfaceDark : Colors.black)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(is3eme ? Icons.school_outlined : Icons.account_balance_outlined, size: 14, color: color.withValues(alpha: 0.7)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    (is3eme ? p['institution'] : p['higher_ed']) as String,
                    style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(p['tag'] as String, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            Text(p['reason'] as String, style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade700, fontSize: 13, height: 1.55)),
            const SizedBox(height: 20),
            Row(
              children: [
                _metricBadge('Passion', p['passion'] as int, Colors.pink),
                const SizedBox(width: 12),
                _metricBadge('Skills', p['skills'] as int, Colors.blue),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              p['desc'] as String,
              style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade600, fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 16),
            if (is3eme) ...[
              _buildDetailInfo(Icons.trending_up, 'Débouchés', p['outlets'] as String, color, isDark),
              const SizedBox(height: 8),
              _buildDetailInfo(Icons.check_circle_outline, 'Avantages', p['advantages'] as String, color, isDark),
            ] else ...[
              _buildDetailInfo(Icons.work_outline, 'Métiers', p['metiers'] as String, color, isDark),
              const SizedBox(height: 8),
              _buildDetailInfo(Icons.business_center_outlined, 'Débouchés', p['outlets'] as String, color, isDark),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: navigateToDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.primaryDark : AppColors.primaryLight,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: isDark ? 0 : 0,
                    ),
                    child: const Text('DÉTAILS COMPLETS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.grey[50],
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.share_outlined, size: 20, color: isDark ? AppColors.onSurfaceDark : Colors.black87),
                    onPressed: () => _showShareDialog(context, p['title'] as String),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricBadge(String label, int value, Color color) {
    final icon = label == 'Passion' ? Icons.favorite : Icons.insights;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text('$label: ', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          Text('$value%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildDetailInfo(IconData icon, String label, String text, Color color, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.grey[800]),
              children: [
                TextSpan(text: '$label : ', style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: text),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

