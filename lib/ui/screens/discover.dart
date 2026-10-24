import 'package:flutter/material.dart';

import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../data/catalog.dart';
import '../../state/app_controller.dart';
import '../widgets/common.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Home',
    root: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 275,
          child: ListView.separated(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            separatorBuilder: (_, _) => const SizedBox(width: 20),
            itemBuilder: (context, index) => SizedBox(
              width: 315,
              child: InkWell(
                onTap: () =>
                    go(context, index == 0 ? AppRoute.album : AppRoute.event),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Art(
                          index == 0 ? 'band' : 'event',
                          width: 315,
                          height: 180,
                        ),
                        Positioned(
                          left: 15,
                          bottom: 15,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: .4),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              index == 0 ? 'ALBUM' : 'CONCERT',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      index == 0
                          ? 'Dark side Breaking Benjamin'
                          : 'Imagine Dragons',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 19),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      index == 0
                          ? 'The new album by the American Alt-rockers'
                          : 'A night to remember. Find your place.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SectionTitle(
          'New release',
          subtitle: 'tracks, albums and compilations',
          onSeeAll: () => go(context, AppRoute.singles),
        ),
        const ReleaseStrip(),
        SectionTitle('Chart', onSeeAll: () => go(context, AppRoute.chart)),
        for (var i = 0; i < 5; i++) TrackTile(Catalog.chart[i], rank: i + 1),
        SectionTitle(
          'Hot playlists',
          onSeeAll: () => go(context, AppRoute.recommendations),
        ),
        CollectionGrid(
          Catalog.playlists,
          onTap: (_) => go(context, AppRoute.album),
        ),
        const SectionTitle('Selections'),
        const GenreGrid(),
      ],
    ),
  );
}

