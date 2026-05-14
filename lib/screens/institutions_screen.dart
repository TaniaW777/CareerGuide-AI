import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_colors.dart';
import 'institution_detail_screen.dart';
import 'annex_screens.dart';
import 'notifications_screen.dart';

class InstitutionsScreen extends StatefulWidget {
  const InstitutionsScreen({super.key});

  @override
  State<InstitutionsScreen> createState() => _InstitutionsScreenState();
}

class _InstitutionsScreenState extends State<InstitutionsScreen> {
  String _searchQuery = '';
  String _selectedType = 'Tous'; // Public, Privé
  String _selectedCategory = 'Tous'; // Lycée, Université, Institut
  String _selectedLevel = 'Tous'; // 3ème, Terminale, etc.
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

  final List<String> _types = ['Tous', 'Public', 'Privé'];
  final List<String> _categories = ['Tous', 'Lycée', 'Université', 'Institut'];
  final List<String> _levels = ['Tous', '3ème', 'Terminale', 'Post-Bac'];

  final List<Map<String, String>> _institutions = [
    {
      'name': 'Lycée Polytechnique de Ouagadougou',
      'location': 'Ouagadougou, Burkina Faso',
      'category': 'Lycée',
      'type': 'Public',
      'level': '3ème',
      'image': 'https://images.unsplash.com/photo-1541339907198-e08756ebafe3?w=500&auto=format&fit=crop&q=60',
    },
    {
      'name': 'Université Joseph Ki-Zerbo',
      'location': 'Ouagadougou, Burkina Faso',
      'category': 'Université',
      'type': 'Public',
      'level': 'Post-Bac',
      'reason': 'Choisie pour sa taille, sa réputation et ses filières clés en technologies et sciences sociales.',
      'image': 'https://images.unsplash.com/photo-1562774053-701939374585?w=500&auto=format&fit=crop&q=60',
    },
    {
      'name': 'Institut Supérieur de Technologies (IST)',
      'location': 'Bobo-Dioulasso, Burkina Faso',
      'category': 'Institut',
      'type': 'Privé',
      'level': 'Terminale',
      'reason': 'Bien adapté aux profils techniques qui cherchent une formation rapide et professionnalisante.',
      'image': 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=500&auto=format&fit=crop&q=60',
    },
    {
      'name': 'Lycée Technique de Bobo',
      'location': 'Bobo-Dioulasso, Burkina Faso',
      'category': 'Lycée',
      'type': 'Public',
      'level': '3ème',
      'reason': 'Tout proche de ton secteur, ce lycée est idéal pour une orientation technique et professionnelle après le BEPC.',
      'image': 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=500&auto=format&fit=crop&q=60',
    },
    {
      'name': 'Lycée Scientifique National',
      'location': 'Ouagadougou, Burkina Faso',
      'category': 'Lycée',
      'type': 'Public',
      'level': '3ème',
      'reason': 'Fort en sciences, il convient aux élèves intéressés par les séries C et D avec un bon encadrement pédagogique.',
      'image': 'https://images.unsplash.com/photo-1580582932707-520aed937b7b?w=500&auto=format&fit=crop&q=60',
    },
    {
      'name': 'Aube Nouvelle (ISIG)',
      'location': 'Ouagadougou, Burkina Faso',
      'category': 'Université',
      'type': 'Privé',
      'level': 'Terminale',
      'reason': 'Un établissement privé moderne reconnu pour ses filières en gestion et en droit.',
      'image': 'https://images.unsplash.com/photo-1525921429624-479b6a29d84c?w=500&auto=format&fit=crop&q=60',
    },
    {
      'name': 'Centre de Formation Professionnelle',
      'location': 'Koudougou, Burkina Faso',
      'category': 'Institut',
      'type': 'Public',
      'level': '3ème',
      'reason': 'Une option solide pour des diplômes professionnels courts et une insertion rapide sur le marché local.',
      'image': 'https://images.unsplash.com/photo-1551601651-2a8555f1a136?w=500&auto=format&fit=crop&q=60',
    },
  ];

