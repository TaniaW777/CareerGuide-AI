import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'notification_detail_screen.dart';

class _NotifItem {
  final String title;
  final String body;
  final String time;
  final IconData icon;
  final Color color;
  final bool isNew;
  bool isRead;

  _NotifItem({
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
    required this.color,
    this.isNew = false,
    this.isRead = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<_NotifItem> _today;
  late List<_NotifItem> _earlier;

  @override
  void initState() {
    super.initState();
    _today = [
      _NotifItem(
        title: 'Nouvelle Recommandation',
        body: 'L\'IA a analysé votre profil et a trouvé une nouvelle filière qui vous correspond parfaitement : Ingénieur Agronome. Ce métier est en forte croissance au Burkina Faso et répond à vos centres d\'intérêt en sciences et technologie.',
        time: 'Il y a 5 min',
        icon: Icons.auto_awesome_outlined,
        color: AppColors.primaryLight,
        isNew: true,
      ),
      _NotifItem(
        title: 'Bourse disponible',
        body: 'Une nouvelle bourse d\'excellence gouvernementale est disponible pour l\'année 2024-2025. Montant : 500 000 FCFA. Date limite de dépôt : 30 juin 2024.',
        time: 'Il y a 1h',
        icon: Icons.school_outlined,
        color: Colors.orange,
        isNew: true,
      ),
    ];

    _earlier = [
      _NotifItem(
        title: 'Rappel de Profil',
        body: 'Votre profil est complété à 75%. Complétez vos centres d\'intérêt et votre niveau d\'étude pour obtenir des recommandations plus précises.',
        time: 'Hier, 14:30',
        icon: Icons.person_search_outlined,
        color: AppColors.accentLight,
      ),
      _NotifItem(
        title: 'Conseiller IA disponible',
        body: 'Votre mentor IA est prêt à discuter de vos choix d\'orientation. Posez vos questions et obtenez des conseils personnalisés basés sur votre profil.',
        time: '25 Avr, 09:15',
        icon: Icons.chat_bubble_outline,
        color: Colors.green,
      ),
      _NotifItem(
        title: 'Nouvelles écoles ajoutées',
        body: 'Nous avons ajouté 5 nouveaux établissements dans la région des Hauts-Bassins. Découvrez leurs filières et opportunités de formation.',
        time: '24 Avr, 18:00',
        icon: Icons.school_outlined,
        color: Colors.purple,
      ),
    ];
  }

  void _markAllRead() {
    setState(() {
      for (final n in [..._today, ..._earlier]) {
        n.isRead = true;
      }
    });
  }

  void _openDetail(_NotifItem item) {
    setState(() => item.isRead = true);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationDetailScreen(
          title: item.title,
          body: item.body,
          time: item.time,
          icon: item.icon,
          color: item.color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unreadCount = [..._today, ..._earlier].where((n) => !n.isRead && n.isNew).length;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
            if (unreadCount > 0) ...[
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('$unreadCount', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: Text('Tout lu', style: TextStyle(color: AppColors.primaryLight, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (_today.isNotEmpty) ...[
            _sectionHeader('Aujourd\'hui'),
            const SizedBox(height: 12),
            ..._today.map((n) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildCard(n),
            )),
          ],
          const SizedBox(height: 8),
          if (_earlier.isNotEmpty) ...[
            _sectionHeader('Plus tôt'),
            const SizedBox(height: 12),
            ..._earlier.map((n) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildCard(n),
            )),
          ],
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
    );
  }

  Widget _buildCard(_NotifItem item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isNew = item.isNew && !item.isRead;

    return GestureDetector(
      onTap: () => _openDetail(item),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDark
              : (isNew ? item.color.withValues(alpha: 0.04) : Colors.white),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isNew ? item.color.withValues(alpha: 0.15) : Colors.grey.shade100,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(item.icon, color: item.color, size: 22),
                ),
                if (isNew)
                  Positioned(
                    top: 0, right: 0,
                    child: Container(
                      width: 11, height: 11,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontWeight: isNew ? FontWeight.bold : FontWeight.w600,
                            fontSize: 14,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(item.time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.grey.shade600,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Voir les détails →',
                    style: TextStyle(
                      color: item.color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
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
