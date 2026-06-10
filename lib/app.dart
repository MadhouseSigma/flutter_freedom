import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_freedom/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'providers/app_provider.dart';
import 'screens/home_screen.dart';

class FlutterFreedomApp extends StatelessWidget {
  const FlutterFreedomApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<AppProvider>().locale;

    return MaterialApp(
      title: 'Flutter Freedom',
      debugShowCheckedModeBanner: false,

      // ── Localisation ──────────────────────────────────────────────────────
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('fa')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ── Theme ─────────────────────────────────────────────────────────────
      themeMode: ThemeMode.dark,

      darkTheme: _buildDarkTheme(isRtl: locale.languageCode == 'fa'),
      // darkTheme: ThemeData(fontFamily: "IranSans", brightness: Brightness.dark),

      // ── BotToast ──────────────────────────────────────────────────────────
      builder: BotToastInit(),

      navigatorObservers: [BotToastNavigatorObserver()],

      home: const HomeScreen(),
    );
  }

  ThemeData _buildDarkTheme({bool isRtl = false}) {
    const seed = Color(0xFF54C5F8);
    final base = ThemeData.dark(useMaterial3: true);
    const persianFont = 'IranSans';

    TextTheme applyFont(TextTheme t) => isRtl
        ? t.copyWith(
            displayLarge: t.displayLarge?.copyWith(fontFamily: persianFont),
            displayMedium: t.displayMedium?.copyWith(fontFamily: persianFont),
            displaySmall: t.displaySmall?.copyWith(fontFamily: persianFont),
            headlineLarge: t.headlineLarge?.copyWith(fontFamily: persianFont),
            headlineMedium: t.headlineMedium?.copyWith(fontFamily: persianFont),
            headlineSmall: t.headlineSmall?.copyWith(fontFamily: persianFont),
            titleLarge: t.titleLarge?.copyWith(fontFamily: persianFont),
            titleMedium: t.titleMedium?.copyWith(fontFamily: persianFont),
            titleSmall: t.titleSmall?.copyWith(fontFamily: persianFont),
            bodyLarge: t.bodyLarge?.copyWith(fontFamily: persianFont),
            bodyMedium: t.bodyMedium?.copyWith(fontFamily: persianFont),
            bodySmall: t.bodySmall?.copyWith(fontFamily: persianFont),
            labelLarge: t.labelLarge?.copyWith(fontFamily: persianFont),
            labelMedium: t.labelMedium?.copyWith(fontFamily: persianFont),
            labelSmall: t.labelSmall?.copyWith(fontFamily: persianFont),
          )
        : t;

    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.dark,
        surface: const Color(0xFF1A1A2E),
        onSurface: const Color(0xFFE0E0E0),
      ),
      scaffoldBackgroundColor: const Color(0xFF0F0F1A),
      textTheme: applyFont(base.textTheme.copyWith(
        titleLarge: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Color(0xFFE0E0E0),
        ),
        titleMedium: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFFE0E0E0),
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          color: Color(0xFFB0B0C0),
        ),
      )),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E30),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: seed,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: TextStyle(
            inherit: false,
            fontFamily: isRtl ? persianFont : 'IranSans',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black,
            decoration: TextDecoration.none,
            decorationColor: const Color(0xFFE6E0E9),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: seed,
          side: const BorderSide(color: Color(0xFF54C5F8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: TextStyle(
            inherit: false,
            fontFamily: isRtl ? persianFont : 'IranSans',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: const Color(0xFF54C5F8),
            decoration: TextDecoration.none,
            decorationColor: const Color(0xFFE6E0E9),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF2A2A40),
        selectedColor: seed.withValues(alpha: 0.25),
        labelStyle: TextStyle(
          inherit: false,
          fontSize: 13,
          fontFamily: isRtl ? persianFont : 'IranSans',
          color: const Color(0xFFE0E0E0),
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.none,
          decorationColor: const Color(0xFFE6E0E9),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2A2A40),
        thickness: 1,
      ),
    );
  }
}
