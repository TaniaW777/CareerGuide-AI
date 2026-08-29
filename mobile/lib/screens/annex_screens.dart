import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_colors.dart';
import 'institution_detail_screen.dart';
import 'career_paths_screen.dart';

class ScholarshipListScreen extends StatefulWidget {
  const ScholarshipListScreen({super.key});

  @override
  State<ScholarshipListScreen> createState() => _ScholarshipListScreenState();
}

class _ScholarshipListScreenState extends State<ScholarshipListScreen> {
  String _userLevel = '3ème';

  @override
  void initState() {
    super.initState();
    _loadUserLevel();
  }

  Future<void> _loadUserLevel() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userLevel = prefs.getString('user_classe') ?? '3ème';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scholarships = [
      {
        'title': 'Bourse d\'Excellence Gouvernementale',
        'amount': '500 000 FCFA',
        'deadline': '30 Juin 2025',
        'type': 'Nationale',
        'color': AppColors.primaryLight,
        'particularity': 'Réservée aux meilleurs élèves du pays.',
        'how_to_obtain': _userLevel == '3ème' 
            ? 'Avoir une moyenne > 16/20 au BEPC.' 
            : 'Avoir une mention Bien ou Très Bien au Bac.',
      },
      {
        'title': 'Bourse Union Africaine STEM',
        'amount': '1 200 000 FCFA',
        'deadline': '15 Juillet 2025',
        'type': 'Internationale',
        'color': Colors.green,
        'particularity': 'Soutien aux filières scientifiques et techniques.',
        'how_to_obtain': 'Inscription dans une filière C, D, E ou Ingénierie.',
      },
      {
        'title': 'Bourse Numérique & Entrepreneuriat',
        'amount': '350 000 FCFA',
        'deadline': '20 Mai 2025',
        'type': 'Privée',
        'color': Colors.orange,
        'particularity': 'Pour les projets innovants dans le digital.',
        'how_to_obtain': 'Présenter un projet de startup ou d\'application.',
      },
      {
        'title': 'Aide à la Formation Professionnelle',
        'amount': '200 000 FCFA',
        'deadline': '31 Août 2025',
        'type': 'ONG',
        'color': Colors.purple,
        'particularity': 'Soutien social pour les familles modestes.',
        'how_to_obtain': 'Fournir un certificat d\'indigence et être admis en centre de formation.',
      },
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      appBar: AppBar(
        title: const Text('Bourses disponibles', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
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
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade100),
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
                      child: Row(
                        children: [
                          Icon(
                            s['type'] == 'Nationale' ? Icons.flag :
                            s['type'] == 'Internationale' ? Icons.public :
                            s['type'] == 'Privée' ? Icons.business : Icons.volunteer_activism,
                            size: 12, color: color,
                          ),
                          const SizedBox(width: 4),
                          Text(s['type'] as String, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
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
                Text(s['title'] as String, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.monetization_on_outlined, color: color, size: 18),
                    const SizedBox(width: 6),
                    Text(s['amount'] as String, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                _detailItem(Icons.info_outline, 'Particularité', s['particularity'] as String, isDark),
                const SizedBox(height: 8),
                _detailItem(Icons.how_to_reg, 'Comment l\'obtenir', s['how_to_obtain'] as String, isDark),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _detailItem(IconData icon, String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.primaryLight),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryLight)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black87, height: 1.4)),
      ],
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
          CircleAvatar(radius: 28, backgroundColor: color.withValues(alpha: 0.1), child: Icon(icon, color: color, size: 28)),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.backgroundDark : Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            backgroundColor: color,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.white),
                onPressed: () => _showShareDialog(context, title),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(Icons.school, size: 80, color: Colors.white.withValues(alpha: 0.3)),
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
                  const Text('Compétences & Passions clés', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('Cliquez sur un élément pour comprendre l\'orientation', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFeedbackChip(context, 'Analyse de données', 'Compétence', 'Votre aisance avec les chiffres et les statistiques a été déterminante.', color),
                      _buildFeedbackChip(context, 'Innovation', 'Passion', 'Votre goût pour la nouveauté correspond parfaitement à ce métier.', color),
                      _buildFeedbackChip(context, 'Communication', 'Compétence', 'Votre capacité à transmettre des idées est un atout majeur.', color),
                      _buildFeedbackChip(context, 'Résolution de problèmes', 'Passion', 'Votre persévérance face aux défis a orienté ce choix.', color),
                    ],
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

  Widget _buildFeedbackChip(BuildContext context, String label, String type, String explanation, Color color) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                  child: Text(type, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
                Text(explanation, style: const TextStyle(height: 1.5)),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Compris')),
            ],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        );
      },
      child: Chip(
        label: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
        backgroundColor: color.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: color.withValues(alpha: 0.2))),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      appBar: AppBar(
        title: const Text('Instituts Privés', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildInstitut(context, 'Institut Supérieur de Technologies', 'Bobo-Dioulasso', 'Privé', 'Tech & Numérique', isDark, cardColor),
          const SizedBox(height: 16),
          _buildInstitut(context, 'École de Commerce du Sahel', 'Ouagadougou', 'Privé', 'Commerce & Finance', isDark, cardColor),
          const SizedBox(height: 16),
          _buildInstitut(context, 'Centre de Formation en Santé', 'Koudougou', 'Privé', 'Santé & Social', isDark, cardColor),
        ],
      ),
    );
  }

  Widget _buildInstitut(BuildContext context, String name, String loc, String type, String cat, bool isDark, Color cardColor) {
    IconData catIcon = Icons.business_rounded;
    if (cat.contains('Tech')) catIcon = Icons.computer_rounded;
    if (cat.contains('Commerce')) catIcon = Icons.payments_rounded;
    if (cat.contains('Santé')) catIcon = Icons.local_hospital_rounded;

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
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade100),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(catIcon, color: AppColors.primaryLight, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(loc, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
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

// -------------------------------------------------------------------------
// Settings Annex Screens
// -------------------------------------------------------------------------
class SimpleTextScreen extends StatelessWidget {
  final String title;
  final String content;

  const SimpleTextScreen({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Text(
          content,
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class InterestsSettingsScreen extends StatelessWidget {
  const InterestsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      appBar: AppBar(
        title: const Text('Centres d\'intérêt', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Modifiez vos domaines favoris', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
          const SizedBox(height: 16),
          CheckboxListTile(
            value: true,
            onChanged: (v) {},
            title: const Text('Science et Technologie'),
            activeColor: AppColors.primaryLight,
          ),
          CheckboxListTile(
            value: true,
            onChanged: (v) {},
            title: const Text('Commerce et Gestion'),
            activeColor: AppColors.primaryLight,
          ),
          CheckboxListTile(
            value: false,
            onChanged: (v) {},
            title: const Text('Santé et Bien Être'),
            activeColor: AppColors.primaryLight,
          ),
          CheckboxListTile(
            value: false,
            onChanged: (v) {},
            title: const Text('Art et Culture'),
            activeColor: AppColors.primaryLight,
          ),
        ],
      ),
    );
  }
}
