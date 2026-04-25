import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/setup_provider.dart';
import '../../game/screens/game_screen.dart';
import '../../game/widgets/drink_rain.dart';
import '../../game/screens/widgets/partyshot_logo.dart';
import 'info_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final TextEditingController _nameController = TextEditingController();
  
  final List<String> _availableAvatars = [
    'assets/avatars/4653780-200.png',
    ...List.generate(21, (index) => 'assets/avatars/${index + 1}.png'),
  ];
  
  String _selectedAvatar = 'assets/avatars/4653780-200.png';

  void _addPlayer() {
    if (_nameController.text.trim().isNotEmpty) {
      final error = context.read<SetupProvider>().addPlayer(_nameController.text.trim(), _selectedAvatar);
      if (error == null) {
        _nameController.clear();
        FocusScope.of(context).unfocus(); // Klavye kapansın
      } else {
        // İsim çakışması veya boş olma durumunda küçük bir uyarı
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Provider'dan oyuncu listesini dinliyoruz
    final players = context.watch<SetupProvider>().players;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0C20),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // 1. Arka Plan: Gradyan
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0F0C20), Color(0xFF1A1635)],
              ),
            ),
          ),
          
          // 2. Süzülen Bardaklar
          const Positioned.fill(child: DrinkRain()),

          // 3. Geri Butonu (InfoScreen'e Dönüş)
          Positioned(
            top: 50,
            left: 15,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white30, size: 24),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const InfoScreen()),
                );
              },
            ),
          ),

          // 4. Ana İçerik
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 30),
                const PartyShotLogo(fontSize: 36, iconSize: 32),
                const SizedBox(height: 30),
                
                // Oyuncu Ekleme Alanı
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      children: [
                        // Avatar Seçici
                        SizedBox(
                          height: 60,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _availableAvatars.length,
                            itemBuilder: (context, index) {
                              final path = _availableAvatars[index];
                              final isSelected = _selectedAvatar == path;
                              
                              return GestureDetector(
                                onTap: () => setState(() => _selectedAvatar = path),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? Colors.cyanAccent : Colors.transparent, 
                                      width: 2.5
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 26, 
                                    backgroundColor: Colors.white24,
                                    backgroundImage: AssetImage(path),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        // İsim Girişi
                        TextField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Oyuncu adını gir...",
                            hintStyle: const TextStyle(color: Colors.white30),
                            filled: true,
                            fillColor: Colors.black.withValues(alpha: 0.2),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.add_circle, color: Colors.cyanAccent, size: 30), 
                              onPressed: _addPlayer
                            ),
                          ),
                          onSubmitted: (_) => _addPlayer(),
                        ),
                      ],
                    ),
                  ),
                ),

                // EKLENEN OYUNCULAR LİSTESİ
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(25),
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      final player = players[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05), 
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.05))
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 22, 
                              backgroundColor: Colors.white12,
                              backgroundImage: AssetImage(player.avatarPath)
                            ),
                            const SizedBox(width: 15),
                            Text(
                              player.name, 
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)
                            ),
                            const Spacer(),
                            
                            // YENİ: SİLME BUTONU
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline_rounded, 
                                color: Colors.redAccent, 
                                size: 22
                              ),
                              onPressed: () {
                                // Oyuncuyu ID üzerinden siliyoruz
                                context.read<SetupProvider>().removePlayer(player.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // BAŞLA BUTONU
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: players.length >= 2 ? () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => GameScreen(players: players))
                        );
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent.withValues(alpha: 0.8), 
                        disabledBackgroundColor: Colors.white10,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 10,
                        shadowColor: Colors.purpleAccent.withValues(alpha: 0.3),
                      ),
                      child: Text(
                        "HAZIRIZ!", 
                        style: TextStyle(
                          color: players.length >= 2 ? Colors.white : Colors.white24, 
                          fontSize: 18, 
                          fontWeight: FontWeight.bold, 
                          letterSpacing: 2
                        )
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}