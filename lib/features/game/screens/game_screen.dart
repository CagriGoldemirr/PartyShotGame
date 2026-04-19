import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flip_card/flip_card.dart';
import '../../setup/logic/setup_provider.dart';
import '../widgets/magic_dust.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

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

  // GÜNCELLENMİŞ RENK PALETİ
  // Avatarlar için: Koyu, Derin Mistik Mor
  static const Color avatarNeonColor = Color(0xFF673AB7); // Rich Deep Purple
  static const Color avatarNeonShadow = Color(0xFF311B92); // Ultra Dark Indigo Shadow

  // Kart için: Canlı, Parlak Neon Mor/Pembe
  static const Color cardNeonColor = Color(0xFFE040FB); // Vibrant Neon Magenta
  static const Color cardNeonAccent = Color(0xFFF48FB1); // Soft Pink Accent

  @override
  void initState() {
    super.initState();
    _rouletteController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _rouletteAnimation = CurvedAnimation(
      parent: _rouletteController,
      curve: Curves.easeOutCubic, // Rulet gibi yavaşlayan duruş
    );

    _rouletteAnimation.addListener(() {
      if (_isSelecting) {
        final players = context.read<SetupProvider>().players;
        setState(() {
          _highlightedIndex = (_rouletteAnimation.value * players.length * 6).floor() % players.length;
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
    final players = context.watch<SetupProvider>().players;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0514), // Daha Koyu Arka Plan
      body: Stack(
        children: [
          const MagicDust(), // Arka plan parçacıkları
          
          // Sol Üst: Çıkış Butonu
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white12, size: 28),
              onPressed: () => _showExitDialog(context),
            ),
          ),

          // Ana Oyun Alanı (Mistik Rulet)
          LayoutBuilder(
            builder: (context, constraints) {
              final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
              // Kart ve avatarlar arası denge için yarıçap
              final rouletteRadius = constraints.maxWidth * 0.44;

              return Stack(
                alignment: Alignment.center,
                children: [
                  // 1. Mistik Rulet Zemini (Çizgiler)
                  _buildRouletteBackground(center, rouletteRadius),

                  // 2. Oyuncu Slotları (Büyük Avatarlar)
                  ...List.generate(players.length, (index) {
                    final angle = (2 * pi / players.length) * index;
                    final isHighlighted = _highlightedIndex == index;

                    return _buildPlayerSlot(
                      angle: angle,
                      radius: rouletteRadius,
                      center: center,
                      player: players[index],
                      isHighlighted: isHighlighted,
                    );
                  }),

                  // 3. Merkezdeki Mistik Soru İşareti / Kart
                  Center(
                    child: GestureDetector(
                      onTap: _selectionComplete ? () {} : null,
                      child: _selectionComplete
                          ? _buildTaskCard(players[_finalWinnerIndex!].name)
                          : _buildNeonMysteryCard(),
                    ),
                  ),
                ],
              );
            },
          ),

          // Alt Buton
          if (!_isSelecting && !_selectionComplete)
            _buildStartButton(),
        ],
      ),
    );
  }

  // GÜNCELLENMİŞ: Canlı Neon Mor Kart Tasarımı ve BÜYÜTÜLMÜŞ Soru İşareti
  Widget _buildNeonMysteryCard() {
    return Container(
      width: 120, // Kart boyutu aynı kalıyor
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFF140B1F),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: cardNeonColor.withOpacity(0.6), width: 2),
        boxShadow: [
          BoxShadow(
            color: cardNeonColor.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: cardNeonAccent.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ],
      ),
      child: Center(
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [cardNeonAccent, cardNeonColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Container(
            // Soru işaretini çevreleyen halkanın boyutu büyütüldü
            padding: const EdgeInsets.all(12), 
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.0), 
            ),
            child: const Text(
              "?",
              style: TextStyle(
                color: Colors.white,
                // Soru işaretinin font boyutu büyütüldü
                fontSize: 85, 
                fontWeight: FontWeight.w200, // Zarif ama net neon
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerSlot({
    required double angle,
    required double radius,
    required Offset center,
    required dynamic player,
    required bool isHighlighted,
  }) {
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
              border: Border.all(
                color: isHighlighted ? avatarNeonColor : Colors.white10,
                width: 2.5,
              ),
              boxShadow: isHighlighted
                  ? [
                      BoxShadow(
                        color: avatarNeonShadow.withOpacity(0.9), // Koyu, Yoğun Gölge
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                      BoxShadow(
                        color: avatarNeonColor.withOpacity(0.5), // Mistik Mor Işık
                        blurRadius: 15,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
            child: CircleAvatar(
              radius: 42,
              backgroundColor: const Color(0xFF140B1F),
              backgroundImage: AssetImage(player.avatarPath), // Seçilen Avatar
            ),
          ),
          const SizedBox(height: 8),
          Text(
            player.name.toUpperCase(),
            style: TextStyle(
              color: isHighlighted ? Colors.white : Colors.white60,
              fontSize: 10,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              shadows: [
                if (isHighlighted)
                  Shadow(color: avatarNeonColor.withOpacity(0.6), blurRadius: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(String playerName) {
    return FlipCard(
      front: _buildNeonMysteryCard(),
      back: Container(
        width: 200,
        height: 280,
        decoration: BoxDecoration(
          color: const Color(0xFF140B1F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cardNeonColor.withOpacity(0.6), width: 3),
          boxShadow: [
            BoxShadow(color: cardNeonColor.withOpacity(0.4), blurRadius: 25),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(playerName, style: const TextStyle(color: cardNeonAccent, fontSize: 22, fontWeight: FontWeight.bold)),
            const Divider(color: Colors.white10, indent: 20, endIndent: 20),
            const Text("GÖREVİN:", style: TextStyle(color: Colors.white38, fontSize: 12)),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "SHOT VAKTİ!", // Buraya rastgele görev gelecek
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () => setState(() => _selectionComplete = false),
              child: const Text("TAMAM", style: TextStyle(color: cardNeonColor)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: GestureDetector(
          onTap: _startSelection,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            decoration: BoxDecoration(
              color: avatarNeonColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: avatarNeonColor.withOpacity(0.3)),
            ),
            child: const Text(
              "ŞANSLI KİŞİYİ SEÇ",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRouletteBackground(Offset center, double radius) {
    return Container(
      width: radius * 2.2,
      height: radius * 2.2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.015)),
      ),
      child: CustomPaint(
        painter: RouletteLinesPainter(numberOfPlayers: context.read<SetupProvider>().players.length),
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF140B1F),
        title: const Text("Oyunu Sıfırla", style: TextStyle(color: Colors.white)),
        content: const Text("Ana menüye dönmek istiyor musunuz?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("İPTAL")),
          TextButton(
            onPressed: () {
              context.read<SetupProvider>().resetGame();
              Navigator.pop(context); // Dialogu kapat
              Navigator.pop(context); // Oyundan çık
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
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.01)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (int i = 0; i < numberOfPlayers; i++) {
      final angle = (2 * pi / numberOfPlayers) * i;
      final start = Offset(center.dx + (radius * 0.7) * cos(angle), center.dy + (radius * 0.7) * sin(angle));
      final end = Offset(center.dx + radius * cos(angle), center.dy + radius * sin(angle));
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}