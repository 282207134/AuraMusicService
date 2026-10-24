import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aura_music/app.dart';
import 'package:aura_music/core/routes.dart';
import 'package:aura_music/core/theme.dart';
import 'package:aura_music/data/catalog.dart';
import 'package:aura_music/services/preferences.dart';
import 'package:aura_music/state/app_controller.dart';

import 'fake_audio.dart';
import 'layout_assets.dart';

void main() {
  test('search matches titles and artists and handles empty results', () {
    expect(Catalog.search('  RESCUE  ').single.id, 'rescue');
    expect(Catalog.search('breaking benjamin').length, 12);
    expect(Catalog.search('nonexistent'), isEmpty);
    expect(Catalog.search(' '), isEmpty);
  });
  test(
    'favorites, profile, preferences and ticket snapshots survive reload',
    () async {
      final preferences = MemoryPreferences();
      final state = AppController(preferences: preferences, audio: FakeAudio());
      await state.favorite(Catalog.current);
      await state.updateProfile('Alex', 'alex@example.com');
      await state.setSetting('Dark theme', true);
      state.selectSeat(42);
      state.selectSeat(43);
      await state.purchaseTicket('Alex');
      await state.saveTicket();
      state.selectSeat(44);
      final restored = AppController(
        preferences: preferences,
        audio: FakeAudio(),
      );
      await restored.load();
      expect(restored.favorites, contains('saint'));
      expect(restored.name, 'Alex');
      expect(restored.dark, isTrue);
      expect(restored.ticketSaved, isTrue);
      expect(restored.bookedSeats, [42, 43]);
      expect(restored.ticketHolder, 'Alex');
      await state.favorite(Catalog.current);
      expect(state.favorites, isEmpty);
      state.dispose();
      restored.dispose();
    },
  );
  test(
    'booking rejects missing seats and player delegates playback and seeking',
    () async {
      final audio = FakeAudio();
      final state = AppController(
        preferences: MemoryPreferences(),
        audio: audio,
      );
      await expectLater(state.purchaseTicket('Alex'), throwsStateError);
      await state.play(Catalog.releases.first);
      await Future<void>.delayed(Duration.zero);
      expect(state.isPlaying, isTrue);
      expect(state.track.id, 'rescue');
      await state.seek(.5);
      expect(audio.position, const Duration(seconds: 12));
      await state.toggleRepeat();
      expect(audio.looping, isTrue);
      await state.next(-1);
      expect(state.track.id, 'saint');
      await state.togglePlayback();
      await Future<void>.delayed(Duration.zero);
      expect(state.isPlaying, isFalse);
      state.dispose();
    },
  );
  for (final dark in [false, true]) {
    for (final width in [375.0, 600.0]) {
      testWidgets(
        'all 45 routes render at $width in ${dark ? 'dark' : 'light'} theme',
        (tester) async {
          tester.view.physicalSize = Size(width, 850);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          final state = AppController(
            preferences: MemoryPreferences(),
            audio: FakeAudio(),
          );
          await state.setSetting('Dark theme', dark);
          state.selectSeat(42);
          await state.purchaseTicket('Jane Foster');
          final navigator = GlobalKey<NavigatorState>();
          await tester.pumpWidget(
            DefaultAssetBundle(
              bundle: LayoutAssets(),
              child: AuraApp(controller: state, navigatorKey: navigator),
            ),
          );
          await tester.pumpAndSettle();
          for (final route in AppRoute.values) {
            navigator.currentState!.pushNamedAndRemoveUntil(
              route.path,
              (_) => false,
            );
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull, reason: route.name);
          }
          await tester.pumpWidget(const SizedBox.shrink());
          state.dispose();
        },
      );
    }
  }
  testWidgets('search and empty state respond to user input', (tester) async {
    final state = AppController(
      preferences: MemoryPreferences(),
      audio: FakeAudio(),
    );
    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: LayoutAssets(),
        child: AuraApp(controller: state, initialRoute: AppRoute.search),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('music-search')), 'Rescue');
    await tester.pumpAndSettle();
    expect(find.text('Rescue Me'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('music-search')), 'xxxx');
    await tester.pumpAndSettle();
    expect(find.text('No tracks found'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    state.dispose();
  });
  testWidgets('dark defaults, token colors and theme switching persist', (
    tester,
  ) async {
    final preferences = MemoryPreferences();
    final state = AppController(preferences: preferences, audio: FakeAudio());
    expect(state.dark, isTrue);
    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: LayoutAssets(),
        child: AuraApp(controller: state, initialRoute: AppRoute.player),
      ),
    );
    await tester.pumpAndSettle();
    ThemeData activeTheme() =>
        tester.widget<MaterialApp>(find.byType(MaterialApp)).theme!;
    expect(activeTheme().scaffoldBackgroundColor, const Color(0xff191919));
    expect(
      activeTheme().extension<AuraPalette>()!.surface,
      const Color(0xff222222),
    );
    expect(
      activeTheme().extension<AuraPalette>()!.discRim,
      const Color(0xff404040),
    );
    expect(activeTheme().textTheme.bodyMedium!.color, Colors.white);
    await state.play(Catalog.current);
    await tester.pumpAndSettle();
    await state.setSetting('Dark theme', false);
    await tester.pumpAndSettle();
    expect(activeTheme().brightness, Brightness.light);
    expect(activeTheme().scaffoldBackgroundColor, Colors.white);
    expect(state.isPlaying, isTrue);
    expect(find.text('Player'), findsOneWidget);
    final restored = AppController(
      preferences: preferences,
      audio: FakeAudio(),
    );
    await restored.load();
    expect(restored.dark, isFalse);
    await state.setSetting('Dark theme', true);
    await tester.pumpAndSettle();
    expect(activeTheme().brightness, Brightness.dark);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    state.dispose();
    restored.dispose();
  });
}
