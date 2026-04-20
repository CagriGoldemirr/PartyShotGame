import 'dart:math';
import 'package:flutter/material.dart';

class MagicDust extends StatefulWidget {
  const MagicDust({super.key});

  @override
  State<MagicDust> createState() => _MagicDustState();
}

class _MagicDustState extends State<MagicDust> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();
  final List<IconData> _shotIcons = [Icons.local_drink_rounded, Icons.wine_bar_rounded]; // Shot ve kadeh ikonları

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Döngü süresi
    )..addListener(() {
        _updateParticles();
      })..repeat(); // Sürekli tekrarla

    // Başlangıç parçacıklarını oluştur
    for (int i = 0; i < 20; i++) {
      _particles.add(_generateParticle(isInitial: true));
    }
  }

  // Yeni bir parçacık oluştur
  Particle _generateParticle({bool isInitial = false}) {
    return Particle(
      x: _random.nextDouble(),
      y: isInitial ? _random.nextDouble() : -0.1, // Başlangıçta ekranda, sonradan yukarıdan başla
      speed: _random.nextDouble() * 0.005 + 0.002, // Düşüş hızı
      size: _random.nextDouble() * 15 + 10, // İkon boyutu
      icon: _shotIcons[_random.nextInt(_shotIcons.length)], // Rastgele ikon seçimi
      color: Colors.white.withOpacity(_random.nextDouble() * 0.3 + 0.1), // Hafif saydam beyaz
    );
  }

  // Parçacıkları güncelle
  void _updateParticles() {
    setState(() {
      for (int i = 0; i < _particles.length; i++) {
        _particles[i].y += _particles[i].speed;
        // Ekrandan çıkan parçacığı tekrar yukarıdan başlat
        if (_particles[i].y > 1.1) {
          _particles[i] = _generateParticle();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: _particles.map((particle) {
            return Positioned(
              left: particle.x * constraints.maxWidth,
              top: particle.y * constraints.maxHeight,
              child: Opacity(
                opacity: particle.color.opacity,
                child: Icon(
                  particle.icon,
                  size: particle.size,
                  color: particle.color,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

// Parçacık verisi için basit bir sınıf
class Particle {
  double x; // Yatay pozisyon (0.0 - 1.0)
  double y; // Dikey pozisyon (0.0 - 1.0)
  final double speed; // Düşüş hızı
  final double size; // İkon boyutu
  final IconData icon; // Shot veya kadeh ikonu
  final Color color; // Renk ve saydamlık

  Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.icon,
    required this.color,
  });
}