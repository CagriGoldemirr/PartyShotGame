import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/setup_provider.dart';
import '../../game/screens/game_screen.dart';
import '../../game/widgets/drink_rain.dart'; 

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final TextEditingController _controller = TextEditingController();
  // 1. DÜZELTME: Başlangıç avatarını tekrar yerel dosya yaptık
  String _selectedAvatar = 'assets/images/avatar1.png';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final setupProvider = context.watch<SetupProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F051D),
      resizeToAvoidBottomInset: true, 
      body: Stack(
        children: [
          // 1. KATMAN: SÜZÜLEN BARDAKLAR (EN ARKADA)
          const Positioned.fill(child: DrinkRain()),

          // 2. KATMAN: MEVCUT ARAYÜZ (Giriş paneli, liste vb.)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xFF0F051D)],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Başlık
                  Text(
                    "PARTY SHOT",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 4,
                      shadows: [
                        Shadow(color: Colors.purpleAccent.withOpacity(0.5), blurRadius: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Giriş Paneli (En Üstte Sabit)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        children: [
                          // Avatar Seçici
                          SizedBox(
                            height: 70,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                String avatarPath = 'assets/images/avatar${index + 1}.png';
                                bool isSelected = _selectedAvatar == avatarPath;
                                return GestureDetector(
      onTap: () => setState(() => _selectedAvatar = avatarPath),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.purpleAccent : Colors.transparent,
            width: 2,
          ),
        ),
        child: CircleAvatar(
          radius: 25,
          backgroundColor: const Color(0xFF140B1F),
          // NetworkImage YERİNE TEKRAR AssetImage KULLANIYORUZ
          backgroundImage: AssetImage(avatarPath),
        ),
      ),
    );
  },
                            ),
                          ),  
                          const SizedBox(height: 15),
                          // İsim Girişi
                          TextField(
                            controller: _controller,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Oyuncu İsmi...",
                              hintStyle: const TextStyle(color: Colors.white30),
                              filled: true,
                              fillColor: Colors.black26,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.add_circle, color: Colors.purpleAccent),
                                onPressed: () {
                                  final error = setupProvider.addPlayer(_controller.text, _selectedAvatar);
                                  if (error != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(error), backgroundColor: Colors.redAccent),
                                    );
                                  } else {
                                    _controller.clear();
                                    FocusScope.of(context).unfocus(); // Klavye kapatma
                                  }
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Eklenen Oyuncu Listesi (Ortada Esnek)
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: setupProvider.players.length,
                      itemBuilder: (context, index) {
                        final player = setupProvider.players[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(player.avatarPath),
                            ),
                            title: Text(
                              player.name,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 20),
                              onPressed: () => setupProvider.removePlayer(player.id),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // OYNA Butonu (Altta Sabit)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: setupProvider.players.length < 2
                          ? null
                          : () {
                              // Hata Almamak İçin Oyuncu Listesini Buradan Gönderiyoruz
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GameScreen(
                                   // players: setupProvider.players.map((p) => p.name).toList(),
                                    players: setupProvider.players,
                                  ),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        disabledBackgroundColor: Colors.white10,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text(
                        "HAZIRIZ!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: setupProvider.players.length < 2 ? Colors.white24 : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}