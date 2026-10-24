import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/routes.dart';
import '../../core/theme.dart';
import '../../data/catalog.dart';
import '../../state/app_controller.dart';

void go(BuildContext context, AppRoute route) =>
    Navigator.of(context).pushNamed(route.path);
void goHome(BuildContext context) =>
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoute.home.path, (_) => false);
void notice(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );

class Art extends StatelessWidget {
  const Art(
    this.name, {
    super.key,
    this.width,
    this.height,
    this.radius = 6,
    this.fit = BoxFit.cover,
  });
  final String name;
  final double? width, height;
  final double radius;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: Image.asset(
      'assets/images/$name.png',
      width: width,
      height: height,
      fit: fit,
      filterQuality: FilterQuality.medium,
    ),
  );
}

class AuraLogo extends StatelessWidget {
  const AuraLogo({super.key, this.size = 34});
  final double size;
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Aura',
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: context.aura.gradient,
      ),
      padding: const EdgeInsets.all(2.5),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    ),
  );
}

class GradientButton extends StatelessWidget {
  const GradientButton(
    this.label, {
    super.key,
    required this.onPressed,
    this.icon,
    this.height = 54,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;
  @override
  Widget build(BuildContext context) => Opacity(
    opacity: onPressed == null ? .42 : 1,
    child: Container(
      height: height,
      decoration: BoxDecoration(
        gradient: context.aura.gradient,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: AuraColors.blue.withValues(alpha: .18),
            blurRadius: 15,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: onPressed,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: 19),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class CircleAction extends StatelessWidget {
  const CircleAction(
    this.icon, {
    super.key,
    required this.onPressed,
    required this.label,
    this.size = 54,
    this.primary = false,
    this.active = false,
  });
  final IconData icon;
  final VoidCallback onPressed;
  final String label;
  final double size;
  final bool primary, active;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: primary ? context.aura.gradient : null,
      color: primary ? null : context.aura.raised,
      border: primary
          ? Border.all(color: context.aura.discRim, width: 3)
          : null,
      boxShadow: [
        BoxShadow(
          color: AuraColors.blue.withValues(alpha: primary ? .25 : .12),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: IconButton(
      tooltip: label,
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: primary
            ? Colors.white
            : active
            ? AuraColors.pink
            : AuraColors.cyan,
        size: primary ? size * .42 : 24,
      ),
    ),
  );
}

class Disc extends StatelessWidget {
  const Disc(
    this.art, {
    super.key,
    this.size = 64,
    this.onTap,
    this.shadow = true,
  });
  final String art;
  final double size;
  final VoidCallback? onTap;
  final bool shadow;
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Record cover',
    button: onTap != null,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.aura.discRim,
          boxShadow: shadow
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .15),
                    blurRadius: size * .1,
                    offset: Offset(0, size * .055),
                  ),
                ]
              : null,
        ),
        padding: EdgeInsets.all(size > 100 ? 6 : 2),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipOval(
              child: Art(art, width: size, height: size, radius: 0),
            ),
            Container(
              width: size * .2,
              height: size * .2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.aura.discHub,
                border: Border.all(
                  color: context.aura.discRim,
                  width: size > 100 ? 3 : 1,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class PageFrame extends StatelessWidget {
  const PageFrame({
    super.key,
    required this.title,
    required this.child,
    this.root = false,
    this.scroll = true,
    this.padding = const EdgeInsets.fromLTRB(25, 18, 25, 32),
    this.action,
    this.subtitle,
    this.miniPlayer = true,
  });
  final String title;
  final Widget child;
  final bool root, scroll, miniPlayer;
  final EdgeInsets padding;
  final Widget? action;
  final String? subtitle;
  @override
  Widget build(BuildContext context) {
    final state = MusicScope.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: root ? 'Open menu' : 'Back',
          icon: Icon(
            root ? Icons.menu_rounded : Icons.chevron_left_rounded,
            size: 28,
          ),
          onPressed: () {
            if (root) {
              go(context, AppRoute.menu);
            } else if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              goHome(context);
            }
          },
        ),
        title: title == 'Home'
            ? GestureDetector(
                onTap: () => go(context, AppRoute.aura),
                child: const AuraLogo(),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
        actions: [
          action ??
              IconButton(
                tooltip: 'Search music',
                onPressed: () => go(context, AppRoute.search),
                icon: const Icon(Icons.search_rounded, size: 28),
              ),
          const SizedBox(width: 9),
        ],
      ),
      body: scroll
          ? SingleChildScrollView(padding: padding, child: child)
          : Padding(padding: padding, child: child),
      bottomNavigationBar: miniPlayer && state.hasPlayed
          ? const MiniPlayer()
          : null,
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.onSeeAll, this.subtitle});
  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 30, bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            if (onSeeAll != null)
              TextButton(
                onPressed: onSeeAll,
                child: Text(
                  'See all',
                  style: TextStyle(color: context.aura.link, fontSize: 13),
                ),
              ),
          ],
        ),
        if (subtitle != null)
          Text(subtitle!, style: TextStyle(color: context.aura.secondary)),
      ],
    ),
  );
}

