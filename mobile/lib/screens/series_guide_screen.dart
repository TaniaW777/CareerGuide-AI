import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class SeriesGuideScreen extends StatelessWidget {
  const SeriesGuideScreen({super.key});

  final List<Map<String, dynamic>> _series = const [
    {
      'title': 'Série A (Littéraire)',
      'subtitle': 'Lettres, Langues et Sciences Humaines',
      'desc': 'La série A est destinée aux élèves passionnés par la littérature, les langues, l\'histoire et la philosophie. Elle ouvre les portes vers le droit, le journalisme, l\'enseignement et les sciences sociales.',
      'future': 'Droit, Diplomatie, Communication, Enseignement, Psychologie.',
      'color': Colors.red,
      'icon': Icons.menu_book_rounded,
    },
    {
      'title': 'Série C (Scientifique)',
      'subtitle': 'Mathématiques et Sciences Physiques',
      'desc': 'La série d\'excellence pour les esprits mathématiques. Elle demande une grande rigueur et ouvre les portes des plus grandes écoles d\'ingénieurs et de recherche.',
      'future': 'Ingénierie, Recherche scientifique, Mathématiques appliquées, Aéronautique.',
      'color': Colors.blue,
      'icon': Icons.functions_rounded,
    },
    {
      'title': 'Série D (Scientifique)',
      'subtitle': 'Sciences de la Vie et de la Terre',
      'desc': 'Le choix idéal pour ceux qui aiment la biologie et la chimie. C\'est la voie royale pour les études de santé et d\'agronomie au Burkina Faso.',
      'future': 'Médecine, Pharmacie, Agronomie, Environnement, Biologie.',
      'color': Colors.green,
      'icon': Icons.biotech_rounded,
    },
    {
      'title': 'Série E (Technique)',
      'subtitle': 'Mathématiques et Techniques',
      'desc': 'Allie les mathématiques poussées à la pratique technique (mécanique, électronique). Pour ceux qui aiment concevoir et construire.',
      'future': 'Génie Mécanique, Électronique, Maintenance industrielle, Robotique.',
      'color': Colors.orange,
      'icon': Icons.settings_suggest_rounded,
    },
    {
      'title': 'Série F (Technologique)',
      'subtitle': 'F1, F2, F3, F4 (Génie Civil, Élec, etc.)',
      'desc': 'Des séries très spécialisées dans les technologies de l\'industrie : électricité, construction, mécanique.',
      'future': 'Architecture, Génie Civil, Électrotechnique, BTP.',
      'color': Colors.teal,
      'icon': Icons.build_circle_rounded,
    },
    {
      'title': 'Série G (Tertiaire)',
      'subtitle': 'Gestion, Comptabilité, Secrétariat',
      'desc': 'Pour les futurs gestionnaires et administrateurs d\'entreprises. Très pratique pour une insertion rapide sur le marché du travail.',
      'future': 'Comptabilité, Marketing, Ressources Humaines, Banque, Assurance.',
      'color': Colors.purple,
      'icon': Icons.account_balance_rounded,
    },
    {
      'title': 'BAC Pro & Métiers (Couture, etc.)',
      'subtitle': 'Formations Professionnelles',
      'desc': 'Filières axées sur la maîtrise d\'un métier spécifique : couture, menuiserie, cuisine, hôtellerie.',
      'future': 'Entrepreneuriat, Mode, Hôtellerie, Artisanat qualifié.',
      'color': Colors.pink,
      'icon': Icons.cut_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.grey[50],
      appBar: AppBar(
        title: const Text('Guide des Séries & Filières', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _series.length,
        itemBuilder: (context, index) {
          final s = _series[index];
          return _buildSeriesCard(context, s, isDark);
        },
      ),
    );
  }

  Widget _buildSeriesCard(BuildContext context, Map<String, dynamic> s, bool isDark) {
    final color = s['color'] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(s['icon'] as IconData, color: color, size: 24),
        ),
        title: Text(s['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        subtitle: Text(s['subtitle'] as String, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        expandedAlignment: Alignment.topLeft,
        children: [
          const Divider(),
          const SizedBox(height: 12),
          const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 6),
          Text(
            s['desc'] as String,
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, height: 1.5),
          ),
          const SizedBox(height: 16),
          const Text('Débouchés & Avenir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryLight)),
          const SizedBox(height: 6),
          Text(
            s['future'] as String,
            style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryLight),
          ),
        ],
      ),
    );
  }
}
