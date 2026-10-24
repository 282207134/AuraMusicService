import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:aura_music/app.dart';
import 'package:aura_music/core/routes.dart';
import 'package:aura_music/data/catalog.dart';
import 'package:aura_music/services/preferences.dart';
import 'package:aura_music/state/app_controller.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'capture both themes and verify audio, theme persistence and booking',
    (tester) async {
      final state = AppController(preferences: MemoryPreferences());
      final navigator = GlobalKey<NavigatorState>();
      await state.favorite(Catalog.current);
      await tester.pumpWidget(
        AuraApp(controller: state, navigatorKey: navigator),
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
        await Future.wait(
          manifest
              .listAssets()
              .where((path) => path.startsWith('assets/images/'))
              .map(
                (path) =>
                    precacheImage(AssetImage(path), navigator.currentContext!),
              ),
        );
      });
      await tester.pumpAndSettle();
      await binding.convertFlutterSurfaceToImage();

      for (final dark in [false, true]) {
        final prefix = dark ? 'dark/' : '';
        await state.setSetting('Dark theme', dark);
        state.hasPlayed = false;
        state.position = Duration.zero;
        state.selectedSeats
          ..clear()
          ..addAll([85, 86]);
        await state.purchaseTicket('Jane Foster');
        for (var i = 0; i < AppRoute.values.length; i++) {
          final route = AppRoute.values[i];
          navigator.currentState!.pushNamedAndRemoveUntil(
            route.path,
            (_) => false,
          );
          await tester.pumpAndSettle();
          await tester.pump(const Duration(milliseconds: 300));
          expect(
            tester.takeException(),
            isNull,
            reason: '${dark ? 'dark' : 'light'} ${route.name}',
          );
          await binding.takeScreenshot(
            '$prefix${(i + 1).toString().padLeft(2, '0')}-${route.name}',
          );
        }
        navigator.currentState!.pushNamedAndRemoveUntil(
          AppRoute.search.path,
          (_) => false,
        );
        await tester.pumpAndSettle();
        await tester.enterText(find.byKey(const Key('music-search')), 'Rescue');
        await tester.pumpAndSettle();
        expect(find.text('Rescue Me'), findsOneWidget);
        await binding.takeScreenshot('${prefix}46-search-results');
        await tester.enterText(
          find.byKey(const Key('music-search')),
          'no matching song',
        );
        await tester.pumpAndSettle();
        expect(find.text('No tracks found'), findsOneWidget);
        await binding.takeScreenshot('${prefix}47-search-empty');
        FocusManager.instance.primaryFocus?.unfocus();
        await state.play(Catalog.current);
        await tester.runAsync(() async {
          final deadline = DateTime.now().add(const Duration(seconds: 10));
          while (state.position == Duration.zero &&
              DateTime.now().isBefore(deadline)) {
            await Future<void>.delayed(const Duration(milliseconds: 250));
          }
        });
        await tester.pump();
        expect(state.isPlaying, isTrue);
        expect(state.position.inMilliseconds, greaterThan(0));
        await state.seek(.5);
        await state.togglePlayback();
        await tester.pumpAndSettle();
        expect(state.isPlaying, isFalse);
        expect(state.audioError, isNull);
        navigator.currentState!.pushNamedAndRemoveUntil(
          AppRoute.seats.path,
          (_) => false,
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('seat-87')));
        await tester.pumpAndSettle();
        expect(state.selectedSeats.length, 3);
        await tester.tap(find.text('Buy 3 tickets for \$ 660'));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const Key('ticket-name')),
          'Alex Foster',
        );
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('CONFIRM DEMO BOOKING'));
        await tester.tap(find.text('CONFIRM DEMO BOOKING'));
        await tester.pumpAndSettle();
        expect(state.ticketHolder, 'Alex Foster');
        expect(state.bookedSeats.length, 3);
        await binding.takeScreenshot('${prefix}48-ticket-booked');
        await tester.tap(find.text('SAVE TO MY TICKETS'));
        await tester.pumpAndSettle();
        expect(state.ticketSaved, isTrue);
        ScaffoldMessenger.of(navigator.currentContext!).clearSnackBars();
        await tester.pumpAndSettle();
        await state.setSetting('Dark theme', !dark);
        navigator.currentState!.pushNamedAndRemoveUntil(
          AppRoute.home.path,
          (_) => false,
        );
        await tester.pumpAndSettle();
        await binding.takeScreenshot(
          '$prefix${dark ? '49-home-light' : '49-home-dark'}',
        );
        await state.setSetting('Dark theme', dark);
      }
      await tester.pumpWidget(const SizedBox.shrink());
      state.dispose();
    },
  );
}
