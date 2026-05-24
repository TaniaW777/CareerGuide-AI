import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../services/api_service.dart';
import 'main_navigation.dart';
import 'profile_setup_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _isLoading = false;

  void _submit() async {
    if (_nomController.text.isEmpty || _prenomController.text.isEmpty || 
        _telController.text.isEmpty || _ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez remplir tous les champs')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _apiService.identifyUser(
        _telController.text,
        _prenomController.text,
        _nomController.text,
        int.parse(_ageController.text),
      );

      if (!mounted) return;
      
      // Enregistrement de l'ID utilisateur pour la suite du parcours
      // Dans une app réelle, on utiliserait un Provider ou SharedPreferences
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text("Bienvenue sur CareerGuide AI", style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 30),
            _buildField('Nom', _nomController),
            _buildField('Prénom', _prenomController),
            _buildField('Téléphone', _telController, keyboardType: TextInputType.phone),
            _buildField('Âge', _ageController, keyboardType: TextInputType.number),
            const SizedBox(height: 30),
            _isLoading 
              ? const CircularProgressIndicator()
              : ElevatedButton(onPressed: _submit, child: const Text('Entrer dans l\'application')),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}
