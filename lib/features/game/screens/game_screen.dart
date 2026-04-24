import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flip_card/flip_card.dart';

import '../../setup/logic/setup_provider.dart';
import '../widgets/drink_rain.dart';
import '../../../data/models/player.dart';
import '../../../data/models/task_item.dart';
import '../../../data/task_repository.dart';

class GameScreen extends StatefulWidget {
  final List<Player> players; 
  const GameScreen({super.key, required this.players});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();

  int? _highlightedIndex;
  bool _isSelecting = false;
  bool _selectionComplete = false;
  int? _finalWinnerIndex;
  int? _lastWinnerIndex;

  int _currentTurn = 1; 
  TaskItem? _currentTask;

  static const Color avatarNeonColor = Color(0xFF673AB7); 
  static const Color avatarNeonShadow = Color(0xFF311B92); 
  static const Color cardNeonColor = Color(0xFFE040FB); 
  static const Color cardNeonAccent = Color(0xFFF48FB1); 

  int _calculateCurrentLevel() {
    if (_currentTurn <= 20) return 1;
    if (_currentTurn <= 38) return 2;
    return 3;
  }

  Future<void> _startSelection() async {
    if (_isSelecting) return;

    if (_cardKey.currentState != null && !_cardKey.currentState!.isFront) {
      _cardKey.currentState!.toggleCard();
    }

    setState(() {
      _isSelecting = true;
      _selectionComplete = false;
      _finalWinnerIndex = null;
      _currentTask = null;
    });

    int totalSteps = 25 + Random().nextInt(15);
    int currentStep = 0;
    
    int newWinner;
    do {
      newWinner = Random().nextInt(widget.players.length);
    } while (newWinner == _lastWinnerIndex && widget.players.length > 1);
    
    _lastWinnerIndex = newWinner;

    while (currentStep < totalSteps) {
      await Future.delayed(Duration(milliseconds: 50 + (currentStep * 10)));
      
      setState(() {
        if (currentStep > totalSteps - 3) {
          _highlightedIndex = newWinner;
        } else {
          _highlightedIndex = Random().nextInt(widget.players.length);
        }
      });
      
      HapticFeedback.lightImpact();
      currentStep++;
    }

    setState(() {
      _highlightedIndex = newWinner;
      _finalWinnerIndex = newWinner;
      _isSelecting = false;
      _selectionComplete = true;
      
      final int level = _calculateCurrentLevel();
      _currentTask = TaskRepository.getRandomTaskByLevel(level);
      
      _currentTurn++; 
    });

    HapticFeedback.heavyImpact();
    _showWinnerPopup(widget.players[newWinner]);
  }

