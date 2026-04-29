import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'main_navigation.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  int _currentStep = 1;
  final int _totalSteps = 3;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      body: Stack(
        children: [
          // Blue Header with Title
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.25,
            child: Container(
              color: isDark ? AppColors.surfaceDark : AppColors.primaryLight,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Profil Étudiant',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Étape $_currentStep sur $_totalSteps',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content Card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: size.height * 0.8,
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _currentStep / _totalSteps,
                      backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(isDark ? AppColors.primaryDark : AppColors.primaryLight),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 40),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          textTheme: Theme.of(context).textTheme.apply(
                            bodyColor: isDark ? Colors.white : Colors.black,
                            displayColor: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        child: _buildStepContent(),
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      if (_currentStep < _totalSteps) {
                        setState(() => _currentStep++);
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MainNavigation()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.primaryDark : AppColors.primaryLight,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(_currentStep == _totalSteps ? 'TERMINER' : 'SUIVANT'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Parlez-nous de vous', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    child: Icon(Icons.person, size: 50, color: Colors.grey[400]),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primaryLight,
                      child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildField('Nom', Icons.person_outline),
            const SizedBox(height: 16),
            _buildField('Prénom', Icons.person_outline),
            const SizedBox(height: 16),
            _buildField('Âge', Icons.calendar_today_outlined),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Informations académiques', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildDropdown('Niveau d\'étude', ['3ème', 'Seconde', 'Première', 'Terminale', 'Bac+1', 'Bac+2+']),
            const SizedBox(height: 16),
            _buildField('Région', Icons.location_on_outlined),
            const SizedBox(height: 16),
            _buildField('Email de contact', Icons.email_outlined),
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Vos objectifs et intérêts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Text('Centres d\'intérêt', style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildChip('Sciences'),
                _buildChip('Arts'),
                _buildChip('Technologie'),
                _buildChip('Santé'),
                _buildChip('Social'),
                _buildChip('Créatif'),
              ],
            ),
            const SizedBox(height: 24),
            _buildDropdown('Objectif principal', [
              'Orientation scolaire',
              'Orientation professionnelle',
              'Reconversion',
              'Information simple'
            ]),
          ],
        );
    }
  }

  Widget _buildField(String label, IconData icon) {
    return TextField(
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryLight),
        fillColor: Colors.white,
        filled: true,
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items) {
    return DropdownButtonFormField<String>(
      style: const TextStyle(color: Colors.black, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.list, color: AppColors.primaryLight),
        fillColor: Colors.white,
        filled: true,
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (v) {},
    );
  }

  Widget _buildChip(String label) {
    return FilterChip(
      label: Text(label),
      onSelected: (v) {},
      selectedColor: AppColors.primaryLight.withOpacity(0.2),
      checkmarkColor: AppColors.primaryLight,
    );
  }
}
