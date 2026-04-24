import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../data/models/player.dart';
import '../../../data/task_repository.dart';
import '../../setup/logic/setup_provider.dart';

// Eğer burada kırmızı çizgi çıkarsa başına '../' eklemeyi veya silmeyi dene
//import '../widgets/partyshot_logo.dart';
import '../widgets/drink_rain.dart';
import '../widgets/magic_dust.dart';

class GameScreen extends StatefulWidget {
  final List<Player> players;
  const GameScreen({super.key, required this.players});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  int _highlightedIndex = 0;
  int _finalWinnerIndex = -1;
  int? _lastWinnerIndex; // Yalnızca bir kez tanımlandı
  bool _isSpinning = false;
  bool _isCardRevealed = false;
  String _currentTask = "";
  
  late AnimationController _breathingController;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  Future<void> _startLuckySelection() async {
    if (_isSpinning) return;

    setState(() {
      _isSpinning = true;
      _isCardRevealed = false;
      _finalWinnerIndex = -1;
    });

    int totalSteps = 25 + Random().nextInt(15);
    int currentStep = 0;
    
    // Ardışık Seçim Engeli
    int newWinner;
    do {
      newWinner = Random().nextInt(widget.players.length);
    } while (newWinner == _lastWinnerIndex && widget.players.length > 1);
    
    _lastWinnerIndex = newWinner;

    // Kaotik Işık Animasyonu
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
      _isSpinning = false;
      
      // GÖREV ÇEKME İŞLEMİ (TaskItem)
      final selectedTaskItem = TaskRepository.allTasks[Random().nextInt(TaskRepository.allTasks.length)];
      
      // ÖNEMLİ DİKKAT: .text yazdım. Eğer TaskItem modelinde görevi tutan isim 
      // 'description' veya 'gorev' ise buradaki .text kısmını ona göre değiştir.
      _currentTask = selectedTaskItem.text; 
    });

    HapticFeedback.heavyImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF130A21),
      body: Stack(
        children: [
          const DrinkRain(),
          const Positioned.fill(child: MagicDust()),
          
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.home_rounded, color: Colors.white70, size: 30),
              onPressed: () => _showResetDialog(context),
            ),
          ),

          Center(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ...List.generate(widget.players.length, (index) {
                    final double angle = (index * 2 * pi / widget.players.length) - pi / 2;
                    const double radius = 150;
                    final x = radius * cos(angle);
                    final y = radius * sin(angle);
                    final isHighlighted = _highlightedIndex == index;

                    return Transform.translate(
                      offset: Offset(x, y),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                if (isHighlighted)
                                  BoxShadow(
                                    color: const Color(0xFF673AB7).withOpacity(0.9),
                                    blurRadius: 25,
                                    spreadRadius: 8,
                                  ),
                              ],
                              border: Border.all(
                                color: isHighlighted ? const Color(0xFFB39DDB) : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 42,
                              backgroundImage: AssetImage(widget.players[index].avatarPath),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.players[index].name,
                            style: TextStyle(
                              color: isHighlighted ? Colors.white : Colors.white60,
                              fontSize: 12,
                              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                              shadows: [
                                if (isHighlighted)
                                  const BoxShadow(
                                    color: Color(0xFFB39DDB),
                                    blurRadius: 10,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  GestureDetector(
                    onTap: () {
                      if (_finalWinnerIndex != -1 && !_isSpinning) {
                        setState(() => _isCardRevealed = !_isCardRevealed);
                        HapticFeedback.mediumImpact();
                      }
                    },
                    child: _isCardRevealed 
                      ? _buildTaskCard(widget.players[_finalWinnerIndex].name)
                      : _buildNeonMysteryCard(),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: _buildNeonStartButton(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeonMysteryCard() {
    return AnimatedBuilder(
      animation: _breathingController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _breathingController.value * -10),
          child: Container(
            width: 140,
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFF1A0F2E),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFFE040FB), width: 3),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE040FB).withOpacity(0.6),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFE040FB), Color(0xFF00E5FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  "?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 85,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaskCard(String playerName) {
    return Container(
      width: 140,
      height: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE040FB).withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            playerName.toUpperCase(),
            style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Divider(color: Colors.black26),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  _currentTask,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black87, fontSize: 13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeonStartButton() {
    return InkWell(
      onTap: _isSpinning ? null : _startLuckySelection,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFF1A0F2E),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFE040FB), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE040FB).withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Text(
          _isSpinning ? "SEÇİLİYOR..." : "ŞANSLI KİŞİYİ SEÇ",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A0F2E),
        title: const Text("Oyunu Sıfırla", style: TextStyle(color: Colors.white)),
        content: const Text("Mevcut oyunu bitirip başa dönmek istiyor musunuz?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("İPTAL")),
          TextButton(
            onPressed: () {
              context.read<SetupProvider>().resetGame();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text("SIFIRLA", style: TextStyle(color: Color(0xFFE040FB))),
          ),
        ],
      ),
    );
  }
}