  void _showWinnerPopup(Player winner) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.85),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color(0xFF140B1F),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: cardNeonColor, width: 2),
                boxShadow: [
                  BoxShadow(color: cardNeonColor.withOpacity(0.5), blurRadius: 40, spreadRadius: 5),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "ŞANSLI KİŞİ!",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2),
                  ),
                  const SizedBox(height: 20),
                  
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: cardNeonAccent, width: 2),
                      boxShadow: [BoxShadow(color: cardNeonAccent.withOpacity(0.4), blurRadius: 15)],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFF140B1F),
                      backgroundImage: AssetImage(winner.avatarPath),
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  Text(
                    winner.name.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: cardNeonAccent, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (_cardKey.currentState != null && _cardKey.currentState!.isFront) {
                          _cardKey.currentState!.toggleCard();
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A0B2E), // Ana temanın derin koyu moru
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: cardNeonColor, width: 2), // Neon pembe çerçeve
                        boxShadow: [
                          BoxShadow(
                            color: cardNeonColor.withOpacity(0.5), 
                            blurRadius: 15, 
                            spreadRadius: 2
                          ) // Dışa doğru neon parlama
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "GÖREVİ GÖR",
                          style: TextStyle(
                            color: cardNeonAccent, // Parlak açık pembe yazı
                            fontSize: 16, 
                            fontWeight: FontWeight.bold, 
                            letterSpacing: 2
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: Curves.elasticOut.transform(anim1.value),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0514),
      body: Stack(
        children: [
          const Positioned.fill(child: DrinkRain()),
          
          Positioned(
            top: 50,
            left: 15,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white30, size: 24),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          Positioned(
            top: 55,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: cardNeonColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cardNeonColor.withOpacity(0.3)),
              ),
              child: Text(
                "Tur: $_currentTurn | S: ${_calculateCurrentLevel()}",
                style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
              ),
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
                    final angle = (2 * pi / widget.players.length) * index - (pi / 2);
                    final isHighlighted = _highlightedIndex == index;

                    return _buildPlayerSlot(
                      angle: angle,
                      radius: rouletteRadius * 0.85,
                      player: widget.players[index],
                      isHighlighted: isHighlighted,
                    );
                  }),

                  Center(
                    child: _buildTaskCard(),
                  ),
                ],
              );
            },
          ),

          if (!_isSelecting && !_selectionComplete)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: _buildNeonStartButton(),
              ),
            ),
        ],
      ),
    );
  }

  // Hafif Büyütülmüş Gizemli Kart (130x200)
  Widget _buildNeonMysteryCard() {
    return Container(
      width: 150, 
      height: 180, 
      decoration: BoxDecoration(
        color: const Color(0xFF140B1F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cardNeonColor.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(color: cardNeonColor.withOpacity(0.2), blurRadius: 15),
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
              fontSize: 85, 
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Hafif Büyütülmüş Görev Kartı (130x200)
  Widget _buildTaskCard() {
    return FlipCard(
      key: _cardKey,
      flipOnTouch: false,
      front: _buildNeonMysteryCard(),
      back: Container(
        width: 130, 
        height: 200, 
        padding: const EdgeInsets.all(14), 
        decoration: BoxDecoration(
          color: const Color(0xFF140B1F),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: cardNeonColor.withOpacity(0.7), width: 2),
          boxShadow: [BoxShadow(color: cardNeonColor.withOpacity(0.3), blurRadius: 20)],
        ),
        child: Column(
          children: [
            const Text(
              "GÖREV", 
              style: TextStyle(color: cardNeonAccent, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.5)
            ),
            const Divider(color: Colors.white10, height: 14),
            
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(), 
                child: Center(
                  child: Text(
                    _currentTask?.text ?? "...", 
                    textAlign: TextAlign.center, 
                    style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.3),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 8),

            GestureDetector(
              onTap: () => setState(() => _selectionComplete = false),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: cardNeonColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: cardNeonColor.withOpacity(0.5)),
                ),
                child: const Center(
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNeonStartButton() {
    return GestureDetector(
      onTap: _startSelection,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A0B2E),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: cardNeonColor, width: 2),
          boxShadow: [
            BoxShadow(color: cardNeonColor.withOpacity(0.5), blurRadius: 15),
          ],
        ),
        child: const Text(
          "ŞANSINI DENEMEK İÇİN TIKLA",
          style: TextStyle(color: cardNeonColor, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildPlayerSlot({required double angle, required double radius, required Player player, required bool isHighlighted}) {
    final x = radius * cos(angle); 
    final y = radius * sin(angle);

    return Transform.translate(
      offset: Offset(x, y),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isHighlighted ? avatarNeonColor : Colors.white10, width: 2),
              boxShadow: isHighlighted ? [
                BoxShadow(color: avatarNeonShadow.withOpacity(0.8), blurRadius: 25, spreadRadius: 3),
              ] : [],
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFF140B1F),
              backgroundImage: AssetImage(player.avatarPath), 
            ),
          ),
          const SizedBox(height: 6),
          Text(
            player.name.toUpperCase(), 
            style: TextStyle(
              color: isHighlighted ? Colors.white : Colors.white60, 
              fontSize: 10, 
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal
            )
          ),
        ],
      ),
    );
  }

  Widget _buildRouletteBackground(Offset center, double radius) {
    return Container(
      width: radius * 2.1, height: radius * 2.1,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: CustomPaint(painter: RouletteLinesPainter(numberOfPlayers: widget.players.length)),
    );
  }
}

class RouletteLinesPainter extends CustomPainter {
  final int numberOfPlayers;
  RouletteLinesPainter({required this.numberOfPlayers});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.015)..style = PaintingStyle.stroke..strokeWidth = 1;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    for (int i = 0; i < numberOfPlayers; i++) {
      final angle = (2 * pi / numberOfPlayers) * i - (pi / 2);
      canvas.drawLine(
        center + Offset(cos(angle) * radius * 0.75, sin(angle) * radius * 0.75), 
        center + Offset(cos(angle) * radius, sin(angle) * radius), 
        paint
      );
    }
  }

  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}