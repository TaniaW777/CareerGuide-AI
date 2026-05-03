import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'question_flow_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  int _currentStep = 1;
  final int _totalSteps = 3;

  // Step 1
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _selectedClasse;
  String? _selectedSerie;
  String? _selectedVille;
  final TextEditingController _otherClasseController = TextEditingController();
  final TextEditingController _otherSerieController = TextEditingController();

  // Step 2
  final Set<String> _selectedInterests = {};
  bool _showOtherInterestField = false;
  final TextEditingController _otherInterestController = TextEditingController();
  
  // Step 3
  final Set<String> _selectedSubjects = {};
  bool _showOtherSubjectField = false;
  final TextEditingController _otherSubjectController = TextEditingController();

  final List<String> _villes = [
    'Ouagadougou', 'Bobo-Dioulasso', 'Koudougou', 'Banfora', 'Ouahigouya', 
    'Kaya', 'Tenkodogo', 'Fada N\'Gourma', 'Dédougou', 'Dori'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _otherClasseController.dispose();
    _otherSerieController.dispose();
    _otherInterestController.dispose();
    _otherSubjectController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 1) {
      if (_nameController.text.trim().isEmpty || _ageController.text.trim().isEmpty || _selectedClasse == null || _selectedVille == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez remplir toutes les informations.'), backgroundColor: Colors.redAccent));
        return;
      }
      if (_selectedClasse == 'Autre' && _otherClasseController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez préciser votre classe.'), backgroundColor: Colors.redAccent));
        return;
      }
      if (_selectedClasse == 'Tle' && _selectedSerie == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez sélectionner votre série.'), backgroundColor: Colors.redAccent));
        return;
      }
      if (_selectedClasse == 'Tle' && _selectedSerie == 'Autre' && _otherSerieController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez préciser votre série.'), backgroundColor: Colors.redAccent));
        return;
      }
    } else if (_currentStep == 2) {
      if (_selectedInterests.isEmpty && (!_showOtherInterestField || _otherInterestController.text.trim().isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez sélectionner au moins un centre d\'intérêt.'), backgroundColor: Colors.redAccent));
        return;
      }
    } else if (_currentStep == 3) {
      if (_selectedSubjects.isEmpty && (!_showOtherSubjectField || _otherSubjectController.text.trim().isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez sélectionner au moins une matière.'), backgroundColor: Colors.redAccent));
        return;
      }
    }

    if (_currentStep < _totalSteps) {
      setState(() => _currentStep++);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const QuestionFlowScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryLight),
          onPressed: () {
            if (_currentStep > 1) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
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
                  Text('Etape $_currentStep sur $_totalSteps', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  if (_currentStep == 2)
                    Text('Ton profil commence à se dessiner', style: TextStyle(color: Colors.grey[600], fontSize: 12, fontStyle: FontStyle.italic)),
                ],
              ),
              const SizedBox(height: 10),
              // Progress Bar
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
                child: SingleChildScrollView(
                  child: _buildStepContent(isDark),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text(
                    'Continuer',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(bool isDark) {
    switch (_currentStep) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informations Personnelles',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 24),
            _buildTextField('Nom et Prénom', _nameController, isDark),
            const SizedBox(height: 16),
            _buildTextField('Âge', _ageController, isDark, isNumber: true),
            const SizedBox(height: 24),
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
                spacing: 12,
                runSpacing: 12,
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              items: _villes.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(color: isDark ? Colors.white : Colors.black)))).toList(),
              onChanged: (v) => setState(() => _selectedVille = v),
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quels sont tes centres d\'intérêts Principaux?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 16),
            Text(
              'Sélectionne les domaines qui t\'attirent le plus.',
              style: TextStyle(fontSize: 14, color: Colors.grey[500], height: 1.5),
            ),
            const SizedBox(height: 24),
            _buildInterestCard('Science et Technologie', 'Innovation, Recherche et Informatique', isDark),
            const SizedBox(height: 12),
            _buildInterestCard('Commerce et Gestion', 'Entreprenariat, Marketing et Finance', isDark),
            const SizedBox(height: 12),
            _buildInterestCard('Santé et Bien Être', 'Médecine, Soin et Bien être', isDark),
            const SizedBox(height: 12),
            _buildInterestCard('Art et Culture', 'Design, Musique et Patrimoine', isDark),
            const SizedBox(height: 12),
            
            // "Autre" Option
            GestureDetector(
              onTap: () {
                setState(() {
                  _showOtherInterestField = !_showOtherInterestField;
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _showOtherInterestField ? AppColors.primaryLight.withOpacity(0.1) : (isDark ? Colors.white10 : Colors.grey[100]),
                  border: Border.all(color: _showOtherInterestField ? AppColors.primaryLight : Colors.transparent, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    'Autre',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: _showOtherInterestField ? AppColors.primaryLight : (isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                ),
              ),
            ),
            if (_showOtherInterestField) ...[
              const SizedBox(height: 16),
              _buildTextField('Précisez votre intérêt', _otherInterestController, isDark),
            ]
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quelles matières préfères-tu à l\'école ?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 24),
            Text('Sciences', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500])),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildSubjectChip('Mathématiques', isDark),
                _buildSubjectChip('Physique-Chimie', isDark),
                _buildSubjectChip('SVT', isDark),
                _buildSubjectChip('Informatique', isDark),
              ],
            ),
            const SizedBox(height: 20),
            Text('Lettres & Langues', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500])),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildSubjectChip('Français', isDark),
                _buildSubjectChip('Anglais', isDark),
                _buildSubjectChip('Philosophie', isDark),
              ],
            ),
            const SizedBox(height: 20),
            Text('Autres', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500])),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildSubjectChip('Histoire-Géo', isDark),
                _buildSubjectChip('EPS', isDark),
                FilterChip(
                  label: const Text('Autre'),
                  selected: _showOtherSubjectField,
                  onSelected: (v) => setState(() => _showOtherSubjectField = v),
                  selectedColor: Colors.white,
                  checkmarkColor: AppColors.primaryLight,
                  backgroundColor: isDark ? Colors.white10 : Colors.grey[100],
                  labelStyle: TextStyle(
                    fontWeight: _showOtherSubjectField ? FontWeight.bold : FontWeight.normal,
                    color: _showOtherSubjectField ? Colors.black : (isDark ? Colors.white70 : Colors.black87),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: _showOtherSubjectField ? AppColors.primaryLight : Colors.transparent, width: _showOtherSubjectField ? 2 : 1),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ],
            ),
            if (_showOtherSubjectField) ...[
              const SizedBox(height: 16),
              _buildTextField('Précisez la matière', _otherSubjectController, isDark),
            ],
          ],
        );
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, bool isDark, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[500]),
        filled: true,
        fillColor: isDark ? Colors.white10 : Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
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
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black : (isDark ? Colors.white70 : Colors.black87),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectButtonCircle(String text, bool isSelected, Function(String) onTap, bool isDark) {
    return GestureDetector(
      onTap: () => onTap(text),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : (isDark ? Colors.white10 : Colors.grey[100]),
          shape: BoxShape.circle,
          border: Border.all(color: isSelected ? AppColors.primaryLight : Colors.transparent, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black : (isDark ? Colors.white70 : Colors.black87),
          ),
        ),
      ),
    );
  }

  Widget _buildInterestCard(String title, String subtitle, bool isDark) {
    final isSelected = _selectedInterests.contains(title);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedInterests.remove(title);
          } else {
            _selectedInterests.add(title);
          }
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : (isDark ? Colors.white10 : Colors.grey[100]),
          border: Border.all(color: isSelected ? AppColors.primaryLight : Colors.transparent, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isSelected ? Colors.black : (isDark ? Colors.white : Colors.black87),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.black54 : (isDark ? Colors.white60 : Colors.grey[600]),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectChip(String title, bool isDark) {
    final isSelected = _selectedSubjects.contains(title);
    return FilterChip(
      label: Text(title),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            _selectedSubjects.add(title);
          } else {
            _selectedSubjects.remove(title);
          }
        });
      },
      selectedColor: Colors.white,
      checkmarkColor: AppColors.primaryLight,
      backgroundColor: isDark ? Colors.white10 : Colors.grey[100],
      labelStyle: TextStyle(
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? Colors.black : (isDark ? Colors.white70 : Colors.black87),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primaryLight : Colors.transparent,
          width: isSelected ? 2 : 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}



