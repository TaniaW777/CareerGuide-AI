import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class InstitutionDetailScreen extends StatelessWidget {
  final String name;
  final String location;
  final String category;
  final String type;
  final String imageUrl;

  const InstitutionDetailScreen({
    super.key,
    required this.name,
    required this.location,
    required this.category,
    required this.type,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.backgroundDark : Colors.white;
    final cardBg = isDark ? AppColors.surfaceDark : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final secondaryColor = isDark ? Colors.white70 : Colors.grey;
    final appBarColor = isDark ? AppColors.primaryDark : AppColors.primaryLight;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: appBarColor,
            iconTheme: const IconThemeData(color: Colors.white),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Retour aux recommandations')));
                Navigator.pop(context);
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.network(
                  'https://images.unsplash.com/photo-1541339907198-e08756ebafe3?w=500&auto=format&fit=crop&q=60',
                  fit: BoxFit.cover,
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
                      _tag(type, type == 'Public' ? Colors.blue : Colors.green, isDark),
                      const SizedBox(width: 8),
                      _tag(category, AppColors.primaryLight, isDark),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 8),
                  Row(children: [
                    Icon(Icons.location_on_outlined, size: 16, color: secondaryColor),
                    const SizedBox(width: 6),
                    Expanded(child: Text(location, style: TextStyle(color: secondaryColor, fontSize: 13))),
                  ]),
                  const SizedBox(height: 16),
                  Divider(color: isDark ? AppColors.borderDark : Colors.grey[300]),
                  const SizedBox(height: 16),
                  _sectionTitle('À propos', Icons.info_outline, isDark),
                  const SizedBox(height: 10),
                  Text(
                    'Cet établissement offre une formation de qualité dans les domaines techniques et professionnels. Reconnu par le Ministère de l\'Éducation Nationale du Burkina Faso, il accueille chaque année plusieurs centaines d\'étudiants.',
                    style: TextStyle(fontSize: 15, height: 1.7, color: secondaryColor),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle('Filières disponibles', Icons.library_books_outlined, isDark),
                  const SizedBox(height: 12),
                  ...[
                    'Génie Logiciel',
                    'Électronique & Automatisme',
                    'Gestion des Entreprises',
                    'Agriculture & Agroalimentaire',
                  ].map((f) => _filiereItem(f, isDark)),
                  const SizedBox(height: 24),
                  _sectionTitle('Informations pratiques', Icons.contact_support_outlined, isDark),
                  const SizedBox(height: 12),
                  _infoItem(Icons.attach_money, 'Frais de scolarité', '150 000 - 400 000 FCFA / an', isDark),
                  _infoItem(Icons.calendar_today, 'Rentrée', 'Octobre 2024', isDark),
                  _infoItem(Icons.phone, 'Contact', '+226 25 33 00 00', isDark),
                  _infoItem(Icons.email_outlined, 'Email', 'info@etablissement.bf', isDark),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.share_outlined, color: appBarColor),
                      label: Text('Partager', style: TextStyle(color: appBarColor)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: appBarColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        backgroundColor: cardBg,
                      ),
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

  Widget _tag(String text, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? color.withValues(alpha: 0.18) : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _sectionTitle(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 18, color: isDark ? AppColors.primaryDark : AppColors.primaryLight),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
      ],
    );
  }

  Widget _filiereItem(String name, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: isDark ? AppColors.primaryDark : AppColors.primaryLight, size: 18),
          const SizedBox(width: 10),
          Text(name, style: TextStyle(fontSize: 15, color: isDark ? Colors.white70 : Colors.black87)),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: isDark ? AppColors.primaryDark : AppColors.primaryLight),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey)),
              Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black)),
            ],
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------
// Application Form Screen
// ------------------------------------------------------------------
class ApplicationFormScreen extends StatefulWidget {
  final String institutionName;
  const ApplicationFormScreen({super.key, required this.institutionName});

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedFiliere;
  bool _submitted = false;

  final List<String> _filieres = [
    'Génie Logiciel', 'Électronique & Automatisme',
    'Gestion des Entreprises', 'Agriculture & Agroalimentaire'
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.backgroundDark : Colors.white;
    final cardBg = isDark ? AppColors.surfaceDark : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final secondaryColor = isDark ? Colors.white70 : Colors.grey;
    final surfaceBorder = isDark ? AppColors.borderDark : Colors.grey.shade300;

    if (_submitted) {
      return Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, color: Colors.green, size: 72),
                ),
                const SizedBox(height: 28),
                Text('Candidature envoyée !', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
                const SizedBox(height: 12),
                Text(
                  'Votre dossier pour ${widget.institutionName} a été transmis. Vous recevrez une réponse dans les 5 à 10 jours ouvrables.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: secondaryColor, height: 1.6),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => Navigator.of(context)..pop()..pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Retour aux établissements'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Formulaire de candidature'),
        backgroundColor: cardBg,
        foregroundColor: textColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.primaryDark.withValues(alpha: 0.16) : AppColors.primaryLight.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(Icons.school, color: isDark ? AppColors.onPrimaryDark : AppColors.primaryLight),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.institutionName,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _label('Nom complet', isDark),
              const SizedBox(height: 8),
              _field('Votre nom et prénom', Icons.person_outline, isDark, validator: (v) => v!.isEmpty ? 'Requis' : null),
              const SizedBox(height: 18),
              _label('Email de contact', isDark),
              const SizedBox(height: 8),
              _field('votremail@exemple.com', Icons.email_outlined, isDark, validator: (v) => v!.isEmpty ? 'Requis' : null),
              const SizedBox(height: 18),
              _label('Numéro de téléphone', isDark),
              const SizedBox(height: 8),
              _field('+226 XX XX XX XX', Icons.phone_outlined, isDark),
              const SizedBox(height: 18),
              _label('Filière souhaitée', isDark),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedFiliere,
                style: TextStyle(color: textColor, fontSize: 15),
                decoration: InputDecoration(
                  fillColor: cardBg,
                  filled: true,
                  prefixIcon: Icon(Icons.book_outlined, color: AppColors.primaryLight),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: surfaceBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AppColors.primaryDark, width: 2),
                  ),
                ),
                hint: Text('Sélectionner une filière', style: TextStyle(color: secondaryColor)),
                items: _filieres.map((f) => DropdownMenuItem(value: f, child: Text(f, style: TextStyle(color: textColor)))).toList(),
                onChanged: (v) => setState(() => _selectedFiliere = v),
                validator: (v) => v == null ? 'Veuillez choisir une filière' : null,
              ),
              const SizedBox(height: 18),
              _label('Message de motivation', isDark),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 4,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Expliquez votre motivation...',
                  hintStyle: TextStyle(color: secondaryColor),
                  fillColor: cardBg,
                  filled: true,
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: surfaceBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: surfaceBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AppColors.primaryDark, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() => _submitted = true);
                  }
                },
                icon: const Icon(Icons.send),
                label: const Text('ENVOYER MA CANDIDATURE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text, bool isDark) => Text(text, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: isDark ? Colors.white : Colors.black));

  Widget _field(String hint, IconData icon, bool isDark, {String? Function(String?)? validator}) {
    return TextFormField(
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
        fillColor: isDark ? AppColors.surfaceDark : Colors.white,
        filled: true,
        prefixIcon: Icon(icon, color: AppColors.primaryLight),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: isDark ? AppColors.borderDark : Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: isDark ? AppColors.borderDark : Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primaryDark, width: 2),
        ),
      ),
    );
  }
}
