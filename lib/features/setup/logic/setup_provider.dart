import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../data/models/player.dart';

class SetupProvider extends ChangeNotifier {
  List<Player> _players = [];
  List<Player> get players => _players;

  SetupProvider() {
    loadPlayers(); // Uygulama başladığında oyuncuları yükle
  }

  // Oyuncuları Kaydet (Local Storage)
  Future<void> savePlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      _players.map((p) => {
        'id': p.id,
        'name': p.name,
        'avatarPath': p.avatarPath
      }).toList(),
    );
    await prefs.setString('saved_players', encodedData);
  }

  // Oyuncuları Yükle
  Future<void> loadPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('saved_players');
    if (savedData != null) {
      final List<dynamic> decodedData = json.decode(savedData);
      _players = decodedData.map((item) => Player(
        id: item['id'],
        name: item['name'],
        avatarPath: item['avatarPath'],
      )).toList();
      notifyListeners();
    }
  }

  String? addPlayer(String name, String avatarPath) {
    if (name.isEmpty) return "İsim boş olamaz!";
    if (_players.any((p) => p.name.toLowerCase() == name.toLowerCase())) {
      return "Bu isim zaten eklenmiş!";
    }
    if (_players.length >= 12) return "Maksimum 12 oyuncu eklenebilir.";

    _players.add(Player(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      avatarPath: avatarPath,
    ));
    
    savePlayers(); // Listeyi güncelle ve kaydet
    notifyListeners();
    return null;
  }

  void removePlayer(String id) {
    _players.removeWhere((p) => p.id == id);
    savePlayers(); // Güncel listeyi kaydet
    notifyListeners();
  }

  void resetGame() {
    _players.clear();
    savePlayers();
    notifyListeners();
  }
}