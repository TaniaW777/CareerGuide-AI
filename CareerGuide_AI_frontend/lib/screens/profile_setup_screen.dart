import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_colors.dart';
import 'question_flow_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> with SingleTickerProviderStateMixin {
  int _currentStep = 1;
  final int _totalSteps = 4;

  // Step 1 - Identity
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  // Step 2 - Academic
  String? _selectedClasse;
  String? _selectedSerie;
  String? _selectedVille;
  final TextEditingController _otherClasseController = TextEditingController();
  final TextEditingController _otherSerieController = TextEditingController();

  // Step 3 - Interests
  final Set<String> _selectedInterests = {};
  bool _showOtherInterestField = false;
  final TextEditingController _otherInterestController = TextEditingController();

  // Step 4 - Subjects
  final Set<String> _selectedSubjects = {};
  bool _showOtherSubjectField = false;
  final TextEditingController _otherSubjectController = TextEditingController();

  final List<String> _villes = [
    'Ouagadougou', 'Bobo-Dioulasso', 'Koudougou', 'Banfora', 'Ouahigouya',
    'Kaya', 'Tenkodogo', 'Fada N\'Gourma', 'Dédougou', 'Dori'
  ];

  bool _isTransitioning = false;
  late AnimationController _transitionController;
  late Animation<double> _transitionFade;
  late Animation<double> _transitionScale;

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    _transitionFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _transitionController, curve: const Interval(0.0, 0.4, curve: Curves.easeOut)),
    );
    _transitionScale = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _transitionController, curve: const Interval(0.0, 0.4, curve: Curves.easeOut)),
    );
    _transitionController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (_, __, ___) => QuestionFlowScreen(selectedClasse: _selectedClasse ?? '3ème'),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
                      .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                  child: child,
                ),
              );
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _ageController.dispose();
    _contactController.dispose();
    _otherClasseController.dispose();
    _otherSerieController.dispose();
    _otherInterestController.dispose();
    _otherSubjectController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 1) {
      if (_nomController.text.trim().isEmpty || _prenomController.text.trim().isEmpty || _ageController.text.trim().isEmpty || _contactController.text.trim().isEmpty) {
        _showError('Veuillez remplir tous les champs.');
        return;
      }
    } else if (_currentStep == 2) {
      if (_selectedClasse == null || _selectedVille == null) {
        _showError('Veuillez remplir toutes les informations.');
        return;
      }
      if (_selectedClasse == 'Autre' && _otherClasseController.text.trim().isEmpty) {
        _showError('Veuillez préciser votre classe.');
        return;
      }
      if (_selectedClasse == 'Tle' && _selectedSerie == null) {
        _showError('Veuillez sélectionner votre série.');
        return;
      }
      if (_selectedClasse == 'Tle' && _selectedSerie == 'Autre' && _otherSerieController.text.trim().isEmpty) {
        _showError('Veuillez préciser votre série.');
        return;
      }
    } else if (_currentStep == 3) {
      if (_selectedInterests.isEmpty && (!_showOtherInterestField || _otherInterestController.text.trim().isEmpty)) {
        _showError('Veuillez sélectionner au moins un centre d\'intérêt.');
        return;
      }
    } else if (_currentStep == 4) {
      if (_selectedSubjects.isEmpty && (!_showOtherSubjectField || _otherSubjectController.text.trim().isEmpty)) {
        _showError('Veuillez sélectionner au moins une matière.');
        return;
      }
    }

    if (_currentStep < _totalSteps) {
      setState(() => _currentStep++);
    } else {
      // Trigger transition animation then navigate
      _saveProfileAndNavigate();
    }
  }

  Future<void> _saveProfileAndNavigate() async {
    setState(() => _isTransitioning = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_nom', _nomController.text.trim());
      await prefs.setString('user_prenom', _prenomController.text.trim());
      await prefs.setString('user_age', _ageController.text.trim());
      await prefs.setString('user_contact', _contactController.text.trim());
      await prefs.setString('user_classe', _selectedClasse ?? '3ème');
      await prefs.setString('user_ville', _selectedVille ?? '');
      
      if (_selectedClasse == 'Autre') {
        await prefs.setString('user_classe_autre', _otherClasseController.text.trim());
      }
      
      if (_selectedClasse == 'Tle') {
        await prefs.setString('user_serie', _selectedSerie ?? '');
      }

      // Save interests
      await prefs.setStringList('user_interests', _selectedInterests.toList());
      // Save subjects
      await prefs.setStringList('user_subjects', _selectedSubjects.toList());

    } catch (e) {
      debugPrint('Error saving profile: $e');
    }

    _transitionController.forward();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.redAccent));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget body = Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentStep > 1
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.primaryLight),
                onPressed: () => setState(() => _currentStep--),
              )
            : null,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('CareerGuide ', style: TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.bold, fontSize: 18)),
            Text('AI', style: TextStyle(color: AppColors.accentLight, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Étape $_currentStep sur $_totalSteps', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  if (_currentStep == 1)
                    Text('Inscription', style: TextStyle(color: AppColors.primaryLight, fontSize: 12, fontWeight: FontWeight.w600)),
                  if (_currentStep == 3)
                    Text('Ton profil commence à se dessiner', style: TextStyle(color: Colors.grey[600], fontSize: 12, fontStyle: FontStyle.italic)),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: _currentStep / _totalSteps,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
                  minHeight: 12,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(child: _buildStepContent(isDark)),
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7, // 70% de la largeur
                  child: ElevatedButton(
                    onPressed: _isTransitioning ? null : _nextStep,
                    child: Text(
                      _currentStep == _totalSteps ? 'Terminer l\'inscription' : 'Continuer',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );

    // Wrap with transition animation
    if (_isTransitioning) {
      return AnimatedBuilder(
        animation: _transitionController,
        builder: (context, child) {
          return Stack(
            children: [
              // Fading out current screen
              Opacity(
                opacity: _transitionFade.value,
                child: Transform.scale(scale: _transitionScale.value, child: body),
              ),
              // Transition overlay
              Opacity(
                opacity: 1 - _transitionFade.value,
                child: Scaffold(
                  backgroundColor: AppColors.primaryLight,
                  body: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 50, height: 50,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withValues(alpha: 0.9)),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text('Préparation du questionnaire IA...', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Text('Un instant s\'il vous plaît', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
    return body;
  }

  Widget _buildStepContent(bool isDark) {
    switch (_currentStep) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.person_add_outlined, size: 40, color: AppColors.primaryLight),
            const SizedBox(height: 12),
            Text('Inscription', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
            const SizedBox(height: 6),
            Text('Parle-nous un peu de toi pour commencer.', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
            const SizedBox(height: 28),
            _buildTextField('Nom', _nomController, isDark, icon: Icons.badge_outlined, isLettersOnly: true),
            const SizedBox(height: 16),
            _buildTextField('Prénom', _prenomController, isDark, icon: Icons.person_outline, isLettersOnly: true),
            const SizedBox(height: 16),
            _buildTextField('Âge', _ageController, isDark, isNumber: true, icon: Icons.cake_outlined),
            const SizedBox(height: 16),
            _buildTextField('Contact (téléphone)', _contactController, isDark, isPhone: true, icon: Icons.phone_outlined),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.school_outlined, size: 40, color: AppColors.primaryLight),
            const SizedBox(height: 12),
            Text('Informations Scolaires', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
            const SizedBox(height: 6),
            Text('Dis-nous où tu en es dans ton parcours.', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
            const SizedBox(height: 28),
            Text('Classe actuelle', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildSelectButton('3ème', _selectedClasse == '3ème', (v) => setState(() => _selectedClasse = v), isDark)),
                const SizedBox(width: 10),
                Expanded(child: _buildSelectButton('Tle', _selectedClasse == 'Tle', (v) => setState(() => _selectedClasse = v), isDark)),
                const SizedBox(width: 10),
                Expanded(child: _buildSelectButton('Autre', _selectedClasse == 'Autre', (v) => setState(() => _selectedClasse = v), isDark)),
              ],
            ),
            if (_selectedClasse == 'Autre') ...[
              const SizedBox(height: 16),
              _buildTextField('Précisez votre classe', _otherClasseController, isDark),
            ],
            if (_selectedClasse == 'Tle') ...[
              const SizedBox(height: 24),
              Text('Série ou Option', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12, runSpacing: 12,
                children: ['A', 'D', 'C', 'E', 'F', 'Autre'].map((serie) {
                  return _buildSelectButtonCircle(serie, _selectedSerie == serie, (v) => setState(() => _selectedSerie = v), isDark);
                }).toList(),
              ),
              if (_selectedSerie == 'Autre') ...[
                const SizedBox(height: 16),
                _buildTextField('Précisez votre série', _otherSerieController, isDark),
              ],
            ],
            const SizedBox(height: 24),
            Text('Localisation', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedVille,
              hint: const Text('Choisissez votre ville'),
              dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? Colors.white10 : Colors.grey[50],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                prefixIcon: Icon(Icons.location_on_outlined, color: Colors.grey[400]),
              ),
              items: _villes.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(color: isDark ? Colors.white : Colors.black)))).toList(),
              onChanged: (v) => setState(() => _selectedVille = v),
            ),
          ],
        );
      case 3:
        // Different interests based on selected class
        final bool isTle = _selectedClasse == 'Tle';
        final interestsForClasse = isTle
            ? [
                {'title': 'Sciences & Ingénierie', 'subtitle': 'Recherche, Technologies avancées et Innovation'},
                {'title': 'Médecine & Santé', 'subtitle': 'Médecine, Pharmacie, Biologie et Soins'},
                {'title': 'Économie & Gestion', 'subtitle': 'Finance, Comptabilité, Management et Commerce'},
                {'title': 'Droit & Sciences Politiques', 'subtitle': 'Juridique, Relations internationales et Diplomatie'},
                {'title': 'Informatique & Numérique', 'subtitle': 'Développement, IA, Cybersécurité et Data Science'},
                {'title': 'Art, Lettres & Communication', 'subtitle': 'Journalisme, Design, Littérature et Médias'},
              ]
            : [
                {'title': 'Science et Technologie', 'subtitle': 'Innovation, Recherche et Informatique'},
                {'title': 'Commerce et Gestion', 'subtitle': 'Entreprenariat, Marketing et Finance'},
                {'title': 'Santé et Bien Être', 'subtitle': 'Médecine, Soin et Bien être'},
                {'title': 'Art et Culture', 'subtitle': 'Design, Musique et Patrimoine'},
              ];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.interests_outlined, size: 40, color: AppColors.primaryLight),
            const SizedBox(height: 12),
            Text('Quels sont tes centres d\'intérêts ?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
            const SizedBox(height: 6),
            Text(
              isTle
                  ? 'En Terminale, précise les domaines d\'études supérieures qui t\'attirent.'
                  : 'Sélectionne les domaines qui t\'attirent le plus.',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            const SizedBox(height: 24),
            ...interestsForClasse.map((interest) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildInterestCard(interest['title']!, interest['subtitle']!, isDark),
            )),
            GestureDetector(
              onTap: () => setState(() => _showOtherInterestField = !_showOtherInterestField),
              child: Container(
                width: double.infinity, padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _showOtherInterestField ? AppColors.primaryLight.withValues(alpha: 0.1) : (isDark ? Colors.white10 : Colors.grey[100]),
                  border: Border.all(color: _showOtherInterestField ? AppColors.primaryLight : Colors.transparent, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(child: Text('Autre', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _showOtherInterestField ? AppColors.primaryLight : (isDark ? Colors.white : Colors.black87)))),
              ),
            ),
            if (_showOtherInterestField) ...[
              const SizedBox(height: 16),
              _buildTextField('Précisez votre intérêt', _otherInterestController, isDark),
            ],
          ],
        );
      default:
        final bool isTleStep4 = _selectedClasse == 'Tle';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.menu_book_outlined, size: 40, color: AppColors.primaryLight),
            const SizedBox(height: 12),
            Text(
              isTleStep4 ? 'Quelles matières maîtrises-tu le mieux ?' : 'Quelles matières préfères-tu ?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 6),
            Text(
              isTleStep4
                  ? 'Indique tes points forts pour affiner ton orientation post-bac.'
                  : 'Sélectionne les matières que tu aimes.',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            const SizedBox(height: 24),
            if (isTleStep4) ...[
              // Tle: more detailed subject categories
              Text('Sciences Exactes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500])),
              const SizedBox(height: 12),
              Wrap(spacing: 12, runSpacing: 12, children: [
                _buildSubjectChip('Mathématiques', isDark), _buildSubjectChip('Physique-Chimie', isDark),
                _buildSubjectChip('SVT', isDark), _buildSubjectChip('Informatique', isDark),
              ]),
              const SizedBox(height: 20),
              Text('Sciences Humaines', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500])),
              const SizedBox(height: 12),
              Wrap(spacing: 12, runSpacing: 12, children: [
                _buildSubjectChip('Philosophie', isDark), _buildSubjectChip('Histoire-Géo', isDark),
                _buildSubjectChip('Économie', isDark), _buildSubjectChip('Sociologie', isDark),
              ]),
              const SizedBox(height: 20),
              Text('Langues & Communication', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500])),
              const SizedBox(height: 12),
              Wrap(spacing: 12, runSpacing: 12, children: [
                _buildSubjectChip('Français', isDark), _buildSubjectChip('Anglais', isDark),
                _buildSubjectChip('Allemand', isDark), _buildSubjectChip('Espagnol', isDark),
              ]),
            ] else ...[
              // 3ème: simpler subject categories
              Text('Sciences', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500])),
              const SizedBox(height: 12),
              Wrap(spacing: 12, runSpacing: 12, children: [
                _buildSubjectChip('Mathématiques', isDark), _buildSubjectChip('Physique-Chimie', isDark),
                _buildSubjectChip('SVT', isDark), _buildSubjectChip('Informatique', isDark),
              ]),
              const SizedBox(height: 20),
              Text('Lettres & Langues', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500])),
              const SizedBox(height: 12),
              Wrap(spacing: 12, runSpacing: 12, children: [
                _buildSubjectChip('Français', isDark), _buildSubjectChip('Anglais', isDark), _buildSubjectChip('Philosophie', isDark),
              ]),
            ],
            const SizedBox(height: 20),
            Text('Autres', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500])),
            const SizedBox(height: 12),
            Wrap(spacing: 12, runSpacing: 12, children: [
              _buildSubjectChip('Histoire-Géo', isDark), _buildSubjectChip('EPS', isDark),
              FilterChip(
                label: const Text('Autre'), selected: _showOtherSubjectField,
                onSelected: (v) => setState(() => _showOtherSubjectField = v),
                selectedColor: Colors.white, checkmarkColor: AppColors.primaryLight,
                backgroundColor: isDark ? Colors.white10 : Colors.grey[100],
                labelStyle: TextStyle(fontWeight: _showOtherSubjectField ? FontWeight.bold : FontWeight.normal, color: _showOtherSubjectField ? Colors.black : (isDark ? Colors.white70 : Colors.black87)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: _showOtherSubjectField ? AppColors.primaryLight : Colors.transparent, width: _showOtherSubjectField ? 2 : 1)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ]),
            if (_showOtherSubjectField) ...[
              const SizedBox(height: 16),
              _buildTextField('Précisez la matière', _otherSubjectController, isDark),
            ],
          ],
        );
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, bool isDark, {bool isNumber = false, bool isPhone = false, bool isLettersOnly = false, IconData? icon}) {
    // Build input formatters based on field type
    List<TextInputFormatter> formatters = [];
    if (isLettersOnly) {
      // Only allow letters (including accented characters), spaces, and hyphens
      formatters.add(FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZÀ-ÿ\s\-\']")));
    } else if (isNumber) {
      formatters.add(FilteringTextInputFormatter.digitsOnly);
    } else if (isPhone) {
      // Allow digits, +, spaces, and hyphens for phone numbers
      formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s]')));
    }

    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : (isPhone ? TextInputType.phone : TextInputType.text),
      inputFormatters: formatters.isNotEmpty ? formatters : null,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: label, labelStyle: TextStyle(color: Colors.grey[500]),
        filled: true, fillColor: isDark ? Colors.white10 : Colors.grey[50],
        prefixIcon: icon != null ? Icon(icon, color: Colors.grey[400]) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        helperText: isLettersOnly ? 'Lettres uniquement' : (isNumber ? 'Chiffres uniquement' : null),
        helperStyle: TextStyle(color: Colors.grey[400], fontSize: 11),
      ),
    );
  }

  Widget _buildSelectButton(String text, bool isSelected, Function(String) onTap, bool isDark) {
    return GestureDetector(
      onTap: () => onTap(text),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : (isDark ? Colors.white10 : Colors.grey[100]),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? AppColors.primaryLight : Colors.transparent, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.black : (isDark ? Colors.white70 : Colors.black87))),
      ),
    );
  }

  Widget _buildSelectButtonCircle(String text, bool isSelected, Function(String) onTap, bool isDark) {
    return GestureDetector(
      onTap: () => onTap(text),
      child: Container(
        width: 50, height: 50,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : (isDark ? Colors.white10 : Colors.grey[100]),
          shape: BoxShape.circle,
          border: Border.all(color: isSelected ? AppColors.primaryLight : Colors.transparent, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.black : (isDark ? Colors.white70 : Colors.black87))),
      ),
    );
  }

  Widget _buildInterestCard(String title, String subtitle, bool isDark) {
    final isSelected = _selectedInterests.contains(title);
    return GestureDetector(
      onTap: () => setState(() => isSelected ? _selectedInterests.remove(title) : _selectedInterests.add(title)),
      child: Container(
        width: double.infinity, padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : (isDark ? Colors.white10 : Colors.grey[100]),
          border: Border.all(color: isSelected ? AppColors.primaryLight : Colors.transparent, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isSelected ? Colors.black : (isDark ? Colors.white : Colors.black87)), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 12, color: isSelected ? Colors.black54 : (isDark ? Colors.white60 : Colors.grey[600])), textAlign: TextAlign.center),
        ]),
      ),
    );
  }

  Widget _buildSubjectChip(String title, bool isDark) {
    final isSelected = _selectedSubjects.contains(title);
    return FilterChip(
      label: Text(title), selected: isSelected,
      onSelected: (s) => setState(() => s ? _selectedSubjects.add(title) : _selectedSubjects.remove(title)),
      selectedColor: Colors.white, checkmarkColor: AppColors.primaryLight,
      backgroundColor: isDark ? Colors.white10 : Colors.grey[100],
      labelStyle: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.black : (isDark ? Colors.white70 : Colors.black87)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isSelected ? AppColors.primaryLight : Colors.transparent, width: isSelected ? 2 : 1)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