  List<Map<String, String>> get _filtered {
    return _institutions.where((inst) {
      final matchesSearch = _searchQuery.isEmpty ||
          inst['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          inst['category']!.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesType = _selectedType == 'Tous' || inst['type'] == _selectedType;
      final matchesCategory = _selectedCategory == 'Tous' || inst['category'] == _selectedCategory;
      final matchesLevel = _selectedLevel == 'Tous' || inst['level'] == _selectedLevel;
      
      return matchesSearch && matchesType && matchesCategory && matchesLevel;
    }).toList();
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? AppColors.surfaceDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Filtres avancés', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Type d\'établissement', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                children: _categories.map((cat) => ChoiceChip(
                  label: Text(cat),
                  selected: _selectedCategory == cat,
                  onSelected: (v) => setModalState(() => setState(() => _selectedCategory = cat)),
                )).toList(),
              ),
              const SizedBox(height: 20),
              const Text('Niveau d\'étude cible', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                children: _levels.map((lvl) => ChoiceChip(
                  label: Text(lvl),
                  selected: _selectedLevel == lvl,
                  onSelected: (v) => setModalState(() => setState(() => _selectedLevel = lvl)),
                )).toList(),
              ),
              const SizedBox(height: 20),
              const Text('Secteur', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                children: _types.map((type) => ChoiceChip(
                  label: Text(type),
                  selected: _selectedType == type,
                  onSelected: (v) => setModalState(() => setState(() => _selectedType = type)),
                )).toList(),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Appliquer les filtres', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF7F8FA);
    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: bgColor,
            foregroundColor: isDark ? Colors.white : Colors.black,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.school_rounded, color: AppColors.primaryLight, size: 20),
                ),
                const SizedBox(width: 10),
                const Text('Établissements', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
              ),
            ],
          ),
          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: isDark ? Colors.black.withValues(alpha: 0.24) : Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
                        border: Border.all(color: isDark ? AppColors.borderDark : Colors.transparent),
                      ),
                      child: TextField(
                        style: TextStyle(color: isDark ? Colors.white : Colors.black),
                        onChanged: (v) => setState(() => _searchQuery = v),
                        decoration: InputDecoration(
                          hintText: 'Rechercher une école...',
                          hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          prefixIcon: Icon(Icons.search, color: isDark ? Colors.white60 : Colors.grey),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _showFilterOptions(context),
                    child: Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.tune, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scholarship Banner
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScholarshipListScreen())),
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryLight, Color(0xFF1A56DB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.school, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bourses Disponibles !', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                          SizedBox(height: 3),
                          Text('4 opportunités pour 2024-2025', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('Voir tout', style: TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Recommandations Privé Banner
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivateInstitutionsScreen())),
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: isDark ? AppColors.accentDark.withValues(alpha: 0.2) : AppColors.accentLight.withValues(alpha: 0.3)),
                  boxShadow: [BoxShadow(color: isDark ? Colors.black.withValues(alpha: 0.20) : Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.accentDark.withValues(alpha: 0.18) : AppColors.accentLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.business, color: isDark ? AppColors.accentDark : AppColors.accentLight, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Recommandations pour vous', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black)),
                          const SizedBox(height: 3),
                          Text(
                            _userLevel == '3ème' 
                              ? 'Lycées techniques · Orientation BEPC' 
                              : 'Universités publiques · Inscriptions Bacheliers',
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),

          // Filter chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text('Filtre rapide:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black)),
                    const SizedBox(width: 8),
                    ..._categories.map((f) {
                      final isActive = f == _selectedCategory;
                      IconData categoryIcon = Icons.category_outlined;
                      if (f == 'Lycée') categoryIcon = Icons.school_outlined;
                      if (f == 'Université') categoryIcon = Icons.account_balance_outlined;
                      if (f == 'Institut') categoryIcon = Icons.architecture_outlined;
                      if (f == 'Tous') categoryIcon = Icons.grid_view_rounded;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = f),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: isActive ? AppColors.primaryLight : cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isActive ? AppColors.primaryLight : (isDark ? AppColors.borderDark : Colors.grey.shade200)),
                          ),
                          child: Row(
                            children: [
                              Icon(categoryIcon, size: 14, color: isActive ? Colors.white : Colors.grey),
                              const SizedBox(width: 6),
                              Text(f, style: TextStyle(color: isActive ? Colors.white : Colors.grey, fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),


          // Institution cards list
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  if (i >= _filtered.length) return null;
                  final inst = _filtered[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildCard(context, inst, cardColor),
                  );
                },
                childCount: _filtered.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, String> inst, Color cardColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final type = inst['type']!;
    final typeColor = type == 'Public' ? Colors.blue : Colors.green;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => InstitutionDetailScreen(
            name: inst['name']!,
            location: inst['location']!,
            category: inst['category']!,
            type: inst['type']!,
            imageUrl: inst['image']!,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? AppColors.borderDark : Colors.transparent),
          boxShadow: [BoxShadow(color: isDark ? Colors.black.withValues(alpha: 0.20) : Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                inst['image']!,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 140,
                  width: double.infinity,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.grey[100],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.school_outlined, color: isDark ? Colors.white54 : Colors.grey.withValues(alpha: 0.5), size: 40),
                      const SizedBox(height: 8),
                      Text('Image non disponible', style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.withValues(alpha: 0.5), fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: typeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(type, style: TextStyle(color: typeColor, fontWeight: FontWeight.bold, fontSize: 10)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(inst['name']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.category_outlined, size: 12, color: isDark ? Colors.white70 : Colors.black54),
                            const SizedBox(width: 4),
                            Text(inst['category']!, style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    Icon(Icons.location_on_outlined, size: 13, color: isDark ? Colors.white60 : Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(child: Text(inst['location']!, style: TextStyle(color: isDark ? Colors.white70 : Colors.grey, fontSize: 12), overflow: TextOverflow.ellipsis)),
                  ]),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb_outline, size: 14, color: isDark ? AppColors.primaryLight : AppColors.primaryLight),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          inst['reason'] ?? 'Suggestion basée sur ton profil et les filières proposées.',
                          style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade700, fontSize: 12, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => InstitutionDetailScreen(
                                name: inst['name']!, location: inst['location']!,
                                category: inst['category']!, type: inst['type']!, imageUrl: inst['image']!,
                              ),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            side: BorderSide(color: isDark ? AppColors.primaryDark : AppColors.primaryLight),
                            foregroundColor: isDark ? Colors.white70 : AppColors.primaryLight,
                          ),
                          child: const Text('Détails'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
