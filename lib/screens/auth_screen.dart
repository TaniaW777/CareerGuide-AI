import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/theme/app_colors.dart';
import 'main_navigation.dart';
import 'profile_setup_screen.dart';

class AuthScreen extends StatefulWidget {
  final bool isLoginMode;

  const AuthScreen({super.key, this.isLoginMode = false});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool isLogin;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLogin = widget.isLoginMode;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    
    if (isLogin) {
      // Login mode: Check if account exists
      if (email.isEmpty || password.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez remplir tous les champs.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      if (!emailRegex.hasMatch(email)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez entrer une adresse email valide.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      // Check if account exists in local storage
      final prefs = await SharedPreferences.getInstance();
      final existingAccounts = prefs.getStringList('registered_accounts') ?? [];
      
      if (!mounted) return;
      
      if (existingAccounts.contains(email)) {
        // Account exists, go to Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      } else {
        // Account doesn't exist, go to profile setup (account creation)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Compte non trouvé. Veuillez créer un nouveau compte.'),
            backgroundColor: Colors.orangeAccent,
          ),
        );
        // Switch to creation mode
        setState(() {
          isLogin = false;
          _passwordController.clear();
          _confirmPasswordController.clear();
        });
      }
      return;
    }

    // Account Creation mode validation
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs avant de continuer.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer une adresse email valide.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Password validation (at least 4 characters)
    if (password.length < 4) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le mot de passe doit contenir au moins 4 caractères.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Les mots de passe ne correspondent pas.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Check if account already exists
    final prefs = await SharedPreferences.getInstance();
    final existingAccounts = prefs.getStringList('registered_accounts') ?? [];
    
    if (existingAccounts.contains(email)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ce compte existe déjà. Veuillez vous connecter.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Save account email
    existingAccounts.add(email);
    await prefs.setStringList('registered_accounts', existingAccounts);
    await prefs.setString('current_user_email', email);

    if (!mounted) return;

    // Validation passed, navigate to profile setup
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryLight),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: size.height * 0.05),
              // Logo
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: size.height * 0.15,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.menu_book,
                    size: 100,
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // App Name
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'CareerGuide ',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.primaryLight,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextSpan(
                        text: 'AI',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.accentLight,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Forms
              _buildField('Email', 'exemple@gmail.com', controller: _emailController),
              const SizedBox(height: 24),
              _buildField('Mot de Passe', '********************', isPassword: true, controller: _passwordController),
              
              if (!isLogin) ...[
                const SizedBox(height: 24),
                _buildField('Confirmer Mot de Passe', '********************', isPassword: true, controller: _confirmPasswordController),
              ],
              
              if (isLogin) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Mot de Passe oublié ?',
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ] else ...[
                const SizedBox(height: 40),
              ],

              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                ),
                child: Text(
                  isLogin ? 'Se Connecter' : 'Creer compte',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              
              const SizedBox(height: 16),
              
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                    _emailController.clear();
                    _passwordController.clear();
                    _confirmPasswordController.clear();
                  });
                },
                child: Text(
                  isLogin ? 'Créer un compte' : 'Déjà un compte ? Se connecter',
                  style: TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String hint, {bool isPassword = false, required TextEditingController controller}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            fillColor: isDark ? AppColors.surfaceDark : Colors.white,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: isDark ? AppColors.borderDark : Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
