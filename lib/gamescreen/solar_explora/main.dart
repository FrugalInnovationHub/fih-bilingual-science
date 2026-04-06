import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_page.dart'; 
import 'tts_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await TTSService.initTTS();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const SolarExploraApp());
}

class SolarExploraApp extends StatelessWidget {
  const SolarExploraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SolarExplora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'ArialRoundedMTBold',
      ),
      home: const HomePage(),
    );
  }
}
