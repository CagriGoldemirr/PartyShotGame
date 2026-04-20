import 'dart:math';
import 'package:flutter/material.dart';

class DrinkRain extends StatefulWidget {
  const DrinkRain({super.key});

  @override
  State<DrinkRain> createState() => _DrinkRainState();
}

class _DrinkRainState extends State<DrinkRain> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();
  
  // Shot, şarap ve bira kadehi ikonları
  final List<IconData> _icons = [
    Icons.local_drink_rounded, 
    Icons.wine_bar_rounded,
    Icons.sports_bar_rounded
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {
          _updateParticles();
        });
      })..repeat();

    for (int i = 0; i < 20; i++) {
      _particles.add(_generateParticle(isInitial: true));
    }
  }

  Particle _generateParticle({bool isInitial = false}) {
    return Particle(
      x: _random.nextDouble(),
      y: isInitial ? _random.nextDouble() : -0.1,
      speed: _random.nextDouble() * 0.003 + 0.002, // Yavaşça süzülme hızı
      size: _random.nextDouble() * 20 + 15,
      icon: _icons[_random.nextInt(_icons.length)],
      color: Colors.white.withOpacity(_random.nextDouble() * 0.15 + 0.05), // Hafif saydam
    );
  }

  void _updateParticles() {
    for (int i = 0; i < _particles.length; i++) {
      _particles[i].y += _particles[i].speed;
      if (_particles[i].y > 1.1) {
        _particles[i] = _generateParticle();
      }
    }
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
              child: Icon(
                particle.icon,
                size: particle.size,
                color: particle.color,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  final double speed;
  final double size;
  final IconData icon;
  final Color color;

  Particle({
    required this.x, required this.y, required this.speed, 
    required this.size, required this.icon, required this.color,
  });
}