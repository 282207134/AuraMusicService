import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../data/catalog.dart';
import '../../state/app_controller.dart';
import '../widgets/common.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key, this.radio = false});
  final bool radio;
  @override
  Widget build(BuildContext context) {
    final state = MusicScope.of(context);
    return PageFrame(
      title: radio ? 'Alternative' : 'Player',
      scroll: false,
      miniPlayer: false,
      action: IconButton(
        tooltip: radio ? 'Tune station' : 'Equalizer',
        onPressed: () =>
            go(context, radio ? AppRoute.radioTuning : AppRoute.equalizer),
        icon: const Icon(Icons.tune),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: [
                const SizedBox(height: 17),
                SizedBox(
                  height: 292,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: -116,
                        top: 68,
                        child: Opacity(
                          opacity: .48,
                          child: Disc('carry', size: 130),
                        ),
                      ),
                      Positioned(
                        right: -116,
                        top: 68,
                        child: Opacity(
                          opacity: .48,
                          child: Disc('album-one', size: 130),
                        ),
                      ),
                      Disc(
                        state.track.art,
                        size: math.min(270, constraints.maxWidth * .85),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    const SizedBox(width: 36),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            state.track.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 22),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            state.track.artist,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'More playback options',
                      onPressed: () => _playerOptions(context),
                      icon: Icon(
                        Icons.more_vert,
                        color: context.aura.secondary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  tooltip: 'Favorite track',
                  onPressed: () => state.favorite(state.track),
                  icon: Icon(
                    state.favorites.contains(state.track.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: AuraColors.pink,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      tooltip: 'Shuffle',
                      onPressed: state.toggleShuffle,
                      icon: Icon(
                        Icons.shuffle,
                        size: 21,
                        color: state.shuffle ? AuraColors.cyan : null,
                      ),
                    ),
                    CircleAction(
                      Icons.skip_previous_rounded,
                      label: 'Previous track',
                      onPressed: () => state.next(-1),
                      size: 49,
                    ),
                    CircleAction(
                      state.isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      label: state.isPlaying ? 'Pause preview' : 'Play preview',
                      onPressed: state.togglePlayback,
                      primary: true,
                      size: 88,
                    ),
                    CircleAction(
                      Icons.skip_next_rounded,
                      label: 'Next track',
                      onPressed: state.next,
                      size: 49,
                    ),
                    IconButton(
                      tooltip: 'Repeat',
                      onPressed: state.toggleRepeat,
                      icon: Icon(
                        Icons.repeat,
                        size: 22,
                        color: state.repeat ? AuraColors.cyan : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Text(
                      _time(state.position),
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Waveform(progress: state.progress)),
                    const SizedBox(width: 12),
                    const Text('0:24', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Slider(
                  value: state.progress,
                  onChanged: state.seek,
                  semanticFormatterCallback: (v) =>
                      '${(v * 24).round()} seconds',
                ),
                Text(
                  'Original Aura preview · 24 seconds',
                  style: TextStyle(color: context.aura.secondary, fontSize: 11),
                ),
                if (state.audioError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      state.audioError!,
                      style: const TextStyle(color: AuraColors.pink),
                    ),
                  ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => go(context, AppRoute.lyrics),
                  child: Text(
                    'LYRICS  ↑',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1.5,
                      color: context.aura.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _time(Duration value) =>
      '${value.inMinutes}:${(value.inSeconds % 60).toString().padLeft(2, '0')}';
  void _playerOptions(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final entry in [
            (Icons.lyrics_outlined, 'Lyrics', AppRoute.lyrics),
            (Icons.mic_none, 'Sing along', AppRoute.karaoke),
            (Icons.queue_music, 'Play queue', AppRoute.library),
            (Icons.tune, 'Equalizer', AppRoute.equalizer),
          ])
            ListTile(
              leading: Icon(entry.$1),
              title: Text(entry.$2),
              onTap: () {
                Navigator.pop(sheetContext);
                go(context, entry.$3);
              },
            ),
        ],
      ),
    ),
  );
}

class LyricsScreen extends StatelessWidget {
  const LyricsScreen({super.key, this.karaoke = false});
  final bool karaoke;
  static const lines = [
    'A little light across the water',
    'A quiet city, waking slowly',
    'We find a rhythm in the morning',
    'And let the sound carry us home',
    '',
    'Every moment has a melody',
    'Every road becomes a song',
    'With the sky above us opening',
    'This is where we both belong',
    '',
    'Let the sound carry us home',
  ];
  @override
  Widget build(BuildContext context) {
    final state = MusicScope.of(context);
    final active = (state.progress * (lines.length - 1)).floor();
    return PageFrame(
      title: karaoke ? 'Sing along' : 'Lyrics',
      miniPlayer: false,
      padding: EdgeInsets.zero,
      action: IconButton(
        tooltip: karaoke ? 'Read lyrics' : 'Sing along',
        onPressed: () => Navigator.pushReplacementNamed(
          context,
          karaoke ? AppRoute.lyrics.path : AppRoute.karaoke.path,
        ),
        icon: Icon(karaoke ? Icons.subject : Icons.mic_none),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Art(
                state.track.art,
                width: double.infinity,
                height: 110,
                radius: 0,
              ),
              Container(
                height: 110,
                color: Colors.black.withValues(alpha: .48),
              ),
              Column(
                children: [
                  Text(
                    state.track.title,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    state.track.artist,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(25, 20, 25, 8),
            child: Text(
              'ORIGINAL PREVIEW LYRICS',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.8,
                color: context.aura.secondary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: karaoke
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < lines.length; i++)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: karaoke ? 13 : 5),
                    child: Text(
                      lines[i],
                      textAlign: karaoke ? TextAlign.center : TextAlign.left,
                      style: TextStyle(
                        fontSize: karaoke ? 19 : 14,
                        height: 1.45,
                        color: karaoke
                            ? i == active
                                  ? AuraColors.pink
                                  : context.aura.secondary
                            : null,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Waveform(progress: state.progress),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: CircleAction(
              state.isPlaying ? Icons.pause : Icons.play_arrow,
              label: 'Toggle preview',
              primary: true,
              onPressed: state.togglePlayback,
            ),
          ),
        ],
      ),
    );
  }
}

class RadioScreen extends StatelessWidget {
  const RadioScreen({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Radio',
    root: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          'Service station',
          onSeeAll: () => go(context, AppRoute.genres),
        ),
        InkWell(
          onTap: () => go(context, AppRoute.alternative),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Art('radio', width: double.infinity, height: 180),
              Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.purple.withValues(alpha: .24),
                ),
              ),
              const Text(
                'Alternative',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ],
          ),
        ),
        SectionTitle(
          'Radio station',
          onSeeAll: () => go(context, AppRoute.genres),
        ),
        for (final station in [
          ('Rockabilly Radio', 'An alternative kind of day', 'just-rock'),
          ('Wild Rock Radio', 'Nightwish · Planet Hell', 'artist'),
          ('Rock On', 'AC/DC · Big Balls', 'saint-asonia'),
          ('Paradise', 'Jethro Tull · Nothing Is Easy', 'carry'),
        ])
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 9),
            leading: Art(station.$3, width: 56, height: 56),
            title: Text(station.$1),
            subtitle: Text(station.$2, style: const TextStyle(fontSize: 12)),
            onTap: () => go(context, AppRoute.alternative),
          ),
      ],
    ),
  );
}

