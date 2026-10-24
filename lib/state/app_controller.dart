import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import '../data/catalog.dart';
import '../services/audio_engine.dart';
import '../services/preferences.dart';

class AppController extends ChangeNotifier {
  AppController({PreferenceStore? preferences, AudioEngine? audio})
    : _preferences = preferences ?? LocalPreferences(),
      _audio = audio ?? LocalAudioEngine() {
    _subscriptions.add(
      _audio.positions.listen((value) {
        position = value;
        notifyListeners();
      }),
    );
    _subscriptions.add(
      _audio.playing.listen((value) {
        isPlaying = value;
        notifyListeners();
      }),
    );
  }
  final PreferenceStore _preferences;
  final AudioEngine _audio;
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  Track track = Catalog.current;
  List<Track> queue = Catalog.allTracks;
  final Set<String> favorites = {};
  final Set<String> selectedGenres = {'Alternative', 'Rock'};
  final Set<int> selectedSeats = {};
  final List<int> bookedSeats = [];
  String ticketHolder = "Jane Foster";
  final List<String> history = ['Nirvana', 'Breaking Benjamin'];
  final Map<String, bool> settings = {
    'Dark theme': true,
    'High sound quality': false,
    'Notifications': true,
  };
  Duration position = Duration.zero;
  static const previewDuration = Duration(seconds: 24);
  bool isPlaying = false, hasPlayed = false, shuffle = false, repeat = false;
  bool ticketPurchased = false, ticketSaved = false, eqEnabled = true;
  String name = 'Jane Foster',
      email = 'j_foster@gmail.com',
      equalizer = 'Rock',
      connection = 'Wi-Fi + Internet';
  String? audioError;
  bool get dark => settings['Dark theme']!;
  int get ticketTotal => selectedSeats.length * 220;
  double get progress =>
      (position.inMilliseconds / previewDuration.inMilliseconds).clamp(0, 1);
  Future<void> load() async {
    try {
      final value = await _preferences.read('aura');
      if (value == null) return;
      final data = jsonDecode(value) as Map<String, dynamic>;
      name = data['name'] as String? ?? name;
      email = data['email'] as String? ?? email;
      favorites.addAll(List<String>.from(data['favorites'] ?? []));
      if (data['genres'] != null) {
        selectedGenres
          ..clear()
          ..addAll(List<String>.from(data['genres']));
      }
      for (final key in settings.keys) {
        settings[key] =
            (data['settings'] as Map?)?[key] as bool? ?? settings[key]!;
      }
      ticketPurchased = data['ticketPurchased'] == true;
      ticketSaved = data['ticketSaved'] == true;
      bookedSeats.addAll(List<int>.from(data['bookedSeats'] ?? []));
      ticketHolder = data['ticketHolder'] as String? ?? name;
      selectedSeats.addAll(List<int>.from(data['seats'] ?? []));
      if (data['history'] != null) {
        history
          ..clear()
          ..addAll(List<String>.from(data['history']));
      }
    } on FormatException {
      /* Keep defaults when local data is malformed. */
    }
    notifyListeners();
  }

  Future<void> persist() => _preferences.write(
    'aura',
    jsonEncode({
      'name': name,
      'email': email,
      'favorites': favorites.toList(),
      'genres': selectedGenres.toList(),
      'settings': settings,
      'history': history,
      'ticketPurchased': ticketPurchased,
      'ticketSaved': ticketSaved,
      'bookedSeats': bookedSeats,
      'ticketHolder': ticketHolder,
      'seats': selectedSeats.toList(),
    }),
  );
  Future<void> play([Track? selected]) async {
    try {
      if (selected != null && selected.id != track.id) {
        track = selected;
        position = Duration.zero;
        if (hasPlayed) await _audio.seek(Duration.zero);
      }
      audioError = null;
      await _audio.play();
      hasPlayed = true;
    } catch (_) {
      audioError = 'Audio could not start. Please try again.';
    }
    notifyListeners();
  }

  Future<void> togglePlayback() async {
    if (isPlaying) {
      await _audio.pause();
    } else {
      await play();
    }
  }

  Future<void> seek(double value) async {
    position = previewDuration * value.clamp(0, 1);
    if (hasPlayed) await _audio.seek(position);
    notifyListeners();
  }

  Future<void> next([int direction = 1]) async {
    final index = queue.indexWhere((t) => t.id == track.id);
    final nextIndex = shuffle
        ? Random().nextInt(queue.length)
        : (index + direction) % queue.length;
    await play(queue[nextIndex]);
  }

  void toggleShuffle() {
    shuffle = !shuffle;
    notifyListeners();
  }

  Future<void> toggleRepeat() async {
    repeat = !repeat;
    await _audio.repeat(repeat);
    notifyListeners();
  }

  Future<void> favorite(Track value) async {
    favorites.contains(value.id)
        ? favorites.remove(value.id)
        : favorites.add(value.id);
    notifyListeners();
    await persist();
  }

  Future<void> setSetting(String key, bool value) async {
    settings[key] = value;
    notifyListeners();
    await persist();
  }

  Future<void> updateProfile(String userName, String userEmail) async {
    name = userName.trim();
    email = userEmail.trim();
    notifyListeners();
    await persist();
  }

  Future<void> toggleGenre(String genre) async {
    selectedGenres.contains(genre)
        ? selectedGenres.remove(genre)
        : selectedGenres.add(genre);
    notifyListeners();
    await persist();
  }

  Future<void> addHistory(String value) async {
    if (value.trim().isEmpty) return;
    history
      ..remove(value.trim())
      ..insert(0, value.trim());
    if (history.length > 8) history.removeLast();
    notifyListeners();
    await persist();
  }

  Future<void> clearHistory() async {
    history.clear();
    notifyListeners();
    await persist();
  }

  void selectSeat(int seat) {
    selectedSeats.contains(seat)
        ? selectedSeats.remove(seat)
        : selectedSeats.add(seat);
    notifyListeners();
  }

  Future<void> purchaseTicket(String holder) async {
    if (selectedSeats.isEmpty || holder.trim().length < 2) {
      throw StateError("Choose seats and a ticket holder");
    }
    bookedSeats
      ..clear()
      ..addAll(selectedSeats.toList()..sort());
    ticketHolder = holder.trim();
    ticketPurchased = true;
    ticketSaved = false;
    notifyListeners();
    await persist();
  }

  Future<void> saveTicket() async {
    ticketSaved = true;
    notifyListeners();
    await persist();
  }

  void setEqualizer(String value) {
    equalizer = value;
    notifyListeners();
  }

  void toggleEqualizer(bool value) {
    eqEnabled = value;
    notifyListeners();
  }

  void setConnection(String value) {
    connection = value;
    notifyListeners();
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    unawaited(_audio.dispose());
    super.dispose();
  }
}

class MusicScope extends InheritedNotifier<AppController> {
  const MusicScope({
    super.key,
    required AppController controller,
    required super.child,
  }) : super(notifier: controller);
  static AppController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MusicScope>()!.notifier!;
}
