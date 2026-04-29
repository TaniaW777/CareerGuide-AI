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
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primaryLight,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.primaryLight.withValues(alpha: 0.3),
                  child: const Icon(Icons.school, size: 80, color: Colors.white),
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
                      _tag(type, type == 'Public' ? Colors.blue : Colors.green),
                      const SizedBox(width: 8),
                      _tag(category, AppColors.primaryLight),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(location, style: const TextStyle(color: Colors.grey)),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const Icon(Icons.star_half, color: Colors.amber, size: 16),
                    const SizedBox(width: 8),
                    const Text('4.5 / 5', style: TextStyle(fontWeight: FontWeight.bold)),
                  ]),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  _sectionTitle('À propos'),
                  const SizedBox(height: 10),
                  const Text(
                    'Cet établissement offre une formation de qualité dans les domaines techniques et professionnels. Reconnu par le Ministère de l\'Éducation Nationale du Burkina Faso, il accueille chaque année plusieurs centaines d\'étudiants.',
                    style: TextStyle(fontSize: 15, height: 1.7, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle('Filières disponibles'),
                  const SizedBox(height: 12),
                  ...[
                    'Génie Logiciel',
                    'Électronique & Automatisme',
                    'Gestion des Entreprises',
                    'Agriculture & Agroalimentaire',
                  ].map((f) => _filiereItem(f)),
                  const SizedBox(height: 24),
                  _sectionTitle('Informations pratiques'),
                  const SizedBox(height: 12),
                  _infoItem(Icons.attach_money, 'Frais de scolarité', '150 000 - 400 000 FCFA / an'),
                  _infoItem(Icons.calendar_today, 'Rentrée', 'Octobre 2024'),
                  _infoItem(Icons.phone, 'Contact', '+226 25 33 00 00'),
                  _infoItem(Icons.email_outlined, 'Email', 'info@etablissement.bf'),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.share_outlined),
                          label: const Text('Partager'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ApplicationFormScreen(institutionName: name)),
                          ),
                          icon: const Icon(Icons.send_outlined),
                          label: const Text('Postuler maintenant'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryLight,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold));
  }

  Widget _filiereItem(String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.primaryLight, size: 18),
          const SizedBox(width: 10),
          Text(name, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryLight),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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
    if (_submitted) {
      return Scaffold(
        backgroundColor: Colors.white,
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
                const Text('Candidature envoyée !', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(
                  'Votre dossier pour ${widget.institutionName} a été transmis. Vous recevrez une réponse dans les 5 à 10 jours ouvrables.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.grey, height: 1.6),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => Navigator.of(context)..pop()..pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Formulaire de candidature'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
                  color: AppColors.primaryLight.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.school, color: AppColors.primaryLight),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.institutionName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _label('Nom complet'),
              const SizedBox(height: 8),
              _field('Votre nom et prénom', Icons.person_outline, validator: (v) => v!.isEmpty ? 'Requis' : null),
              const SizedBox(height: 18),
              _label('Email de contact'),
              const SizedBox(height: 8),
              _field('votremail@exemple.com', Icons.email_outlined, validator: (v) => v!.isEmpty ? 'Requis' : null),
              const SizedBox(height: 18),
              _label('Numéro de téléphone'),
              const SizedBox(height: 8),
              _field('+226 XX XX XX XX', Icons.phone_outlined),
              const SizedBox(height: 18),
              _label('Filière souhaitée'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedFiliere,
                style: const TextStyle(color: Colors.black, fontSize: 15),
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.book_outlined, color: AppColors.primaryLight),
                ),
                hint: const Text('Sélectionner une filière'),
                items: _filieres.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                onChanged: (v) => setState(() => _selectedFiliere = v),
                validator: (v) => v == null ? 'Veuillez choisir une filière' : null,
              ),
              const SizedBox(height: 18),
              _label('Message de motivation'),
              const SizedBox(height: 8),
              TextFormField(
                maxLines: 4,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Expliquez votre motivation...',
                  fillColor: Colors.white,
                  filled: true,
                  alignLabelWithHint: true,
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
                  backgroundColor: AppColors.primaryLight,
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

  Widget _label(String text) => Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14));

  Widget _field(String hint, IconData icon, {String? Function(String?)? validator}) {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(icon, color: AppColors.primaryLight),
      ),
    );
  }
}