class RadioTuningScreen extends StatefulWidget {
  const RadioTuningScreen({super.key});
  @override
  State<RadioTuningScreen> createState() => _RadioTuningScreenState();
}

class _RadioTuningScreenState extends State<RadioTuningScreen> {
  double energy = .5, feeling = .8;
  String tracks = 'Favorite';
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Alternative',
    subtitle: 'What music will play?',
    child: Column(
      children: [
        const SizedBox(height: 45),
        const Text('Energy', style: TextStyle(fontSize: 22)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Quietly', style: TextStyle(color: context.aura.secondary)),
            Text('Energetic', style: TextStyle(color: context.aura.secondary)),
          ],
        ),
        Slider(value: energy, onChanged: (v) => setState(() => energy = v)),
        const SizedBox(height: 35),
        const Text('Feeling', style: TextStyle(fontSize: 22)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Sad', style: TextStyle(color: context.aura.secondary)),
            Text('Happy', style: TextStyle(color: context.aura.secondary)),
          ],
        ),
        Slider(value: feeling, onChanged: (v) => setState(() => feeling = v)),
        const SizedBox(height: 38),
        const Text('Tracks', style: TextStyle(fontSize: 22)),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: ['All', 'Rare', 'Favorite', 'Popular']
              .map(
                (t) => ChoiceChip(
                  label: SizedBox(
                    width: 102,
                    child: Text(t.toUpperCase(), textAlign: TextAlign.center),
                  ),
                  selected: tracks == t,
                  onSelected: (_) => setState(() => tracks = t),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 35),
        GradientButton(
          'PLAY MY STATION',
          onPressed: () {
            final state = MusicScope.of(context);
            final favorites = Catalog.allTracks
                .where((t) => state.favorites.contains(t.id))
                .toList();
            state.queue = tracks == 'Favorite' && favorites.isNotEmpty
                ? favorites
                : tracks == 'Popular'
                ? Catalog.chart
                : energy > .5
                ? Catalog.albumTracks
                : Catalog.releases;
            state.play(
              state.queue[(feeling * (state.queue.length - 1)).round()],
            );
            go(context, AppRoute.alternative);
          },
        ),
      ],
    ),
  );
}

