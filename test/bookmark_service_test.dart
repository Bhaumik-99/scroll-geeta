import 'package:flutter_test/flutter_test.dart';
import 'package:scrollgeets/core/services/bookmark_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BookmarkService Tests', () {
    late BookmarkService service;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      service = BookmarkService();
    });

    test('Initial state is empty and uninitialized', () {
      expect(service.bookmarkedIds, isEmpty);
      expect(service.isInitialized, isFalse);
    });

    test('Initializes correctly with stored bookmarks', () async {
      SharedPreferences.setMockInitialValues({
        'bookmarked_verse_ids': ['2.47', '18.66'],
      });

      await service.init();

      expect(service.isInitialized, isTrue);
      expect(service.bookmarkedIds, containsAll(['2.47', '18.66']));
      expect(service.isBookmarked('2.47'), isTrue);
      expect(service.isBookmarked('18.66'), isTrue);
      expect(service.isBookmarked('2.14'), isFalse);
    });

    test('Toggle adds bookmark and notifies listeners', () async {
      await service.init();

      var notified = false;
      service.addListener(() => notified = true);

      await service.toggle('2.47');

      expect(notified, isTrue);
      expect(service.isBookmarked('2.47'), isTrue);
      expect(service.bookmarkedIds, contains('2.47'));

      // Verify persistence in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getStringList('bookmarked_verse_ids'), contains('2.47'));
    });

    test('Toggle removes bookmark when already bookmarked', () async {
      SharedPreferences.setMockInitialValues({
        'bookmarked_verse_ids': ['2.47'],
      });
      await service.init();
      expect(service.isBookmarked('2.47'), isTrue);

      var notified = false;
      service.addListener(() => notified = true);

      await service.toggle('2.47');

      expect(notified, isTrue);
      expect(service.isBookmarked('2.47'), isFalse);
      expect(service.bookmarkedIds, isNot(contains('2.47')));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getStringList('bookmarked_verse_ids'), isEmpty);
    });

    test('bookmarkedIds is unmodifiable', () async {
      await service.init();
      expect(
        () => service.bookmarkedIds.add('test'),
        throwsUnsupportedError,
      );
    });
  });
}
