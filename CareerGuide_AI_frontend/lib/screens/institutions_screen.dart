import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_colors.dart';
import 'institution_detail_screen.dart';
import 'notifications_screen.dart';
import '../services/database/local_db.dart';

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

  final List<String> _types = ['Tous', 'Public', 'Privé'];
  final List<String> _categories = ['Tous', 'Lycée', 'Université', 'Institut'];
  final List<String> _levels = ['Tous', '3ème', 'Terminale', 'Post-Bac'];

  List<Map<String, dynamic>> _institutions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserLevel();
    _fetchInstitutions();
  }

  Future<void> _loadUserLevel() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userLevel = prefs.getString('user_classe') ?? '3ème';
    });
  }

  Future<void> _fetchInstitutions() async {
    try {
      final db = await LocalDatabase.database;
      final List<Map<String, dynamic>> data = await db.query('universities');
      
      setState(() {
        _institutions = data.map((item) => {
          'name': item['name'].toString(),
          'location': item['city'].toString(),
          'category': item['category'].toString(),
          'type': item['type'].toString(),
          'level': item['level'].toString(),
          'image': item['image_url'] ?? 'https://via.placeholder.com/150',
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading local institutions: $e');
      setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get _filtered {
    return _institutions.where((inst) {
      final matchesSearch = _searchQuery.isEmpty ||
          inst['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          inst['category'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesType = _selectedType == 'Tous' || inst['type'] == _selectedType;
      final matchesCategory = _selectedCategory == 'Tous' || inst['category'] == _selectedCategory;
      final matchesLevel = _selectedLevel == 'Tous' || inst['level'] == _selectedLevel;
      return matchesSearch && matchesType && matchesCategory && matchesLevel;
    }).toList();
  }

  List<String> get _availableCategories {
    return ['Tous', 'Lycée', 'Université', 'Institut'];
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
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : CustomScrollView(
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
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> inst, Color cardColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final type = inst['type'] ?? 'Privé';
    final typeColor = type == 'Public' ? Colors.blue : Colors.green;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => InstitutionDetailScreen(
            name: inst['name']!,
            location: inst['location']!,
            category: inst['category']!,
            type: type,
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
                  color: isDark ? Colors.white10 : Colors.grey[100],
                  child: Center(child: Icon(Icons.school_outlined, color: isDark ? Colors.white54 : Colors.grey.withValues(alpha: 0.5), size: 40)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: typeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                    child: Text(type, style: TextStyle(color: typeColor, fontWeight: FontWeight.bold, fontSize: 10)),
                  ),
                  const SizedBox(height: 10),
                  Text(inst['name']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black)),
                  const SizedBox(height: 6),
                  Text(inst['location']!, style: TextStyle(color: isDark ? Colors.white70 : Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
