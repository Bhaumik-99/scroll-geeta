import 'package:flutter_test/flutter_test.dart';
import 'package:scrollgeets/core/services/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PreferencesService Tests', () {
    late PreferencesService service;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      service = PreferencesService();
    });

    test('Default values before and after init', () async {
      expect(service.themeMode, 'system');
      expect(service.preferredLanguage, 'english');
      expect(service.showTransliteration, isTrue);
      expect(service.fontSizeScale, 1.0);
      expect(service.showSanskrit, isTrue);

      await service.init();

      expect(service.themeMode, 'system');
      expect(service.preferredLanguage, 'english');
      expect(service.showTransliteration, isTrue);
      expect(service.fontSizeScale, 1.0);
      expect(service.showSanskrit, isTrue);
    });

    test('Initializes with stored preferences', () async {
      SharedPreferences.setMockInitialValues({
        'theme_mode': 'dark',
        'preferred_language': 'hindi',
        'show_transliteration': false,
        'font_size_scale': 1.15,
        'show_sanskrit': false,
      });

      await service.init();

      expect(service.themeMode, 'dark');
      expect(service.preferredLanguage, 'hindi');
      expect(service.showTransliteration, isFalse);
      expect(service.fontSizeScale, 1.15);
      expect(service.showSanskrit, isFalse);
    });

    test('Updates theme mode and notifies listeners', () async {
      await service.init();
      var notified = false;
      service.addListener(() => notified = true);

      await service.setThemeMode('light');

      expect(notified, isTrue);
      expect(service.themeMode, 'light');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('theme_mode'), 'light');
    });

    test('Updates language and notifies listeners', () async {
      await service.init();
      var notified = false;
      service.addListener(() => notified = true);

      await service.setPreferredLanguage('hindi');

      expect(notified, isTrue);
      expect(service.preferredLanguage, 'hindi');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('preferred_language'), 'hindi');
    });

    test('Updates font size scale and notifies listeners', () async {
      await service.init();
      var notified = false;
      service.addListener(() => notified = true);

      await service.setFontSizeScale(1.3);

      expect(notified, isTrue);
      expect(service.fontSizeScale, 1.3);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getDouble('font_size_scale'), 1.3);
    });

    test('Updates Sanskrit text visibility', () async {
      await service.init();
      var notified = false;
      service.addListener(() => notified = true);

      await service.setShowSanskrit(false);

      expect(notified, isTrue);
      expect(service.showSanskrit, isFalse);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('show_sanskrit'), isFalse);
    });
  });
}
