import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme_provider.dart';
import 'screens/splash_screen.dart';
import 'services/llm_service.dart';
import 'services/model_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Précharge le LLM en arrière-plan si le modèle existe
  _preloadLlm();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const CareerGuideApp(),
    ),
  );
}

/// Lance l'init du LLM en arrière-plan dès le démarrage
/// L'utilisateur passe par Splash → WelcomeScreen → pendant ce temps le modèle charge
void _preloadLlm() {
  ModelService().modelExists().then((exists) {
    if (exists) {
      print('[MAIN] Model exists, preloading LLM...');
      LlmService().initialize().then((_) {
        print('[MAIN] LLM preloaded ✓');
      }).catchError((e) {
        print('[MAIN] LLM preload error: $e');
      });
    } else {
      print('[MAIN] Model not installed yet, skipping LLM preload');
    }
  });
}

class CareerGuideApp extends StatelessWidget {
  const CareerGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const SplashScreen(),
    );
  }
}