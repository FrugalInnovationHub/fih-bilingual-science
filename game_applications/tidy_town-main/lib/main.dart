import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'services/redis_cache_service.dart';
import 'services/api_service.dart';
import 'services/cicd_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Redis cache service
  await RedisCacheService.instance.initialize();
  
  // Initialize API service for CI/CD automation
  await ApiService.instance.initialize();
  
  // Initialize CI/CD service
  CICDService.instance;
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tidy Town',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(), // 🏁 App starts here
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
