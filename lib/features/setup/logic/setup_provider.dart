// Rastgele sayı üretmek için
import 'package:flutter/material.dart';
import '../../../data/models/player.dart';

class SetupProvider extends ChangeNotifier {
  final List<Player> _players = [];

  List<Player> get players => _players;

  // Artık avatarPath bilgisini de parametre olarak istiyoruz
  String? addPlayer(String name, String avatarPath) {
    if (name.trim().isEmpty) return "İsim boş olamaz!";
    if (name.length > 12) return "Maksimum 12 karakter!";
    
    // Aynı isimden var mı kontrolü
    if (_players.any((p) => p.name.toLowerCase() == name.trim().toLowerCase())) {
      return "Bu isim zaten ekli!";
    }
    
    // Çemberin kalabalık olabilmesi için limiti 8 yaptık
    if (_players.length >= 8) return "Maksimum 8 oyuncu!"; 

    // Rastgele seçimi sildik, doğrudan parametreden gelen avatarı ekliyoruz
    _players.add(Player(name: name.trim(), avatarPath: avatarPath));
    notifyListeners();
    
    return null;
  }

  void removePlayer(int index) {
    _players.removeAt(index);
    notifyListeners();
  }

  void resetGame() {
    _players.clear();
    notifyListeners();
  }
}