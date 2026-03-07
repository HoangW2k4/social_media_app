import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/l10n/app_localizations.dart';
import 'package:social_media_app/providers/language_provider.dart';
import 'package:social_media_app/widgets/main_shell.dart';

Widget buildTestApp(LanguageProvider provider) {
  return ChangeNotifierProvider.value(
    value: provider,
    child: Consumer<LanguageProvider>(
      builder: (context, langProvider, _) {
        return MaterialApp(
          locale: langProvider.locale,
          supportedLocales: const [Locale('en'), Locale('vi')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const MainShell(),
        );
      },
    ),
  );
}

void main() {
  testWidgets('App starts in Vietnamese by default', (tester) async {
    final provider = LanguageProvider();
    await tester.pumpWidget(buildTestApp(provider));
    await tester.pumpAndSettle();

    // Default is Vietnamese - check bottom nav labels
    expect(find.text('Trang chủ'), findsOneWidget);
    expect(find.text('Bạn bè'), findsOneWidget);
    expect(find.text('Tin nhắn'), findsOneWidget);
    expect(find.text('Giới thiệu'), findsOneWidget);
  });

  testWidgets('Language switches from VI to EN', (tester) async {
    final provider = LanguageProvider();
    await tester.pumpWidget(buildTestApp(provider));
    await tester.pumpAndSettle();

    // Verify Vietnamese
    expect(find.text('Trang chủ'), findsOneWidget);

    // Toggle language
    provider.toggleLanguage();
    await tester.pumpAndSettle();

    // Verify English
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Friends'), findsOneWidget);
    expect(find.text('Messages'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
  });

  testWidgets('Language switches back from EN to VI', (tester) async {
    final provider = LanguageProvider();
    await tester.pumpWidget(buildTestApp(provider));
    await tester.pumpAndSettle();

    // Switch to EN
    provider.toggleLanguage();
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);

    // Switch back to VI
    provider.toggleLanguage();
    await tester.pumpAndSettle();
    expect(find.text('Trang chủ'), findsOneWidget);
    expect(find.text('Bạn bè'), findsOneWidget);
  });

  testWidgets('Language toggle button in AppBar works', (tester) async {
    final provider = LanguageProvider();
    await tester.pumpWidget(buildTestApp(provider));
    await tester.pumpAndSettle();

    // Find and tap the language toggle button (shows "VI" text)
    expect(find.text('VI'), findsOneWidget);
    await tester.tap(find.text('VI'));
    await tester.pumpAndSettle();

    // After tap, should show "EN"
    expect(find.text('EN'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });

  test('LanguageProvider toggles correctly', () {
    final provider = LanguageProvider();

    // Default is Vietnamese
    expect(provider.locale.languageCode, 'vi');
    expect(provider.isVietnamese, true);

    // Toggle to English
    provider.toggleLanguage();
    expect(provider.locale.languageCode, 'en');
    expect(provider.isVietnamese, false);

    // Toggle back to Vietnamese
    provider.toggleLanguage();
    expect(provider.locale.languageCode, 'vi');
    expect(provider.isVietnamese, true);
  });

  test('LanguageProvider setLocale works', () {
    final provider = LanguageProvider();

    provider.setLocale(const Locale('en'));
    expect(provider.locale.languageCode, 'en');

    provider.setLocale(const Locale('vi'));
    expect(provider.locale.languageCode, 'vi');

    // Invalid locale should be ignored
    provider.setLocale(const Locale('fr'));
    expect(provider.locale.languageCode, 'vi');
  });
}
