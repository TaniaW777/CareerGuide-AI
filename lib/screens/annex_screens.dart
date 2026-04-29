import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'institution_detail_screen.dart';
import 'career_paths_screen.dart';

class ScholarshipListScreen extends StatelessWidget {
  const ScholarshipListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scholarships = [
      {
        'title': 'Bourse d\'Excellence Gouvernementale',
        'amount': '500 000 FCFA',
        'deadline': '30 Juin 2024',
        'type': 'Nationale',
        'color': AppColors.primaryLight,
      },
      {
        'title': 'Bourse Union Africaine STEM',
        'amount': '1 200 000 FCFA',
        'deadline': '15 Juillet 2024',
        'type': 'Internationale',
        'color': Colors.green,
      },
      {
        'title': 'Bourse Numérique & Entrepreneuriat',
        'amount': '350 000 FCFA',
        'deadline': '20 Mai 2024',
        'type': 'Privée',
        'color': Colors.orange,
      },
      {
        'title': 'Aide à la Formation Professionnelle',
        'amount': '200 000 FCFA',
        'deadline': '31 Août 2024',
        'type': 'ONG',
        'color': Colors.purple,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Bourses disponibles', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: scholarships.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, i) {
          final s = scholarships[i];
          final color = s['color'] as Color;
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(s['type'] as String, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 13, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('Limite: ${s['deadline']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(s['title'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.monetization_on_outlined, color: color, size: 18),
                    const SizedBox(width: 6),
                    Text(s['amount'] as String, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Déposer une candidature'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// -------------------------------------------------------------------------
// Career Detail Screen
// -------------------------------------------------------------------------
class CareerDetailScreen extends StatelessWidget {
  final String title;
  final String match;
  final String tag;
  final String desc;
  final Color color;

  const CareerDetailScreen({
    super.key,
    required this.title,
    required this.match,
    required this.tag,
    required this.desc,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            backgroundColor: color,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(Icons.work_outline, size: 80, color: Colors.white.withValues(alpha: 0.3)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(tag, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                      ),
                      const Spacer(),
                      Text(match, style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 6),
                      Text('MATCH', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Description', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(desc, style: const TextStyle(fontSize: 15, height: 1.7, color: Colors.black87)),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text('Compétences requises', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Analyse de données', 'Gestion de projet', 'Communication', 'Leadership', 'Innovation']
                        .map((s) => Chip(
                              label: Text(s, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                              backgroundColor: color.withValues(alpha: 0.1),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text('Débouchés au Burkina Faso', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ...[
                    'Ministère de l\'Agriculture',
                    'ONG et organisations internationales',
                    'Entreprises privées du secteur',
                    'Création de votre propre structure',
                  ].map((d) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_right, color: color),
                        const SizedBox(width: 8),
                        Expanded(child: Text(d, style: const TextStyle(fontSize: 14))),
                      ],
                    ),
                  )),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CareerPathsScreen()),
                    ),
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Voir toutes mes recommandations'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryLight,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------------
// Private Institutions Screen
// -------------------------------------------------------------------------
class PrivateInstitutionsScreen extends StatelessWidget {
  const PrivateInstitutionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Instituts Privés', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildInstitut(context, 'Institut Supérieur de Technologies', 'Bobo-Dioulasso', 'Privé', 'Tech & Numérique'),
          const SizedBox(height: 16),
          _buildInstitut(context, 'École de Commerce du Sahel', 'Ouagadougou', 'Privé', 'Commerce & Finance'),
          const SizedBox(height: 16),
          _buildInstitut(context, 'Centre de Formation en Santé', 'Koudougou', 'Privé', 'Santé & Social'),
        ],
      ),
    );
  }

  Widget _buildInstitut(BuildContext context, String name, String loc, String type, String cat) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => InstitutionDetailScreen(
            name: name, location: '$loc, Burkina Faso',
            category: cat, type: type,
            imageUrl: 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=500',
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.business, color: AppColors.primaryLight, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(loc, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(cat, style: const TextStyle(color: AppColors.primaryLight, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
