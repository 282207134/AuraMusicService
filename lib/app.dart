import 'package:flutter/material.dart';

import 'core/routes.dart';
import 'core/theme.dart';
import 'state/app_controller.dart';
import 'ui/screens/account.dart';
import 'ui/screens/discover.dart';
import 'ui/screens/events.dart';
import 'ui/screens/listening.dart';
import 'ui/screens/search_settings.dart';

class AuraApp extends StatefulWidget {
  const AuraApp({
    super.key,
    required this.controller,
    this.initialRoute = AppRoute.home,
    this.navigatorKey,
  });
  final AppController controller;
  final AppRoute initialRoute;
  final GlobalKey<NavigatorState>? navigatorKey;
  @override
  State<AuraApp> createState() => _AuraAppState();
}

class _AuraAppState extends State<AuraApp> {
  late bool _dark;
  final _lightTheme = auraTheme(false);
  final _darkTheme = auraTheme(true);
  @override
  void initState() {
    super.initState();
    _dark = widget.controller.dark;
    widget.controller.addListener(_syncTheme);
  }

  void _syncTheme() {
    if (_dark != widget.controller.dark) {
      setState(() => _dark = widget.controller.dark);
    }
  }

  @override
  void didUpdateWidget(AuraApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_syncTheme);
      _dark = widget.controller.dark;
      widget.controller.addListener(_syncTheme);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncTheme);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MusicScope(
    controller: widget.controller,
    child: MaterialApp(
      title: 'Aura Music',
      debugShowCheckedModeBanner: false,
      theme: _dark ? _darkTheme : _lightTheme,
      navigatorKey: widget.navigatorKey,
      initialRoute: widget.initialRoute.path,
      builder: (context, child) => ColoredBox(
        color: _dark ? const Color(0xff111111) : const Color(0xffedf1f5),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ClipRect(child: child!),
          ),
        ),
      ),
      onGenerateRoute: (settings) {
        final route = AppRoute.fromPath(settings.name);
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => _screen(route),
        );
      },
    ),
  );
  Widget _screen(AppRoute route) => switch (route) {
    AppRoute.home => const HomeScreen(),
    AppRoute.album => const AlbumScreen(),
    AppRoute.artist => const AlbumScreen(artist: true),
    AppRoute.singles => const ReleasesScreen(albums: false),
    AppRoute.albums => const ReleasesScreen(albums: true),
    AppRoute.chart => const ChartScreen(),
    AppRoute.recommendations => const RecommendationsScreen(),
    AppRoute.genres => const GenresScreen(),
    AppRoute.rock => const GenresScreen(rock: true),
    AppRoute.genreList => const GenreListScreen(),
    AppRoute.library => const LibraryScreen(),
    AppRoute.menu => const MenuScreen(),
    AppRoute.profile => const ProfileScreen(),
    AppRoute.subscription => const SubscriptionScreen(),
    AppRoute.settings => const SettingsScreen(),
    AppRoute.search => const SearchScreen(),
    AppRoute.aura => const AuraScreen(),
    AppRoute.auraConversation => const AuraScreen(conversation: true),
    AppRoute.onboard1 ||
    AppRoute.onboard2 ||
    AppRoute.onboard3 ||
    AppRoute.onboard4 ||
    AppRoute.onboard5 => OnboardingScreen(
      initialPage: route.index - AppRoute.onboard1.index,
    ),
    AppRoute.welcome => const AuthScreen(register: true),
    AppRoute.login => const AuthScreen(),
    AppRoute.hello ||
    AppRoute.taste ||
    AppRoute.songTaste ||
    AppRoute.tasteResult => TasteScreen(route: route),
    AppRoute.radio => const RadioScreen(),
    AppRoute.alternative => const PlayerScreen(radio: true),
    AppRoute.radioTuning => const RadioTuningScreen(),
    AppRoute.player => const PlayerScreen(),
    AppRoute.lyrics => const LyricsScreen(),
    AppRoute.karaoke => const LyricsScreen(karaoke: true),
    AppRoute.identify ||
    AppRoute.listening ||
    AppRoute.identified => IdentifyScreen(route: route),
    AppRoute.equalizer => const EqualizerScreen(),
    AppRoute.events => const EventsScreen(),
    AppRoute.event => const EventDetailScreen(),
    AppRoute.venue => const VenueScreen(),
    AppRoute.seats => const VenueScreen(seats: true),
    AppRoute.payment => const PaymentScreen(),
    AppRoute.ticket => const TicketScreen(),
  };
}
