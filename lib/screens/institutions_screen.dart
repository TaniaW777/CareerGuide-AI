import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'institution_detail_screen.dart';
import 'annex_screens.dart';

class InstitutionsScreen extends StatefulWidget {
  const InstitutionsScreen({super.key});

  @override
  State<InstitutionsScreen> createState() => _InstitutionsScreenState();
}

class _InstitutionsScreenState extends State<InstitutionsScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'Tous';
  final List<String> _filters = ['Tous', 'Public', 'Privé'];

  final List<Map<String, String>> _institutions = [
    {
      'name': 'Lycée Polytechnique de Ouagadougou',
      'location': 'Ouagadougou, Burkina Faso',
      'category': 'Technique & Industriel',
      'type': 'Public',
      'image': 'https://images.unsplash.com/photo-1541339907198-e08756ebafe3?w=500&auto=format&fit=crop&q=60',
    },
    {
      'name': 'Institut Supérieur de Technologies',
      'location': 'Bobo-Dioulasso, Burkina Faso',
      'category': 'Informatique & Gestion',
      'type': 'Privé',
      'image': 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=500&auto=format&fit=crop&q=60',
    },
    {
      'name': 'Université Joseph Ki-Zerbo',
      'location': 'Ouagadougou, Burkina Faso',
      'category': 'Sciences & Lettres',
      'type': 'Public',
      'image': 'https://images.unsplash.com/photo-1562774053-701939374585?w=500&auto=format&fit=crop&q=60',
    },
    {
      'name': 'Centre de Formation en Santé',
      'location': 'Koudougou, Burkina Faso',
      'category': 'Santé & Social',
      'type': 'Privé',
      'image': 'https://images.unsplash.com/photo-1551601651-2a8555f1a136?w=500&auto=format&fit=crop&q=60',
    },
  ];

  List<Map<String, String>> get _filtered {
    return _institutions.where((inst) {
      final matchesSearch = _searchQuery.isEmpty ||
          inst['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          inst['category']!.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == 'Tous' || inst['type'] == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? AppColors.surfaceDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filtres avancés', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Text('Localisation', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              children: ['Ouagadougou', 'Bobo-Dioulasso', 'Koudougou'].map((city) => FilterChip(
                label: Text(city),
                onSelected: (v) {},
                selected: false,
              )).toList(),
            ),
            const SizedBox(height: 20),
            const Text('Niveau d\'étude', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              children: ['Baccalauréat', 'Licence', 'Master'].map((level) => FilterChip(
                label: Text(level),
                onSelected: (v) {},
                selected: false,
              )).toList(),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Appliquer les filtres'),
            ),
          ],
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
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
                      ),
                      child: TextField(
                        style: const TextStyle(color: Colors.black),
                        onChanged: (v) => setState(() => _searchQuery = v),
                        decoration: const InputDecoration(
                          hintText: 'Rechercher une école...',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
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
                  border: Border.all(color: AppColors.accentLight.withValues(alpha: 0.3)),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.accentLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.business, color: AppColors.accentLight, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Recommandations pour vous', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black)),
                          const SizedBox(height: 3),
                          const Text('Institut privé · Localisation proche', style: TextStyle(color: Colors.grey, fontSize: 12)),
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
              child: Row(
                children: [
                  Text('Établissements', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black)),
                  const Spacer(),
                  ..._filters.map((f) {
                    final isActive = f == _selectedFilter;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFilter = f),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primaryLight : cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isActive ? AppColors.primaryLight : Colors.grey.shade200),
                        ),
                        child: Text(f, style: TextStyle(color: isActive ? Colors.white : Colors.grey, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    );
                  }),
                ],
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
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4))],
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
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.school, size: 50, color: Colors.grey),
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
                      Row(children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 3),
                        const Text('4.5', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(inst['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.location_on_outlined, size: 13, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(inst['location']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ]),
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
                          ),
                          child: const Text('Détails'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ApplicationFormScreen(institutionName: inst['name']!)),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryLight,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Postuler'),
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
