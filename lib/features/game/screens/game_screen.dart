import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flip_card/flip_card.dart';
import '../../../data/models/player.dart';
import '../../../data/models/task_item.dart';
import '../../../data/task_repository.dart';
import '../widgets/drink_rain.dart';

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

  // Renk Paletleri
  static const Color cardNeonColor = Color(0xFFE040FB); 
  static const Color cardNeonAccent = Color(0xFFF48FB1); 
  static const Color jokerGold = Color(0xFFFFD700); // Joker Kart Rengi

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
      _currentTask = null;
    });

    int totalSteps = 30 + Random().nextInt(18);
    int currentStep = 0;
    int newWinner;

    do {
      newWinner = Random().nextInt(widget.players.length);
    } while (newWinner == _lastWinnerIndex && widget.players.length > 1);
    _lastWinnerIndex = newWinner;

    while (currentStep < totalSteps) {
      await Future.delayed(Duration(milliseconds: 50 + (currentStep * 12)));
      setState(() {
        _highlightedIndex = (currentStep > totalSteps - 3) ? newWinner : Random().nextInt(widget.players.length);
      });
      HapticFeedback.lightImpact();
      currentStep++;
    }

    setState(() {
      _highlightedIndex = newWinner;
      _finalWinnerIndex = newWinner;
      _isSelecting = false;
      _selectionComplete = true;

      // %10 ŞANSLA JOKER KART KONTROLÜ
      if (Random().nextInt(100) < 10) {
        _currentTask = TaskRepository.getRandomTaskByLevel(4); // Jokerler Level 4 olarak tanımlandı
      } else {
        _currentTask = TaskRepository.getRandomTaskByLevel(_calculateCurrentLevel());
      }
      
      _currentTurn++; 
    });

    _showWinnerPopup(widget.players[newWinner]);
  }

  void _showWinnerPopup(Player winner) {
    final bool isJoker = _currentTask?.type == TaskType.joker;

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
                border: Border.all(color: isJoker ? jokerGold : cardNeonColor, width: 2),
                boxShadow: [
                  BoxShadow(color: (isJoker ? jokerGold : cardNeonColor).withOpacity(0.5), blurRadius: 40, spreadRadius: 5),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isJoker ? "ALTIN JOKER!" : "ŞANSLI KİŞİ!",
                    style: TextStyle(color: isJoker ? jokerGold : Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2),
                  ),
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(winner.avatarPath),
                    backgroundColor: Colors.white10,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    winner.name.toUpperCase(),
                    style: TextStyle(color: isJoker ? jokerGold : cardNeonAccent, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 300), () {
                        _cardKey.currentState?.toggleCard();
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A0B2E),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: isJoker ? jokerGold : cardNeonColor, width: 2),
                        boxShadow: [BoxShadow(color: (isJoker ? jokerGold : cardNeonColor).withOpacity(0.4), blurRadius: 10)],
                      ),
                      child: Center(
                        child: Text("GÖREVİ GÖR", style: TextStyle(color: isJoker ? jokerGold : cardNeonAccent, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) => Transform.scale(scale: Curves.elasticOut.transform(anim1.value), child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isJoker = _currentTask?.type == TaskType.joker;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0514),
      body: Stack(
        children: [
          const Positioned.fill(child: DrinkRain()),
          
          // Tur ve Seviye Rozeti
          Positioned(
            top: 55,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
              child: Text("Tur: $_currentTurn | Seviye: ${_calculateCurrentLevel()}", style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ),
          ),

          // Simetrik Avatar Dizilimi
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double radius = constraints.maxWidth * 0.38;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    ...List.generate(widget.players.length, (index) {
                      final angle = (2 * pi / widget.players.length) * index - (pi / 2);
                      return Transform.translate(
                        offset: Offset(radius * cos(angle), radius * sin(angle)),
                        child: _buildAvatar(index),
                      );
                    }),
                    FlipCard(
                      key: _cardKey,
                      flipOnTouch: false,
                      front: _buildCardUI(isMystery: true),
                      back: _buildCardUI(isMystery: false),
                    ),
                  ],
                );
              },
            ),
          ),

          if (!_isSelecting && !_selectionComplete)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: GestureDetector(
                  onTap: _startSelection,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A0B2E),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: cardNeonColor, width: 2),
                    ),
                    child: const Text("ŞANSLI KİŞİYİ SEÇ", style: TextStyle(color: cardNeonColor, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar(int index) {
    final bool isHighlighted = _highlightedIndex == index;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: isHighlighted ? cardNeonColor : Colors.white10, width: 2),
            boxShadow: isHighlighted ? [BoxShadow(color: cardNeonColor.withOpacity(0.5), blurRadius: 20)] : [],
          ),
          child: CircleAvatar(radius: 38, backgroundImage: AssetImage(widget.players[index].avatarPath)),
        ),
        const SizedBox(height: 4),
        Text(widget.players[index].name, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }

  Widget _buildCardUI({required bool isMystery}) {
    final bool isJoker = _currentTask?.type == TaskType.joker;
    final Color activeColor = isJoker ? jokerGold : cardNeonColor;

    return Container(
      width: 130,
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF140B1F),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: activeColor.withOpacity(0.7), width: 2),
        boxShadow: [BoxShadow(color: activeColor.withOpacity(0.3), blurRadius: 20)],
      ),
      child: Center(
        child: isMystery 
          ? Text("?", style: TextStyle(color: activeColor, fontSize: 80, fontWeight: FontWeight.bold))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(isJoker ? "JOKER" : "GÖREV", style: TextStyle(color: activeColor, fontWeight: FontWeight.bold)),
                const Divider(color: Colors.white10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_currentTask?.text ?? "...", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
                TextButton(onPressed: () => setState(() => _selectionComplete = false), child: Text("OK", style: TextStyle(color: activeColor))),
              ],
            ),
      ),
    );
  }
}