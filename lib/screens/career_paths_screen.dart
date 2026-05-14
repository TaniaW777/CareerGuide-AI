import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_colors.dart';
import 'annex_screens.dart';
import 'main_navigation.dart';

class CareerPathsScreen extends StatefulWidget {
  final String userLevel; // Passed from profile/processing
  const CareerPathsScreen({super.key, this.userLevel = 'Terminale'});

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

    // Polyvalent data based on level
    final bool is3eme = widget.userLevel == '3ème';

    List<Map<String, dynamic>> paths = is3eme ? [
      {
        'title': 'Série C (Sciences Exactes)',
        'institution': 'Lycée Scientifique National / Lycée Bogodogo',
        'match': '98%',
        'passion': 95,
        'skills': 99,
        'tag': 'Excellence Scientifique',
        'reason': 'Forte affinité avec les mathématiques et les sciences exactes ainsi qu\'un profil orienté vers les filières d\'ingénierie.',
        'desc': 'La voie royale pour les passionnés de mathématiques et de physique. Idéal pour les futurs ingénieurs.',
        'outlets': 'Ingénierie, Recherche, Architecture, Statistiques.',
        'advantages': 'Accès prioritaire aux grandes écoles, bourses d\'excellence.',
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
        'reason': 'Profil très bien adapté aux matières de sciences de la vie et à une orientation vers le secteur sanitaire.',
        'desc': 'Idéal pour ceux qui aiment la biologie, la chimie et les sciences naturelles.',
        'outlets': 'Médecine, Agronomie, Environnement, Pharmacie.',
        'advantages': 'Large choix de débouchés post-bac, formation polyvalente.',
        'icon': Icons.science,
        'color': Colors.green,
      },
      {
        'title': 'Série A4 (Littéraire)',
        'institution': 'Lycée Marien N\'Gouabi',
        'match': '85%',
        'passion': 90,
        'skills': 80,
        'tag': 'Lettres & Langues',
        'reason': 'Bonne compatibilité avec les compétences rédactionnelles et l\'intérêt pour les matières littéraires.',
        'desc': 'Pour les esprits créatifs, passionnés par la littérature, la philosophie et les langues.',
        'outlets': 'Droit, Journalisme, Enseignement, Diplomatie.',
        'advantages': 'Développement de l\'esprit critique et des capacités de communication.',
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
        'reason': 'Profil très orienté vers l\'analyse, la logique et l\'innovation technologique.',
        'desc': 'Le secteur le plus dynamique pour transformer l\'économie numérique du Burkina Faso.',
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
        'reason': 'Forte affinité avec le service aux autres et une excellente stabilité professionnelle.',
        'desc': 'Un engagement noble pour le bien-être des populations burkinabè.',
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
        'reason': 'Profil orienté vers l\'impact social et l\'optimisation des ressources naturelles.',
        'desc': 'Moderniser l\'agriculture pour assurer la souveraineté alimentaire.',
        'metiers': 'Chef d\'exploitation, Consultant agro-pastoral, Manager de coopérative.',
        'outlets': 'Agrobusiness, Projets de développement, Entrepreneuriat.',
        'icon': Icons.nature_people,
        'color': Colors.green,
      },
    ];

    // Ensure at least 5 items available by adding more options if needed
    if (paths.length < 5) {
      final extra = [
        {
          'title': is3eme ? 'Série G (Gestion)' : 'Commerce & Finance',
          'institution': is3eme ? 'Lycée de Gestion' : null,
          'higher_ed': is3eme ? null : 'Université Privée Aube Nouvelle',
          'match': '80%',
          'passion': 78,
          'skills': 75,
          'tag': 'Gestion & Commerce',
          'reason': 'Bon équilibre entre compétences pratiques et théoriques.',
          'desc': 'Filières en gestion, comptabilité et commerce.',
          'outlets': 'Entrepreneuriat, Banques, PME.',
          'advantages': 'Insertion rapide sur le marché.',
          'metiers': 'Comptable, Gestionnaire, Commercial.',
          'icon': Icons.account_balance,
          'color': Colors.purple,
        },
        {
          'title': is3eme ? 'BAC Pro & Métiers' : 'Formations Professionnelles',
          'institution': is3eme ? 'Centre de Formation' : null,
          'higher_ed': is3eme ? null : 'CFPR / ISFM',
          'match': '76%',
          'passion': 70,
          'skills': 80,
          'tag': 'Professionnel',
          'reason': 'Formation pratique pour insertion rapide.',
          'desc': 'Diplômes professionnalisants et courtes formations.',
          'outlets': 'Métiers techniques, Artisanat, Services.',
          'advantages': 'Insertion locale et apprentissage.',
          'metiers': 'Technicien, Artisan qualifié.',
          'icon': Icons.handyman,
          'color': Colors.brown,
        },
      ];
      paths = [...paths, ...extra];
    }

    // Read questionnaire answers and compute adjusted match
    Future<List<String>> _loadAnswers() async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final raw = prefs.getString('qa_answers') ?? '';
        if (raw.isEmpty) return []; 
        return raw.split(',');
      } catch (_) {
        return [];
      }
    }

    // Synchronously compute a numeric match value and sort paths by it
    // We'll load answers async and then rebuild via FutureBuilder below.


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
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Summary header
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
                          children: [
                            const Text('Analyse Terminée !', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                            const SizedBox(height: 4),
                            Text('${paths.length} filières correspondent à votre profil', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Recommendations list - built after loading questionnaire answers
          SliverToBoxAdapter(
            child: FutureBuilder<List<String>>(
              future: _loadAnswers(),
              builder: (context, snapshot) {
                final answers = snapshot.data ?? [];

                // compute adjusted numeric match for each path
                final scored = paths.map((p) {
                  final base = int.tryParse((p['match'] as String).replaceAll('%', '')) ?? 70;
                  final boost = (answers.isNotEmpty) ? (answers.where((a) => a != '-1').length) : 0;
                  final score = (base + boost).clamp(0, 100);
                  return {...p, 'matchValue': score};
                }).toList();

                scored.sort((a, b) => (b['matchValue'] as int).compareTo(a['matchValue'] as int));

                // show top 5
                final top = scored.take(5).toList();

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: List.generate(top.length, (i) {
                      final p = top[i];
                      // update displayed match string from matchValue
                      p['match'] = '${p['matchValue']}%';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: _buildCard(context, p, cardColor),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
          
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
                    Flexible(
                      child: Text('ACCÉDER AU TABLEAU DE BORD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
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

