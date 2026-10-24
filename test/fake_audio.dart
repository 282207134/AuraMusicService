import 'dart:async';

import 'package:aura_music/services/audio_engine.dart';

class FakeAudio implements AudioEngine {
  final _positions = StreamController<Duration>.broadcast();
  final _playing = StreamController<bool>.broadcast();
  Duration position = Duration.zero;
  bool looping = false;
  @override
  Stream<Duration> get positions => _positions.stream;
  @override
  Stream<bool> get playing => _playing.stream;
  @override
  Future<void> play() async {
    _playing.add(true);
  }

  @override
  Future<void> pause() async {
    _playing.add(false);
  }

  @override
  Future<void> seek(Duration value) async {
    position = value;
    _positions.add(value);
  }

  @override
  Future<void> repeat(bool enabled) async {
    looping = enabled;
  }

  @override
  Future<void> dispose() async {
    await _positions.close();
    await _playing.close();
  }
}
