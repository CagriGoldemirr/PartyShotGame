import 'dart:math';
import 'package:flutter/material.dart';

class DrinkRain extends StatefulWidget {
  const DrinkRain({super.key});

  @override
  State<DrinkRain> createState() => _DrinkRainState();
}

class _DrinkRainState extends State<DrinkRain> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<DrinkItem> _items = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    
    // Başlangıçta 15 adet süzülen nesne oluşturuyoruz
    for (int i = 0; i < 15; i++) {
      _items.add(_createDrinkItem());
    }
  }

  DrinkItem _createDrinkItem() {
    return DrinkItem(
      x: _random.nextDouble(),
      y: _random.nextDouble() * -1.5, // Ekranın üstünden başlasınlar
      speed: _random.nextDouble() * 0.005 + 0.002,
      size: _random.nextDouble() * 20 + 20,
      icon: _getRandomDrinkIcon(),
      opacity: _random.nextDouble() * 0.3 + 0.1, // Çok parlak olup dikkat dağıtmasınlar
    );
  }

  IconData _getRandomDrinkIcon() {
    final icons = [Icons.wine_bar, Icons.local_bar, Icons.liquor];
    return icons[_random.nextInt(icons.length)];
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
        for (var item in _items) {
          item.y += item.speed;
          if (item.y > 1.2) { // Ekranın altına gelince tekrar üste taşı
            item.y = -0.2;
            item.x = _random.nextDouble();
          }
        }
        return CustomPaint(
          painter: DrinkRainPainter(_items),
          size: Size.infinite,
        );
      },
    );
  }
}

class DrinkItem {
  double x, y, speed, size, opacity;
  IconData icon;
  DrinkItem({required this.x, required this.y, required this.speed, required this.size, required this.icon, required this.opacity});
}

class DrinkRainPainter extends CustomPainter {
  final List<DrinkItem> items;
  DrinkRainPainter(this.items);

  @override
  void paint(Canvas canvas, Size size) {
    for (var item in items) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(item.icon.codePoint),
          style: TextStyle(
            fontSize: item.size,
            fontFamily: item.icon.fontFamily,
            color: Colors.white.withOpacity(item.opacity),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      
      textPainter.paint(canvas, Offset(size.width * item.x, size.height * item.y));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}