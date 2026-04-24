import 'package:flutter/material.dart';

class PartyShotLogo extends StatelessWidget {
  final double fontSize;
  final double iconSize;

  const PartyShotLogo({
    super.key, 
    this.fontSize = 42, // Yazı büyüklüğü
    this.iconSize = 36, // Kadeh büyüklüğü
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Sol Taraftaki Kadehler (Şarap ve Shot)
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wine_bar, color: Colors.pinkAccent, size: iconSize),
            const SizedBox(height: 5),
            Icon(Icons.local_drink, color: Colors.cyanAccent, size: iconSize * 0.7),
          ],
        ),
        
        const SizedBox(width: 15),
        
        // Mistik Neon Yazı (PARTY SHOT)
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.purpleAccent, Colors.cyanAccent, Colors.pinkAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            "PARTY\nSHOT",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
              height: 1.1, // İki kelime arası boşluğu sıkılaştırır
              shadows: [
                Shadow(color: Colors.purpleAccent.withOpacity(0.6), blurRadius: 20),
              ],
            ),
          ),
        ),
        
        const SizedBox(width: 15),

        // Sağ Taraftaki Kadehler (Shot ve Şarap - Simetrik)
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_drink, color: Colors.cyanAccent, size: iconSize * 0.7),
            const SizedBox(height: 5),
            Icon(Icons.wine_bar, color: Colors.pinkAccent, size: iconSize),
          ],
        ),
      ],
    );
  }
}
