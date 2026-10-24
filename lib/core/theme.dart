import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract final class AuraColors {
  static const ink = Color(0xff181d28);
  static const muted = Color(0xff82848d);
  static const cyan = Color(0xff12d2cc);
  static const blue = Color(0xff489ee3);
  static const pink = Color(0xfffc3365);
  static const soft = Color(0xfff6f6fa);
  static const gradient = LinearGradient(colors: [cyan, blue]);
}

@immutable
class AuraPalette extends ThemeExtension<AuraPalette> {
  const AuraPalette({
    required this.background,
    required this.surface,
    required this.raised,
    required this.foreground,
    required this.secondary,
    required this.border,
    required this.discRim,
    required this.discHub,
    required this.accent,
    required this.link,
    required this.gradient,
  });

  final Color background, surface, raised, foreground, secondary, border;
  final Color discRim, discHub, accent, link;
  final LinearGradient gradient;

  static const light = AuraPalette(
    background: Colors.white,
    surface: AuraColors.soft,
    raised: Colors.white,
    foreground: AuraColors.ink,
    secondary: AuraColors.muted,
    border: Color(0xffefeff4),
    discRim: Colors.white,
    discHub: Color(0xffeee9e9),
    accent: AuraColors.cyan,
    link: Color(0xff7379b5),
    gradient: AuraColors.gradient,
  );
  static const dark = AuraPalette(
    background: Color(0xff191919),
    surface: Color(0xff222222),
    raised: Color(0xff404040),
    foreground: Colors.white,
    secondary: Color(0xffaaaaaa),
    border: Color(0xff414141),
    discRim: Color(0xff404040),
    discHub: Color(0xff191919),
    accent: Color(0xff1ce0da),
    link: Color(0xff8e99e5),
    gradient: LinearGradient(colors: [Color(0xff1ce0da), Color(0xff479de4)]),
  );

  @override
  AuraPalette copyWith({
    Color? background,
    Color? surface,
    Color? raised,
    Color? foreground,
    Color? secondary,
    Color? border,
    Color? discRim,
    Color? discHub,
    Color? accent,
    Color? link,
    LinearGradient? gradient,
  }) => AuraPalette(
    background: background ?? this.background,
    surface: surface ?? this.surface,
    raised: raised ?? this.raised,
    foreground: foreground ?? this.foreground,
    secondary: secondary ?? this.secondary,
    border: border ?? this.border,
    discRim: discRim ?? this.discRim,
    discHub: discHub ?? this.discHub,
    accent: accent ?? this.accent,
    link: link ?? this.link,
    gradient: gradient ?? this.gradient,
  );

  @override
  AuraPalette lerp(covariant AuraPalette? other, double t) {
    if (other == null) return this;
    return AuraPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      raised: Color.lerp(raised, other.raised, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      discRim: Color.lerp(discRim, other.discRim, t)!,
      discHub: Color.lerp(discHub, other.discHub, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      link: Color.lerp(link, other.link, t)!,
      gradient: LinearGradient.lerp(gradient, other.gradient, t)!,
    );
  }
}

extension AuraThemeContext on BuildContext {
  AuraPalette get aura => Theme.of(this).extension<AuraPalette>()!;
}

ThemeData auraTheme(bool dark) {
  final palette = dark ? AuraPalette.dark : AuraPalette.light;
  final scheme = ColorScheme.fromSeed(
    seedColor: palette.accent,
    brightness: dark ? Brightness.dark : Brightness.light,
    primary: palette.accent,
    onPrimary: AuraColors.ink,
    secondary: AuraColors.blue,
    surface: palette.background,
    onSurface: palette.foreground,
    onSurfaceVariant: palette.secondary,
    surfaceContainerLowest: palette.background,
    surfaceContainerLow: palette.surface,
    surfaceContainer: palette.surface,
    surfaceContainerHigh: palette.raised,
    surfaceContainerHighest: palette.raised,
    outline: palette.border,
    outlineVariant: palette.border,
  );
  final overlay =
      (dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark).copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: palette.background,
        systemNavigationBarDividerColor: palette.background,
      );
  final text = TextTheme(
    headlineLarge: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w500,
      height: 1.2,
    ),
    headlineSmall: const TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w500,
      height: 1.25,
    ),
    titleLarge: const TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
    titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    bodyMedium: const TextStyle(fontSize: 14, height: 1.45),
    bodySmall: const TextStyle(fontSize: 12, height: 1.4),
  ).apply(bodyColor: palette.foreground, displayColor: palette.foreground);
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    extensions: [palette],
    scaffoldBackgroundColor: palette.background,
    canvasColor: palette.background,
    fontFamily: 'sans-serif',
    textTheme: text.copyWith(
      bodySmall: text.bodySmall!.copyWith(color: palette.secondary),
    ),
    iconTheme: IconThemeData(color: palette.foreground),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: palette.background,
      foregroundColor: palette.foreground,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: overlay,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: palette.surface,
      hintStyle: TextStyle(color: palette.secondary),
      labelStyle: TextStyle(color: palette.secondary),
      prefixIconColor: palette.secondary,
      suffixIconColor: palette.secondary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: palette.foreground),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: dark ? palette.background : palette.surface,
      selectedColor: palette.accent.withValues(alpha: dark ? .22 : .15),
      side: BorderSide(
        color: dark ? const Color(0xff555555) : const Color(0xffd5d9dc),
      ),
      labelStyle: TextStyle(color: palette.foreground),
      iconTheme: IconThemeData(color: palette.secondary),
      checkmarkColor: palette.accent,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: palette.surface,
      surfaceTintColor: Colors.transparent,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: palette.surface,
      surfaceTintColor: Colors.transparent,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: dark ? palette.raised : AuraColors.ink,
      contentTextStyle: const TextStyle(color: Colors.white),
    ),
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? palette.accent
            : dark
            ? const Color(0xff333333)
            : null,
      ),
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? Colors.white
            : dark
            ? const Color(0xff777777)
            : null,
      ),
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (_) => dark ? Colors.transparent : null,
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: palette.accent,
      inactiveTrackColor: palette.border,
      thumbColor: palette.accent,
      trackHeight: 2,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
    ),
    dividerTheme: DividerThemeData(color: palette.border, thickness: 1),
  );
}