class IdentifyScreen extends StatelessWidget {
  const IdentifyScreen({super.key, required this.route});
  final AppRoute route;
  @override
  Widget build(BuildContext context) {
    final result = route == AppRoute.identified;
    final listening = route == AppRoute.listening;
    return PageFrame(
      title: 'Identify',
      miniPlayer: false,
      child: Column(
        children: [
          const SizedBox(height: 25),
          if (result) ...[
            const Disc('saint-asonia', size: 260),
            const SizedBox(height: 45),
            const Text('Let Me Live My Life', style: TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            const Text('Saint Asonia'),
            const SizedBox(height: 50),
            CircleAction(
              Icons.play_arrow,
              label: 'Play identified preview',
              primary: true,
              size: 76,
              onPressed: () {
                MusicScope.of(context).play(Catalog.current);
                go(context, AppRoute.player);
              },
            ),
          ] else
            SizedBox(
              height: 400,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  for (var i = 4; i > 0; i--)
                    Container(
                      width: i * 85.0,
                      height: i * 85.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: listening
                            ? AuraColors.cyan.withValues(alpha: .045 * (5 - i))
                            : null,
                        border: Border.all(
                          color: AuraColors.cyan.withValues(alpha: .06),
                        ),
                      ),
                    ),
                  CircleAction(
                    Icons.mic_none,
                    label: listening
                        ? 'Show demo result'
                        : 'Identify demo music',
                    size: 112,
                    primary: true,
                    onPressed: () => go(
                      context,
                      listening ? AppRoute.identified : AppRoute.listening,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 55),
          Text(
            result
                ? 'Demo match found'
                : listening
                ? 'Listening to the demo preview'
                : 'Tap to identify music',
            style: TextStyle(color: context.aura.secondary, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Text(
            'Recognition demo · no microphone recording',
            style: TextStyle(color: context.aura.secondary, fontSize: 11),
          ),
          const SizedBox(height: 30),
          if (listening)
            GradientButton(
              'SHOW DEMO RESULT',
              onPressed: () => go(context, AppRoute.identified),
            ),
          if (result)
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(
                context,
                AppRoute.identify.path,
              ),
              child: Text(
                'TRY AGAIN',
                style: TextStyle(color: context.aura.foreground),
              ),
            ),
        ],
      ),
    );
  }
}

class EqualizerScreen extends StatefulWidget {
  const EqualizerScreen({super.key});
  @override
  State<EqualizerScreen> createState() => _EqualizerScreenState();
}

class _EqualizerScreenState extends State<EqualizerScreen> {
  final bands = [.5, .4, .55, .7, .45];
  double bass = .6, space = .4;
  @override
  Widget build(BuildContext context) {
    final state = MusicScope.of(context);
    return PageFrame(
      title: 'Equalizer',
      miniPlayer: false,
      action: Switch(value: state.eqEnabled, onChanged: state.toggleEqualizer),
      child: Column(
        children: [
          const SizedBox(height: 25),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final preset in ['Blues', 'Jazz', 'Rock', 'Pop', 'Custom'])
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ChoiceChip(
                      label: Text(preset.toUpperCase()),
                      selected: state.equalizer == preset,
                      onSelected: (_) {
                        state.setEqualizer(preset);
                        setState(() {
                          for (var i = 0; i < bands.length; i++) {
                            bands[i] = preset == 'Rock'
                                ? [.5, .4, .55, .7, .45][i]
                                : preset == 'Jazz'
                                ? [.6, .5, .45, .55, .6][i]
                                : .5;
                          }
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 42),
          SizedBox(
            height: 280,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _EqualizerPainter(
                      bands,
                      state.eqEnabled,
                      context.aura.accent,
                      context.aura.secondary,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (var i = 0; i < bands.length; i++)
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              [
                                '60 Hz',
                                '250 Hz',
                                '910 Hz',
                                '3.6 kHz',
                                '14 kHz',
                              ][i],
                              style: TextStyle(
                                fontSize: 10,
                                color: context.aura.secondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: Slider(
                                  value: bands[i],
                                  activeColor: Colors.transparent,
                                  inactiveColor: AuraColors.cyan.withValues(
                                    alpha: .08,
                                  ),
                                  onChanged: state.eqEnabled
                                      ? (v) {
                                          state.setEqualizer('Custom');
                                          setState(() => bands[i] = v);
                                        }
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: _dial(
                  'Bass boost',
                  bass,
                  (v) => setState(() => bass = v),
                ),
              ),
              Expanded(
                child: _dial(
                  'Virtualizer',
                  space,
                  (v) => setState(() => space = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            'Visual preset preview',
            style: TextStyle(fontSize: 13, color: context.aura.secondary),
          ),
          const SizedBox(height: 5),
          Text(
            'Sound processing is not applied to the local sample.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: context.aura.secondary),
          ),
        ],
      ),
    );
  }

  Widget _dial(String label, double value, ValueChanged<double> onChanged) =>
      Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AuraColors.cyan.withValues(alpha: .1),
                width: 8,
              ),
              boxShadow: [
                BoxShadow(
                  color: AuraColors.cyan.withValues(alpha: .1),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Transform.rotate(
              angle: value * math.pi,
              child: const Icon(
                Icons.power_settings_new,
                size: 56,
                color: AuraColors.cyan,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(color: context.aura.secondary, fontSize: 12),
          ),
          Slider(value: value, onChanged: onChanged),
        ],
      );
}

class _EqualizerPainter extends CustomPainter {
  _EqualizerPainter(this.bands, this.enabled, this.accent, this.secondary);
  final Color accent, secondary;
  final List<double> bands;
  final bool enabled;
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    for (var i = 0; i < bands.length; i++) {
      final point = Offset(
        size.width * (i + .5) / bands.length,
        size.height * (1 - bands[i] * .7) - 20,
      );
      if (i == 0) {
        path.moveTo(0, point.dy);
      }
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = enabled ? accent : secondary,
    );
  }

  @override
  bool shouldRepaint(_EqualizerPainter oldDelegate) => true;
}
