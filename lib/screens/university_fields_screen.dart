import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class UniversityFieldsScreen extends StatelessWidget {
  const UniversityFieldsScreen({super.key});

  final List<Map<String, String>> _fields = const [
    {
      'title': 'Informatique & Technologies de l\'Information',
      'desc': 'Filières en informatique, télécommunications, génie logiciel et systèmes d\'information. Large demande en techniciens et ingénieurs. ',
    },
    {
      'title': 'Sciences de la Santé',
      'desc': 'Médecine, pharmacie, biologie et soins infirmiers. Demande forte au Burkina et dans la région.',
    },
    {
      'title': 'Génie & Ingénierie',
      'desc': 'Génie civil, mécanique, électrique, et énergétique. Filières recherchées pour les grands projets d\'infrastructure.',
    },
    {
      'title': 'Sciences Économiques & Gestion',
      'desc': 'Économie, gestion, comptabilité, finance et commerce. Bon débouché en entreprises et administration.',
    },
    {
      'title': 'Agronomie & Environnement',
      'desc': 'Agronomie, agroécologie, gestion des ressources naturelles et environnement. Important pour le développement local.',
    },
    {
      'title': 'Lettres, Arts & Communication',
      'desc': 'Journalisme, communication, langues, arts plastiques et gestion culturelle.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filières universitaires au Burkina'),
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF7F8FA),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _fields.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final f = _fields[i];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: isDark ? Border.all(color: AppColors.borderDark) : Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(f['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text(f['desc']!, style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade800)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark ? AppColors.surfaceDark : Colors.white,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Partager / Voir établissements', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 12),
                                Text('Cette fonctionnalité fonctionne hors-ligne et permet de partager localement le descriptif.', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.grey.shade700)),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                        Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Partage via Bluetooth (simulé)')));
                                        },
                                        icon: const Icon(Icons.bluetooth),
                                        label: const Text('Partager via Bluetooth'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ouverture de la liste des établissements (placeholder)')));
                                        },
                                        icon: const Icon(Icons.school),
                                        label: const Text('Voir établissements'),
                                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryLight),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryLight),
                      child: const Text('Voir établissements'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(f['title']!),
                          content: Text('Informations détaillées:\n\n${f['desc']}'),
                          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer'))],
                        ),
                      ),
                      child: const Text('Détails'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
