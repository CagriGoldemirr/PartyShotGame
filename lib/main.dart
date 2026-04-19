import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'core/theme/app_theme.dart';
// Yeni eklediğimiz yükleme ekranının importu
import 'features/setup/screens/custom_splash_screen.dart';
import 'features/setup/logic/setup_provider.dart';

void main() {
  runApp(const PartyShotApp());
}

class PartyShotApp extends StatelessWidget {
  const PartyShotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SetupProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false, 
        title: 'Party Shot Game',
        theme: AppTheme.darkTheme, 
        // Uygulamanın başlangıç noktası artık özel yükleme ekranımız
        home: const CustomSplashScreen(), 
      ),
    );
  }
}