class ReleasesScreen extends StatelessWidget {
  const ReleasesScreen({super.key, required this.albums});
  final bool albums;
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'New release',
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ReleaseTab('Single', !albums, () {
              if (albums) {
                Navigator.pushReplacementNamed(context, AppRoute.singles.path);
              }
            }),
            const SizedBox(width: 38),
            _ReleaseTab('Album', albums, () {
              if (!albums) {
                Navigator.pushReplacementNamed(context, AppRoute.albums.path);
              }
            }),
          ],
        ),
        const SizedBox(height: 30),
        if (albums)
          CollectionGrid(
            [...Catalog.albums, ...Catalog.albums.take(2)],
            description: false,
            onTap: (_) => go(context, AppRoute.album),
          )
        else
          LayoutBuilder(
            builder: (context, bounds) => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: Catalog.releases.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 22,
                mainAxisSpacing: 20,
                mainAxisExtent: (bounds.maxWidth - 22) / 2 + 65,
              ),
              itemBuilder: (context, index) {
                final track = Catalog.releases[index];
                return InkWell(
                  onTap: () {
                    MusicScope.of(context).play(track);
                    go(context, AppRoute.player);
                  },
                  child: Column(
                    children: [
                      Disc(track.art, size: (bounds.maxWidth - 22) / 2),
                      const SizedBox(height: 14),
                      Text(
                        track.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        track.artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    ),
  );
}

class _ReleaseTab extends StatelessWidget {
  const _ReleaseTab(this.label, this.selected, this.onTap);
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        border: selected
            ? const Border(bottom: BorderSide(color: AuraColors.cyan, width: 2))
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 20,
          color: selected ? null : context.aura.secondary,
        ),
      ),
    ),
  );
}

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Chart',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Tracks that are\npopular right now',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 25),
        SizedBox(
          width: 140,
          child: GradientButton(
            'SHUFFLE',
            icon: Icons.shuffle,
            height: 42,
            onPressed: () {
              final state = MusicScope.of(context);
              if (!state.shuffle) state.toggleShuffle();
              state.play(Catalog.chart.first);
              go(context, AppRoute.player);
            },
          ),
        ),
        const SizedBox(height: 20),
        for (var i = 0; i < Catalog.chart.length; i++)
          TrackTile(Catalog.chart[i], rank: i + 1),
        const SizedBox(height: 15),
        Text(
          'A selection from the reference music catalog.',
          style: TextStyle(color: context.aura.secondary, fontSize: 12),
        ),
      ],
    ),
  );
}

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'Recommendations',
    root: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Made for your mood',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'A little familiar. A little unexpected.',
          style: TextStyle(color: context.aura.secondary),
        ),
        const SectionTitle('Playlists'),
        CollectionGrid(
          Catalog.playlists,
          onTap: (_) => go(context, AppRoute.album),
        ),
        const SectionTitle('Like alternative, and this heard?'),
        const TrackTile(Catalog.current),
        for (final track in Catalog.releases.take(3)) TrackTile(track),
        SectionTitle(
          'Discover your sound',
          onSeeAll: () => go(context, AppRoute.taste),
        ),
        const GenreGrid(),
      ],
    ),
  );
}

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({super.key, this.artist = false});
  final bool artist;
  @override
  Widget build(BuildContext context) {
    final state = MusicScope.of(context);
    return PageFrame(
      title: artist ? 'Artist' : 'Album',
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Art(
                artist ? 'artist' : 'ember',
                width: double.infinity,
                height: artist ? 234 : 310,
                radius: 0,
              ),
              Positioned(
                bottom: -24,
                right: 24,
                child: CircleAction(
                  Icons.play_arrow,
                  label: 'Play album',
                  onPressed: () {
                    state.queue = Catalog.albumTracks;
                    state.play(Catalog.albumTracks[1]);
                    go(context, AppRoute.player);
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 3),
                Text(
                  artist ? 'Breaking Benjamin' : 'Ember',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 5),
                InkWell(
                  onTap: () => go(context, AppRoute.artist),
                  child: Text(
                    artist ? 'Alternative' : 'Breaking Benjamin · 2018',
                    style: TextStyle(color: context.aura.secondary),
                  ),
                ),
                if (artist) ...[
                  const SizedBox(height: 22),
                  const Text(
                    'American rock band from Wilkes-Barre, Pennsylvania, founded in 1999.',
                  ),
                  const SectionTitle('Popular tracks'),
                ],
                const SizedBox(height: 20),
                for (
                  var i = 0;
                  i < (artist ? 5 : Catalog.albumTracks.length);
                  i++
                )
                  if (artist)
                    TrackTile(Catalog.albumTracks[i])
                  else
                    InkWell(
                      onTap: () {
                        state.queue = Catalog.albumTracks;
                        state.play(Catalog.albumTracks[i]);
                        go(context, AppRoute.player);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 30,
                              child: Text(
                                '${i + 1}',
                                style: const TextStyle(
                                  color: Color(0xffb7b8be),
                                ),
                              ),
                            ),
                            Expanded(child: Text(Catalog.albumTracks[i].title)),
                            Text(
                              Catalog.albumTracks[i].length,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                SectionTitle(
                  'More albums',
                  onSeeAll: () => go(context, AppRoute.albums),
                ),
                CollectionGrid(
                  Catalog.albums.take(2).toList(),
                  description: false,
                  onTap: (_) => go(context, AppRoute.album),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GenresScreen extends StatelessWidget {
  const GenresScreen({super.key, this.rock = false});
  final bool rock;
  @override
  Widget build(BuildContext context) => PageFrame(
    title: rock ? 'Rock' : 'Genres',
    root: true,
    padding: EdgeInsets.zero,
    action: IconButton(
      tooltip: 'List of genres',
      onPressed: () => go(context, AppRoute.genreList),
      icon: const Icon(Icons.tune),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Art(
              rock ? 'rock' : 'genres',
              width: double.infinity,
              height: 235,
              radius: 0,
            ),
            Container(
              height: 235,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
            ),
            Positioned(
              bottom: 24,
              left: 25,
              child: Text(
                rock ? 'Rock' : 'Music of all genres',
                style: const TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                'Hot playlists',
                onSeeAll: () => go(context, AppRoute.recommendations),
              ),
              CollectionGrid(
                Catalog.playlists.take(2).toList(),
                onTap: (_) => go(context, AppRoute.album),
              ),
              const SectionTitle('Popular artists'),
              SizedBox(
                height: 94,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  separatorBuilder: (_, _) => const SizedBox(width: 18),
                  itemBuilder: (context, i) => GestureDetector(
                    onTap: () => go(context, AppRoute.artist),
                    child: Column(
                      children: [
                        Disc(
                          [
                            'band',
                            'artist',
                            'event',
                            'numb',
                            'saint-asonia',
                          ][i],
                          size: 59,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          [
                            'Metallica',
                            'Temptation',
                            'Nightwish',
                            'Slipknot',
                            'Sabaton',
                          ][i],
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SectionTitle(
                'New albums',
                onSeeAll: () => go(context, AppRoute.albums),
              ),
              CollectionGrid(
                Catalog.albums.take(2).toList(),
                description: false,
                onTap: (_) => go(context, AppRoute.album),
              ),
              const SectionTitle('Popular tracks'),
              for (final track in Catalog.chart.take(4)) TrackTile(track),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ],
    ),
  );
}

class GenreListScreen extends StatefulWidget {
  const GenreListScreen({super.key});
  @override
  State<GenreListScreen> createState() => _GenreListScreenState();
}

class _GenreListScreenState extends State<GenreListScreen> {
  String expanded = 'Rock';
  @override
  Widget build(BuildContext context) => PageFrame(
    title: 'List of genres',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FIND YOUR FREQUENCY',
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 2,
            color: context.aura.secondary,
          ),
        ),
        const SizedBox(height: 25),
        Wrap(
          spacing: 10,
          runSpacing: 12,
          children:
              [
                    'Mood',
                    'For training',
                    'Pop',
                    'Indie',
                    'Metal',
                    'Rock',
                    'Dancing',
                    'Electronics',
                    'R&B',
                    'Rap and hip-hop',
                    'Reggae',
                    'Jazz',
                    'Blues',
                    'Ska',
                    'Punk',
                    'Stage',
                    'Classic',
                    'Chanson',
                  ]
                  .map(
                    (value) => ActionChip(
                      label: Text(value),
                      avatar: Icon(
                        expanded == value
                            ? Icons.expand_less
                            : Icons.expand_more,
                        size: 16,
                      ),
                      onPressed: () => setState(() => expanded = value),
                      backgroundColor: expanded == value
                          ? AuraColors.cyan.withValues(alpha: .15)
                          : null,
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 30),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: context.aura.gradient,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                expanded,
                style: const TextStyle(color: Colors.white, fontSize: 23),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 9,
                runSpacing: 9,
                children:
                    [
                          'Rock and roll',
                          'Progressive',
                          'Post-rock',
                          'New wave',
                          'Folk-rock',
                          'Stoner',
                          'Hard',
                        ]
                        .map(
                          (label) => ActionChip(
                            backgroundColor: const Color(0xff2d9cbd),
                            side: BorderSide.none,
                            label: Text(
                              label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            onPressed: () => go(context, AppRoute.rock),
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        GradientButton(
          'EXPLORE $expanded'.toUpperCase(),
          onPressed: () => go(context, AppRoute.rock),
        ),
      ],
    ),
  );
}

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});
  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String? filter;
  @override
  Widget build(BuildContext context) {
    final state = MusicScope.of(context);
    final favoriteTracks = Catalog.allTracks
        .where((t) => state.favorites.contains(t.id))
        .toList();
    return PageFrame(
      title: 'My music',
      root: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: context.aura.gradient,
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                BoxShadow(
                  color: AuraColors.cyan.withValues(alpha: .2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${Catalog.allTracks.length} tracks',
                        style: const TextStyle(
                          fontSize: 23,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${favoriteTracks.length} favorites · local preview',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Shuffle library',
                  onPressed: () {
                    state.toggleShuffle();
                    state.play();
                    go(context, AppRoute.player);
                  },
                  icon: const Icon(Icons.shuffle, color: Colors.white),
                ),
                IconButton(
                  tooltip: 'Play library',
                  onPressed: () {
                    state.play();
                    go(context, AppRoute.player);
                  },
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 33,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          for (final entry in [
            (Icons.music_note_outlined, 'Tracks'),
            (Icons.album_outlined, 'Albums'),
            (Icons.person_outline, 'Artists'),
            (Icons.queue_music, 'Playlists'),
            (Icons.favorite_outline, 'Favorites'),
            (Icons.folder_outlined, 'Offline'),
          ])
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(entry.$1, color: context.aura.secondary),
              title: Text(
                entry.$2,
                style: TextStyle(
                  fontSize: 21,
                  color: filter == entry.$2
                      ? AuraColors.cyan
                      : context.aura.secondary,
                ),
              ),
              trailing: filter == entry.$2
                  ? const Icon(Icons.expand_less, color: AuraColors.cyan)
                  : null,
              onTap: () =>
                  setState(() => filter = filter == entry.$2 ? null : entry.$2),
            ),
          if (filter == 'Tracks') ...[
            const SectionTitle('All tracks'),
            for (final track in Catalog.allTracks) TrackTile(track),
          ] else if (filter == 'Favorites') ...[
            const SectionTitle('Your favorites'),
            if (favoriteTracks.isEmpty)
              Text(
                'Tap the heart on a track to keep it here.',
                style: TextStyle(color: context.aura.secondary),
              ),
            for (final track in favoriteTracks) TrackTile(track),
          ] else if (filter == 'Albums' || filter == 'Playlists') ...[
            SectionTitle(filter!),
            CollectionGrid(
              filter == 'Albums' ? Catalog.albums : Catalog.playlists,
              onTap: (_) => go(context, AppRoute.album),
            ),
          ] else if (filter == 'Offline') ...[
            const SectionTitle('Available offline'),
            const TrackTile(Catalog.current),
            Text(
              'An original 24-second Aura preview is bundled with the app.',
              style: TextStyle(color: context.aura.secondary),
            ),
          ] else ...[
            SectionTitle(filter == 'Artists' ? 'Artists' : 'Last listened'),
            const ReleaseStrip(),
            const SizedBox(height: 25),
            for (final item in [
              ('Red Hot Chili Peppers', 'artist'),
              ('Guano Apes', 'band'),
              ('Queen', 'event'),
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: InkWell(
                  onTap: () => go(context, AppRoute.artist),
                  child: Row(
                    children: [
                      Art(item.$2, width: 90, height: 90),
                      const SizedBox(width: 17),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.$1, style: const TextStyle(fontSize: 17)),
                            const SizedBox(height: 6),
                            const Text(
                              'Albums, tracks and more',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'rock',
                              style: TextStyle(color: context.aura.secondary),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.more_vert, color: context.aura.secondary),
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
