import 'package:flutter/material.dart';

import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../data/catalog.dart';
import '../../state/app_controller.dart';
import '../widgets/common.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _search = TextEditingController();
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = MusicScope.of(context);
    final results = Catalog.search(_search.text);
    return PageFrame(
      title: 'Search',
      action: IconButton(
        tooltip: 'Close search',
        onPressed: () => goHome(context),
        icon: const Icon(Icons.close),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            key: const Key('music-search'),
            controller: _search,
            onChanged: (_) => setState(() {}),
            onSubmitted: state.addHistory,
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _search.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear query',
                      onPressed: () {
                        _search.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.close, size: 18),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: context.aura.gradient,
              ),
              child: const Icon(Icons.mic_none, color: Colors.white),
            ),
            title: const Text('Magic search', style: TextStyle(fontSize: 20)),
            subtitle: const Text(
              'Try the music identification demo',
              style: TextStyle(fontSize: 12),
            ),
            onTap: () => go(context, AppRoute.identify),
          ),
          if (_search.text.trim().isNotEmpty) ...[
            SectionTitle('${results.length} results'),
            if (results.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 45,
                      color: context.aura.secondary,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'No tracks found',
                      style: TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try “Breaking Benjamin”, “Rescue” or “Drake”.',
                      style: TextStyle(color: context.aura.secondary),
                    ),
                  ],
                ),
              ),
            for (final track in results)
              GestureDetector(
                onTap: () => state.addHistory(_search.text),
                child: TrackTile(track),
              ),
          ] else ...[
            SectionTitle('History', onSeeAll: state.clearHistory),
            if (state.history.isEmpty)
              Text(
                'Your searches will appear here.',
                style: TextStyle(color: context.aura.secondary),
              ),
            for (var i = 0; i < state.history.length; i++)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 5),
                leading: Disc(i.isEven ? 'artist' : 'band', size: 50),
                title: Text(state.history[i]),
                onTap: () {
                  _search.text = state.history[i];
                  setState(() {});
                },
              ),
            const SectionTitle('Genres'),
            for (var i = 0; i < 5; i++)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 7),
                leading: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: [
                      const Color(0xffffcd90),
                      AuraColors.cyan,
                      AuraColors.pink,
                      const Color(0xff8065a9),
                      AuraColors.blue,
                    ][i],
                  ),
                  child: Icon(
                    [
                      Icons.piano,
                      Icons.eco_outlined,
                      Icons.electric_bolt,
                      Icons.graphic_eq,
                      Icons.headphones,
                    ][i],
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  ['Pop', 'Indie', 'Rock', 'Metal', 'Alternative'][i],
                ),
                subtitle: Text(
                  [
                    'Pop music, Disco, K-pop',
                    'Something independent',
                    'Rock, rock and roll, Progressive rock',
                    'Classic, nu metal, epic',
                    'A different kind of sound',
                  ][i],
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () => go(context, AppRoute.rock),
              ),
          ],
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = MusicScope.of(context);
    return PageFrame(
      title: 'Settings',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Text(
            'Internet connection',
            style: TextStyle(color: context.aura.secondary),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              for (final entry in [
                (Icons.public, 'Wi-Fi + Internet'),
                (Icons.wifi, 'Wi-Fi only'),
                (Icons.power_settings_new, 'Offline mode'),
              ])
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => state.setConnection(entry.$2),
                      child: Container(
                        height: 88,
                        decoration: BoxDecoration(
                          gradient: state.connection == entry.$2
                              ? context.aura.gradient
                              : null,
                          color: state.connection == entry.$2
                              ? null
                              : Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerLow,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              entry.$1,
                              color: state.connection == entry.$2
                                  ? Colors.white
                                  : context.aura.secondary,
                            ),
                            const SizedBox(height: 9),
                            Text(
                              entry.$2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                color: state.connection == entry.$2
                                    ? Colors.white
                                    : context.aura.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'All demo content is available offline.',
            style: TextStyle(fontSize: 11, color: context.aura.secondary),
          ),
          const Divider(height: 50),
          for (final entry in state.settings.entries)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(entry.key, style: const TextStyle(fontSize: 15)),
              subtitle: entry.key == 'Notifications'
                  ? const Text(
                      'Saved preference for future service updates.',
                      style: TextStyle(fontSize: 11),
                    )
                  : entry.key == 'High sound quality'
                  ? const Text(
                      'Saved preference · preview quality is fixed.',
                      style: TextStyle(fontSize: 11),
                    )
                  : null,
              value: entry.value,
              onChanged: (v) => state.setSetting(entry.key, v),
            ),
          const SizedBox(height: 20),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Downloaded tracks'),
            subtitle: const Text(
              'Original Aura preview · 24 seconds',
              style: TextStyle(fontSize: 12),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => go(context, AppRoute.library),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Where to save music?'),
            subtitle: const Text(
              'In the device memory',
              style: TextStyle(fontSize: 12),
            ),
            onTap: () => notice(
              context,
              'The bundled preview is stored with the application.',
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Equalizer'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => go(context, AppRoute.equalizer),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Your musical taste'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => go(context, AppRoute.taste),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Help & about'),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Aura Music',
              applicationVersion: '1.0.0',
              applicationIcon: const AuraLogo(),
              children: [
                const Text(
                  'A Flutter UI implementation of the Pixso Music servise_light design. Includes an original local audio preview and demonstration ticket flow.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'AURA MUSIC   /   LOCAL DEMO',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 2,
              color: context.aura.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
