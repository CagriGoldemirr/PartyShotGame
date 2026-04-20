import 'package:flutter/material.dart';
import '../../../data/models/player.dart';

class SetupProvider extends ChangeNotifier {
  final List<Player> _players = [];

  List<Player> get players => _players;

  String? addPlayer(String name, String avatarPath) {
    final trimmedName = name.trim();

    // Kısıtlamalar
    if (trimmedName.isEmpty) return "İsim boş olamaz!";
    if (_players.length >= 5) return "Maksimum 5 oyuncu!";
    if (_players.any((p) => p.name.toLowerCase() == trimmedName.toLowerCase())) {
      return "Bu isim zaten ekli!";
    }

    // Benzersiz bir ID (zaman damgası) ile oyuncuyu ekle
    _players.add(Player(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      name: trimmedName,
      avatarPath: avatarPath,
    ));

    notifyListeners();
    return null;
  }

  // Artık isme göre değil, benzersiz ID'ye göre siliyoruz
  void removePlayer(String id) {
    _players.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // Oyunu sıfırlama
  void resetGame() {
    _players.clear();
    notifyListeners();
  }
}