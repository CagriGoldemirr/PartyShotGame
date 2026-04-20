import 'package:flutter/material.dart';
import '../../game/widgets/drink_rain.dart';
import 'start_screen.dart';
import '../../game/screens/widgets/partyshot_logo.dart';


class CustomSplashScreen extends StatefulWidget {
  const CustomSplashScreen({super.key});

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StartScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C20),
      body: Stack(
        children: [
          const DrinkRain(), // Bardak animasyonu eklendi
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  const PartyShotLogo(fontSize: 48, iconSize: 40), // Logo eklendi
                
                const SizedBox(height: 30),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent.withOpacity(0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}