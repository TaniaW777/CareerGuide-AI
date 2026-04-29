import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'annex_screens.dart';

class CareerPathsScreen extends StatelessWidget {
  const CareerPathsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF7F8FA);
    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;

    final paths = [
      {
        'title': 'Ingénieur Agronome',
        'match': '94%',
        'tag': 'Secteur Porteur',
        'desc': 'Ton intérêt pour l\'innovation et l\'agriculture durable fait de toi un excellent candidat pour ce métier stratégique au Burkina Faso.',
        'icon': Icons.eco_outlined,
        'color': Colors.green,
      },
      {
        'title': 'Développeur Full-Stack',
        'match': '88%',
        'tag': 'Tech & Innovation',
        'desc': 'Tes compétences analytiques et ta passion pour la résolution de problèmes complexes correspondent parfaitement aux besoins de l\'écosystème numérique.',
        'icon': Icons.code,
        'color': AppColors.primaryLight,
      },
      {
        'title': 'Gestionnaire de Projets',
        'match': '82%',
        'tag': 'Leadership',
        'desc': 'Ton sens de l\'organisation et tes capacités de communication te prédisposent à piloter des projets d\'envergure dans le développement local.',
        'icon': Icons.trending_up,
        'color': Colors.orange,
      },
      {
        'title': 'Professionnel de Santé',
        'match': '75%',
        'tag': 'Impact Social',
        'desc': 'Ton empathie et ton désir d\'aider les autres te positionnent bien dans les métiers de la santé et du social, un secteur en pleine expansion.',
        'icon': Icons.favorite_outline,
        'color': Colors.red,
      },
    ];

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          // Summary header
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryLight, Color(0xFF1A56DB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.psychology_outlined, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tes Recommandations IA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        const Text('Basé sur ton profil et questionnaire', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: 0.85,
                            backgroundColor: Colors.white.withValues(alpha: 0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                            minHeight: 7,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text('Analyse complète à 85%', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
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
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildCard(context, p, cardColor),
                  );
                },
                childCount: paths.length,
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4))],
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
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(p['icon'] as IconData, color: color, size: 24),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(p['match'] as String, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 22)),
                  const Text('MATCH', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(p['title'] as String, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: isDark ? Colors.white : Colors.black)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(p['tag'] as String, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 14),
          Text(
            p['desc'] as String,
            style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade600, fontSize: 13, height: 1.6),
          ),
          const SizedBox(height: 18),
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
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('VOIR LES DÉTAILS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.share_outlined, size: 18),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
