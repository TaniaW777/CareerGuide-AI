import 'package:flutter/material.dart';
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
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            const Text('Partager cette recommandation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Partagez vos résultats pour "$title" avec vos amis ou conseillers.', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
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
          CircleAvatar(radius: 28, backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color, size: 28)),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
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

    final paths = is3eme ? [
      {
        'title': 'Série C (Scientifique)',
        'institution': 'Lycée Scientifique National',
        'match': '96%',
        'passion': 92,
        'skills': 98,
        'tag': 'Filière Excellence',
        'desc': 'Tes excellentes notes en mathématiques et physique au BEPC te destinent naturellement vers la série C pour devenir ingénieur.',
        'icon': Icons.functions,
        'color': Colors.blue,
      },
      {
        'title': 'Série E (Technique)',
        'institution': 'Lycée Polytechnique de Ouaga',
        'match': '89%',
        'passion': 85,
        'skills': 93,
        'tag': 'Technique & Innovation',
        'desc': 'Ton penchant pour la mécanique et l\'électronique t\'offre une voie royale en série E vers les métiers de l\'industrie.',
        'icon': Icons.settings_input_component,
        'color': Colors.orange,
      },
    ] : [
      {
        'title': 'Génie Logiciel',
        'institution': 'Université Joseph Ki-Zerbo',
        'match': '94%',
        'passion': 98,
        'skills': 90,
        'tag': 'Numérique',
        'desc': 'Ton profil créatif et analytique après ton Bac C/D te permet d\'exceller dans le développement logiciel au Burkina.',
        'icon': Icons.code,
        'color': AppColors.primaryLight,
      },
      {
        'title': 'Agronomie & Eau',
        'institution': 'Université de Bobo / Nazi Boni',
        'match': '88%',
        'passion': 95,
        'skills': 81,
        'tag': 'Secteur Vital',
        'desc': 'L\'agriculture est le moteur de notre économie. Ta passion pour l\'environnement te guidera vers la sécurité alimentaire.',
        'icon': Icons.eco,
        'color': Colors.green,
      },
    ];


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
                gradient: const LinearGradient(
                  colors: [AppColors.primaryLight, Color(0xFF1A56DB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [BoxShadow(color: AppColors.primaryLight.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
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
                            Text('${paths.length} filières correspondent à votre profil', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  if (i >= paths.length) return null;
                  final p = paths[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _buildCard(context, p, cardColor),
                  );
                },
                childCount: paths.length,
              ),
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
                child: const Text('ACCÉDER À MON TABLEAU DE BORD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 8))],
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
                  color: color.withOpacity(0.12),
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
          Text(p['title'] as String, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: isDark ? Colors.white : Colors.black)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.school_outlined, size: 14, color: color.withOpacity(0.7)),
              const SizedBox(width: 6),
              Text(
                p['institution'] as String,
                style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(p['tag'] as String, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),

          
          // Passions & Skills percentages
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
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
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
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('DÉTAILS COMPLETS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[50],
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
                ),
                child: IconButton(
                  icon: const Icon(Icons.share_outlined, size: 20),
                  onPressed: () => _showShareDialog(context, p['title'] as String),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricBadge(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          Text('$value%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

