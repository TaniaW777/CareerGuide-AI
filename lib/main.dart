import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'screens/splash_screen.dart';
import 'core/theme/notification_provider.dart';
import 'core/theme/connectivity_provider.dart';
import 'services/database/database_initializer.dart';
import 'services/database/local_db.dart';
import 'services/local_ia/local_ai_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initDatabase();

  
  // Initialize offline AI system
  print("🤖 Initialisation du système IA offline...");
  await LocalAIService.initialize();
  
  print("✅ Application prête en mode OFFLINE!");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      ],
      child: const CareerGuideApp(),
    ),
  );
}

class CareerGuideApp extends StatelessWidget {
  const CareerGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'CareerGuideAI Burkina - 100% OFFLINE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const SplashScreen(),
    );
  }
}
