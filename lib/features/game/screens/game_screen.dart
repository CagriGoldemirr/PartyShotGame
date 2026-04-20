import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flip_card/flip_card.dart';
import '../../setup/logic/setup_provider.dart';
import '../widgets/drink_rain.dart';
import '../../../data/models/player.dart'; // EKSİK OLAN IMPORT EKLENDİ

class GameScreen extends StatefulWidget {
  // String yerine Player sınıfını kabul ediyoruz
  final List<Player> players; 
  const GameScreen({super.key, required this.players});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late AnimationController _rouletteController;
  late Animation<double> _rouletteAnimation;
  int? _highlightedIndex;
  bool _isSelecting = false;
  bool _selectionComplete = false;
  int? _finalWinnerIndex;

  // RENK PALETİ
  static const Color avatarNeonColor = Color(0xFF673AB7); 
  static const Color avatarNeonShadow = Color(0xFF311B92); 
  static const Color cardNeonColor = Color(0xFFE040FB); 
  static const Color cardNeonAccent = Color(0xFFF48FB1); 

  @override
  void initState() {
    super.initState();
    _rouletteController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _rouletteAnimation = CurvedAnimation(
      parent: _rouletteController,
      curve: Curves.easeOutCubic, 
    );

    _rouletteAnimation.addListener(() {
      if (_isSelecting) {
        setState(() {
          _highlightedIndex = (_rouletteAnimation.value * widget.players.length * 6).floor() % widget.players.length;
        });
      }
    });

    _rouletteAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isSelecting = false;
          _selectionComplete = true; 
          _finalWinnerIndex = _highlightedIndex;
        });
        HapticFeedback.vibrate(); 
      }
    });
  }

  void _startSelection() {
    if (_isSelecting) return;
    setState(() {
      _isSelecting = true;
      _selectionComplete = false;
      _finalWinnerIndex = null;
    });
    _rouletteController.reset();
    _rouletteController.forward();
  }

  @override
  void dispose() {
    _rouletteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0514),
      body: Stack(
        children: [
          // 1. KATMAN: SÜZÜLEN BARDAKLAR
          const Positioned.fill(child: DrinkRain()),
          
          // Çıkış Butonu
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white12, size: 28),
              onPressed: () => _showExitDialog(context),
            ),
          ),

          LayoutBuilder(
            builder: (context, constraints) {
              final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
              final rouletteRadius = constraints.maxWidth * 0.45; 

              return Stack(
                alignment: Alignment.center,
                children: [
                  _buildRouletteBackground(center, rouletteRadius),

                  ...List.generate(widget.players.length, (index) {
                    final angle = (2 * pi / widget.players.length) * index;
                    final isHighlighted = _highlightedIndex == index;

                    return _buildPlayerSlot(
                      angle: angle,
                      radius: rouletteRadius,
                      center: center,
                      player: widget.players[index], // Player nesnesini gönderiyoruz
                      isHighlighted: isHighlighted,
                    );
                  }),

                  // KART MERKEZİ 
                  Center(
                    child: GestureDetector(
                      onTap: _selectionComplete ? () {} : null,
                      child: _selectionComplete
                          ? _buildTaskCard(widget.players[_finalWinnerIndex!].name) // Sadece ismini gönderiyoruz
                          : _buildNeonMysteryCard(),
                    ),
                  ),
                ],
              );
            },
          ),

          // NEON BUTON
          if (!_isSelecting && !_selectionComplete)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: _buildNeonStartButton(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNeonMysteryCard() {
    return Container(
      width: 150, 
      height: 220, 
      decoration: BoxDecoration(
        color: const Color(0xFF140B1F),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: cardNeonColor.withOpacity(0.6), width: 2),
        boxShadow: [
          BoxShadow(color: cardNeonColor.withOpacity(0.3), blurRadius: 20, spreadRadius: 2),
        ],
      ),
      child: Center(
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [cardNeonAccent, cardNeonColor],
          ).createShader(bounds),
          child: const Text(
            "?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 80, 
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNeonStartButton() {
    return GestureDetector(
      onTap: _startSelection,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFF1A0B2E),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: cardNeonColor, width: 2),
          boxShadow: [
            BoxShadow(color: cardNeonColor.withOpacity(0.5), blurRadius: 15, spreadRadius: 1),
          ],
        ),
        child: const Text(
          "ŞANSLI KİŞİYİ SEÇ",
          style: TextStyle(color: cardNeonColor, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 18),
        ),
      ),
    );
  }

  // Burada String name yerine Player player nesnesi kabul ediliyor
  Widget _buildPlayerSlot({required double angle, required double radius, required Offset center, required Player player, required bool isHighlighted}) {
    final x = center.dx + (radius * 0.85) * cos(angle) - 45; 
    final y = center.dy + (radius * 0.85) * sin(angle) - 55;

    return Positioned(
      left: x,
      top: y,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isHighlighted ? avatarNeonColor : Colors.white10, width: 2.5),
              boxShadow: isHighlighted ? [
                BoxShadow(color: avatarNeonShadow.withOpacity(0.9), blurRadius: 30, spreadRadius: 5),
                BoxShadow(color: avatarNeonColor.withOpacity(0.5), blurRadius: 15, spreadRadius: 2),
              ] : [],
            ),
            child: CircleAvatar(
              radius: 42,
              backgroundColor: const Color(0xFF140B1F),
              // Avatar resmini Player nesnesinden çekiyoruz
              backgroundImage: AssetImage(player.avatarPath), 
            ),
          ),
          const SizedBox(height: 8),
          Text(player.name.toUpperCase(), style: TextStyle(color: isHighlighted ? Colors.white : Colors.white60, fontSize: 10, fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildTaskCard(String playerName) {
    return FlipCard(
      front: _buildNeonMysteryCard(),
      back: Container(
        width: 150, 
        height: 220, 
        padding: const EdgeInsets.symmetric(vertical: 10), 
        decoration: BoxDecoration(
          color: const Color(0xFF140B1F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cardNeonColor.withOpacity(0.8), width: 3),
          boxShadow: [BoxShadow(color: cardNeonColor.withOpacity(0.4), blurRadius: 25)],
        ),
        child: Column(
          children: [
            Text(
              playerName, 
              style: const TextStyle(color: cardNeonAccent, fontSize: 18, fontWeight: FontWeight.bold)
            ),
            const Divider(color: Colors.white10, indent: 15, endIndent: 15),
            
            const Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(), 
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Center(
                  child: Text(
                    "GÖREVİNİ YAP VEYA SHOT AT!", 
                    textAlign: TextAlign.center, 
                    style: TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
                  ),
                ),
              ),
            ),
            
            TextButton(
              onPressed: () => setState(() => _selectionComplete = false), 
              child: const Text("YENİ TUR", style: TextStyle(color: cardNeonColor, fontSize: 13, fontWeight: FontWeight.bold))
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouletteBackground(Offset center, double radius) {
    return Container(
      width: radius * 2.2, height: radius * 2.2,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.01))),
      child: CustomPaint(painter: RouletteLinesPainter(numberOfPlayers: widget.players.length)),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF140B1F),
        title: const Text("Oyunu Sıfırla", style: TextStyle(color: Colors.white)),
        content: const Text("Sıfırlamak istiyor musunuz?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("İPTAL")),
          TextButton(
            onPressed: () {
              context.read<SetupProvider>().resetGame();
              Navigator.pop(context); Navigator.pop(context);
            },
            child: const Text("SIFIRLA", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

class RouletteLinesPainter extends CustomPainter {
  final int numberOfPlayers;
  RouletteLinesPainter({required this.numberOfPlayers});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.01)..style = PaintingStyle.stroke..strokeWidth = 1;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    for (int i = 0; i < numberOfPlayers; i++) {
      final angle = (2 * pi / numberOfPlayers) * i;
      canvas.drawLine(center + Offset(cos(angle) * radius * 0.7, sin(angle) * radius * 0.7), center + Offset(cos(angle) * radius, sin(angle) * radius), paint);
    }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}