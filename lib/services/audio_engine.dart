import 'package:audioplayers/audioplayers.dart';

abstract class AudioEngine {
  Stream<Duration> get positions;
  Stream<bool> get playing;
  Future<void> play();
  Future<void> pause();
  Future<void> seek(Duration position);
  Future<void> repeat(bool enabled);
  Future<void> dispose();
}

class LocalAudioEngine implements AudioEngine {
  LocalAudioEngine() {
    _player.positionUpdater = TimerPositionUpdater(
      interval: const Duration(milliseconds: 250),
      getPosition: _player.getCurrentPosition,
    );
  }
  final _player = AudioPlayer();
  bool _loaded = false;
  bool _loop = false;
  @override
  Stream<Duration> get positions => _player.onPositionChanged;
  @override
  Stream<bool> get playing =>
      _player.onPlayerStateChanged.map((s) => s == PlayerState.playing);
  @override
  Future<void> play() async {
    if (_loaded) {
      await _player.resume();
    } else {
      await _player.setReleaseMode(_loop ? ReleaseMode.loop : ReleaseMode.stop);
      await _player.play(AssetSource('audio/aura-preview.wav'));
      _loaded = true;
    }
  }

  @override
  Future<void> pause() => _player.pause();
  @override
  Future<void> seek(Duration position) => _player.seek(position);
  @override
  Future<void> repeat(bool enabled) async {
    _loop = enabled;
    await _player.setReleaseMode(enabled ? ReleaseMode.loop : ReleaseMode.stop);
  }

  @override
  Future<void> dispose() => _player.dispose();
}
