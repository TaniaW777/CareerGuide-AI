import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/theme_provider.dart';
import 'question_flow_screen.dart';
import 'advisor_chat_screen.dart';
import 'institutions_screen.dart';
import 'notifications_screen.dart';
import 'career_paths_screen.dart';
import 'annex_screens.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _searchQuery = '';
  
  final List<Map<String, dynamic>> _allRecommendations = [
    {
      'title': 'Ingénierie Logicielle',
      'subtitle': 'Basé sur vos intérêts en Tech',
      'icon': Icons.code,
      'color': Colors.blue,
      'desc': 'L\'ingénierie logicielle consiste à concevoir, développer et maintenir des systèmes informatiques complexes. C\'est un domaine clé pour l\'innovation numérique au Burkina Faso.',
      'tag': 'Secteur Porteur',
      'match': '94%',
    },
    {
      'title': 'Médecine Générale',
      'subtitle': 'Basé sur vos notes en SVT',
      'icon': Icons.medical_services_outlined,
      'color': Colors.red,
      'desc': 'La médecine générale est au cœur du système de santé. Ce parcours exige rigueur et passion pour le service public.',
      'tag': 'Impact Social',
      'match': '88%',
    },
    {
      'title': 'Agronomie & Elevage',
      'subtitle': 'Basé sur votre environnement',
      'icon': Icons.eco_outlined,
      'color': Colors.green,
      'desc': 'L\'agronomie moderne utilise la technologie pour améliorer les rendements agricoles et assurer la sécurité alimentaire.',
      'tag': 'Vital',
      'match': '82%',
    },
    {
      'title': 'Gestion des Entreprises',
      'subtitle': 'Basé sur vos tests de logique',
      'icon': Icons.trending_up,
      'color': Colors.orange,
      'desc': 'Apprenez à piloter des organisations et à entreprendre dans un marché africain en pleine mutation.',
      'tag': 'Leadership',
      'match': '75%',
    },
  ];

  List<Map<String, dynamic>> get _filteredRecommendations {
    if (_searchQuery.isEmpty) return _allRecommendations;
    return _allRecommendations.where((item) {
      return item['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
             item['subtitle'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, size, themeProvider),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuickActions(context),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recommandations pour vous',
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      if (_searchQuery.isNotEmpty)
                        Text(
                          '${_filteredRecommendations.length} trouvés',
                          style: const TextStyle(color: AppColors.primaryLight, fontSize: 12),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_filteredRecommendations.isEmpty)
                    _buildEmptyState(isDark)
                  else
                    ..._filteredRecommendations.map((rec) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildRecommendationCard(
                        context,
                        rec['title'],
                        rec['subtitle'],
                        rec['icon'],
                        rec['color'],
                        isDark,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CareerDetailScreen(
                              title: rec['title'],
                              match: rec['match'],
                              tag: rec['tag'],
                              desc: rec['desc'],
                              color: rec['color'],
                            ),
                          ),
                        ),
                      ),
                    )),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AdvisorChatScreen()));
        },
        label: const Text('IA Mentor', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.auto_awesome, color: Colors.white),
        backgroundColor: AppColors.primaryLight,
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(Icons.search_off_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Aucun résultat pour "$_searchQuery"',
            style: TextStyle(color: isDark ? Colors.white60 : Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Size size, ThemeProvider themeProvider) {
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    return Stack(
      children: [
        Container(
          height: size.height * 0.32,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.primaryLight,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bonjour,', 
                            style: TextStyle(color: Colors.white70)
                          ),
                          const Text(
                            'Jean Traoré',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () => themeProvider.toggleTheme(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.notifications_none, color: Colors.white),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: TextField(
                      style: const TextStyle(color: Colors.black),
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: const InputDecoration(
                        hintText: 'Rechercher une filière...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionItem(
          context,
          'Orientation',
          Icons.compass_calibration_outlined,
          Colors.orange,
          isDark,
          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuestionFlowScreen())),
        ),
        _buildActionItem(
          context,
          'Écoles',
          Icons.business_outlined,
          Colors.green,
          isDark,
          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const InstitutionsScreen())),
        ),
        _buildActionItem(
          context,
          'Métiers',
          Icons.work_outline,
          Colors.purple,
          isDark,
          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CareerPathsScreen())),
        ),
      ],
    );
  }

  Widget _buildActionItem(BuildContext context, String title, IconData icon, Color color, bool isDark, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            title, 
            style: TextStyle(
              fontWeight: FontWeight.w600, 
              fontSize: 13,
              color: isDark ? Colors.white70 : Colors.black87,
            )
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(BuildContext context, String title, String subtitle, IconData icon, Color color, bool isDark, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey[100]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    )
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle, 
                    style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.grey[600], 
                      fontSize: 12
                    )
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: isDark ? Colors.white30 : Colors.grey),
          ],
        ),
      ),
    );
  }
}
