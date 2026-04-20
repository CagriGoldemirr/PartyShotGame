import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/setup_provider.dart';
import '../../game/screens/game_screen.dart';
import '../../game/widgets/drink_rain.dart';
import '../../game/screens/widgets/partyshot_logo.dart'; // Yeni Logomuz

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final TextEditingController _nameController = TextEditingController();
  
  // Avatar yolları (Dosyalarının tam olarak bu isimde ve .png uzantılı olduğundan emin ol)
  final List<String> _availableAvatars = [
    'assets/avatars/4653780-200.png',
    ...List.generate(21, (index) => 'assets/avatars/${index + 1}.png'),
  ];
  
  String _selectedAvatar = 'assets/avatars/4653780-200.png';

  void _addPlayer() {
    if (_nameController.text.trim().isNotEmpty) {
      context.read<SetupProvider>().addPlayer(_nameController.text.trim(), _selectedAvatar);
      _nameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final players = context.watch<SetupProvider>().players;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0C20),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // 1. Arka Plan
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

          // 3. Ana İçerik
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 30),
                
                // İŞTE YENİ LOGOMUZ BURADA
                const PartyShotLogo(fontSize: 36, iconSize: 32),
                
                const SizedBox(height: 30),
                
                // OYUNCU EKLEME ALANI VE AVATARLAR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      children: [
                        // AVATAR LİSTESİ BURADA
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
                                    backgroundColor: Colors.white24, // Resim yüklenmezse burası gri görünür!
                                    backgroundImage: AssetImage(path),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Oyuncu adını gir...",
                            hintStyle: const TextStyle(color: Colors.white30),
                            filled: true,
                            fillColor: Colors.black.withOpacity(0.2),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                            suffixIcon: IconButton(icon: const Icon(Icons.add_circle, color: Colors.cyanAccent, size: 30), onPressed: _addPlayer),
                          ),
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
                    itemBuilder: (context, index) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20, 
                            backgroundColor: Colors.white24, // Hata yakalayıcı arka plan
                            backgroundImage: AssetImage(players[index].avatarPath)
                          ),
                          const SizedBox(width: 15),
                          Text(players[index].name, style: const TextStyle(color: Colors.white, fontSize: 18)),
                          const Spacer(),
                          const Icon(Icons.check_circle, color: Colors.cyanAccent, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),

                // BAŞLA BUTONU
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: players.length >= 2 ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => GameScreen(players: players))) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent.withOpacity(0.8), 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      ),
                      child: const Text("HAZIRIZ!", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2)),
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