class ReleaseStrip extends StatelessWidget {
  const ReleaseStrip({super.key});
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 76,
    child: ListView.separated(
      clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      itemCount: Catalog.releases.length,
      separatorBuilder: (_, _) => const SizedBox(width: 17),
      itemBuilder: (context, index) {
        final track = Catalog.releases[index];
        return Center(
          child: Disc(
            track.art,
            onTap: () {
              MusicScope.of(context).play(track);
              go(context, AppRoute.player);
            },
          ),
        );
      },
    ),
  );
}

class TrackTile extends StatelessWidget {
  const TrackTile(this.track, {super.key, this.rank, this.compact = false});
  final Track track;
  final int? rank;
  final bool compact;
  @override
  Widget build(BuildContext context) {
    final state = MusicScope.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: compact ? 5 : 9),
      child: Row(
        children: [
          if (rank != null)
            SizedBox(
              width: 27,
              child: Column(
                children: [
                  Text(
                    '$rank',
                    style: const TextStyle(
                      color: Color(0xffb3b4bc),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    rank == 3 ? Icons.arrow_drop_down : Icons.remove,
                    size: 18,
                    color: rank == 3
                        ? AuraColors.pink
                        : const Color(0xffd2d3d9),
                  ),
                ],
              ),
            ),
          Disc(
            track.art,
            size: compact ? 48 : 60,
            onTap: () {
              state.play(track);
              go(context, AppRoute.player);
            },
          ),
          const SizedBox(width: 15),
          Expanded(
            child: InkWell(
              onTap: () {
                state.play(track);
                go(context, AppRoute.player);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      track.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Track options',
            visualDensity: VisualDensity.compact,
            onPressed: () => trackOptions(context, track),
            icon: Icon(
              Icons.more_vert,
              color: context.aura.secondary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

void trackOptions(BuildContext context, Track track) {
  final state = MusicScope.of(context);
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: Text(track.title), subtitle: Text(track.artist)),
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: Text(
              state.favorites.contains(track.id)
                  ? 'Remove from favorites'
                  : 'Add to favorites',
            ),
            onTap: () {
              state.favorite(track);
              Navigator.pop(sheetContext);
            },
          ),
          ListTile(
            leading: const Icon(Icons.play_arrow),
            title: const Text('Play preview'),
            onTap: () {
              Navigator.pop(sheetContext);
              state.play(track);
              go(context, AppRoute.player);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('View artist'),
            onTap: () {
              Navigator.pop(sheetContext);
              go(context, AppRoute.artist);
            },
          ),
        ],
      ),
    ),
  );
}

class CollectionGrid extends StatelessWidget {
  const CollectionGrid(
    this.items, {
    super.key,
    this.onTap,
    this.description = true,
  });
  final List<MusicCollection> items;
  final void Function(MusicCollection)? onTap;
  final bool description;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, bounds) => GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 22,
        mainAxisExtent: (bounds.maxWidth - 15) / 2 + (description ? 120 : 95),
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () => onTap?.call(item),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(aspectRatio: 1, child: Art(item.art)),
              const SizedBox(height: 12),
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5),
              Text(
                item.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (description)
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    '♡ 547    ·    50 tracks',
                    style: TextStyle(
                      fontSize: 11,
                      color: context.aura.secondary,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    ),
  );
}

class GenreGrid extends StatelessWidget {
  const GenreGrid({super.key});
  @override
  Widget build(BuildContext context) => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: Catalog.genres.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 1.72,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
    ),
    itemBuilder: (context, i) {
      final genre = Catalog.genres[i];
      return InkWell(
        onTap: () => go(context, AppRoute.rock),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Art(genre.art),
              Container(color: Colors.black.withValues(alpha: .26)),
              Center(
                child: Text(
                  genre.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});
  @override
  Widget build(BuildContext context) {
    final state = MusicScope.of(context);
    return SafeArea(
      top: false,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        elevation: 12,
        child: InkWell(
          onTap: () => go(context, AppRoute.player),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(
                value: state.progress,
                minHeight: 2,
                backgroundColor: context.aura.surface,
                color: AuraColors.cyan,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 9, 10, 9),
                child: Row(
                  children: [
                    Disc(state.track.art, size: 38, shadow: false),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.track.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                          Text(
                            state.track.artist,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: state.isPlaying ? 'Pause' : 'Play',
                      onPressed: state.togglePlayback,
                      icon: Icon(
                        state.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: AuraColors.cyan,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Waveform extends StatelessWidget {
  const Waveform({super.key, this.progress = .55});
  final double progress;
  @override
  Widget build(BuildContext context) => CustomPaint(
    size: const Size(double.infinity, 54),
    painter: _WavePainter(progress, context.aura.accent),
  );
}

class _WavePainter extends CustomPainter {
  _WavePainter(this.progress, this.accent);
  final Color accent;
  final double progress;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 65; i++) {
      final height =
          4 + (math.sin(i * 1.7).abs() * math.sin(i * .19).abs() * 37);
      final x = i * size.width / 65;
      paint.color = i / 65 <= progress
          ? accent
          : AuraColors.blue.withValues(alpha: .28);
      canvas.drawLine(
        Offset(x, (size.height - height) / 2),
        Offset(x, (size.height + height) / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.accent != accent;
}
