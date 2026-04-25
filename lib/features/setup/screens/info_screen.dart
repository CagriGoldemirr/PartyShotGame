import 'package:flutter/material.dart';
import '../../game/widgets/drink_rain.dart';
import '../../game/screens/widgets/partyshot_logo.dart';
import 'start_screen.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C20),
      body: Stack(
        children: [
          // 1. Arka Plan: Süzülen Bardaklar (Görsel devamlılık için)
          const Positioned.fill(child: DrinkRain()),

          // 2. Ana İçerik
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  
                  // Uygulama Logosu
                  const PartyShotLogo(fontSize: 42, iconSize: 38),
                  
                  const Spacer(),

                  // Bilgi Kartı (Neon & Cam Efekti)
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: const Color(0xFFE040FB).withValues(alpha: 0.3), 
                        width: 1.5
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE040FB).withValues(alpha: 0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "NASIL OYNANIR?",
                          style: TextStyle(
                            color: Color(0xFFF48FB1),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 25),
                        const Text(
                          "Party Shot'a Hoş Geldin! 🥂\n\n"
                          "Burada kural basit: Rulet döner, şanslı kişi seçilir. "
                          "Karttaki görevi ya cesaretle yaparsın ya da shot'ını yudumlarsın!\n\n"
                          "Oyun ilerledikçe görevler sertleşir, eğlence katlanır. "
                          "Hazırsan kadehini doldur ve arkadaşlarına katıl!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.6,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Geçiş Butonu
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: GestureDetector(
                      onTap: () {
                        // Bir sonraki ekrana (StartScreen) geçiş
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const StartScreen()),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 65,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE040FB), Color(0xFF673AB7)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE040FB).withValues(alpha: 0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            "ANLAŞILDI, BAŞLAYALIM!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}