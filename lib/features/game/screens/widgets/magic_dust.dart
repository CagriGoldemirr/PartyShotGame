import 'package:flutter/material.dart';
import 'dart:math';

class MagicDust extends StatefulWidget {
  const MagicDust({super.key});

  @override
  State<MagicDust> createState() => _MagicDustState();
}

class _MagicDustState extends State<MagicDust> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> particles = List.generate(40, (index) => Particle()); // 40 adet parçacık

  @override
  void initState() {
    super.initState();
    // Parçacıkların sürekli hareket etmesi için sonsuz döngü motoru
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        for (var p in particles) {
          p.update();
        }
        return CustomPaint(
          painter: DustPainter(particles),
          size: Size.infinite,
        );
      },
    );
  }
}

// Her bir parçacığın özellikleri
class Particle {
  final Random random = Random();
  late double x, y, speed, radius;
  late Color color;

  Particle() {
    _reset();
    y = random.nextDouble(); // Ekrana ilk açılışta rastgele dağılmaları için
  }

  void _reset() {
    x = random.nextDouble();
    y = 1.1; // Ekranın hemen altından görünmez şekilde başlar
    speed = 0.001 + random.nextDouble() * 0.002; // Farklı hızlarda süzülürler
    radius = 1.0 + random.nextDouble() * 2.0; // Farklı boyutlar
    // Mistik orman temasına uygun renkler (hafif mavi, mor ve beyaz karışımı)
    color = Colors.white.withOpacity(0.1 + random.nextDouble() * 0.4);
  }

  void update() {
    y -= speed; // Yukarı doğru çıkış
    if (y < -0.1) _reset(); // Ekranda en tepeyi geçince aşağıdan tekrar başlar
  }
}

// Parçacıkları ekrana çizen fırça
class DustPainter extends CustomPainter {
  final List<Particle> particles;
  DustPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final paint = Paint()..color = p.color;
      canvas.drawCircle(Offset(p.x * size.width, p.y * size.height), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}