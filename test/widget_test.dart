import 'package:flutter_test/flutter_test.dart';
import 'package:scrollgeets/core/services/bookmark_service.dart';
import 'package:scrollgeets/core/services/preferences_service.dart';
import 'package:scrollgeets/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App smoke test - loads shell and navigation tabs',
      (WidgetTester tester) async {
    final bookmarkService = BookmarkService();
    final preferencesService = PreferencesService();
    await Future.wait([
      bookmarkService.init(),
      preferencesService.init(),
    ]);

    await tester.pumpWidget(
      ScrollTheGeetaApp(
        bookmarkService: bookmarkService,
        preferencesService: preferencesService,
      ),
    );
    await tester.pumpAndSettle();

    // Verify 4 main navigation items exist
    expect(find.text('Scroll'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Initial screen is Scroll (ScrollFeedScreen)
    expect(find.text('Gita · EN'), findsOneWidget);
  });

  testWidgets('Bottom navigation tab switching test',
      (WidgetTester tester) async {
    final bookmarkService = BookmarkService();
    final preferencesService = PreferencesService();
    await Future.wait([
      bookmarkService.init(),
      preferencesService.init(),
    ]);

    await tester.pumpWidget(
      ScrollTheGeetaApp(
        bookmarkService: bookmarkService,
        preferencesService: preferencesService,
      ),
    );
    await tester.pumpAndSettle();

    // 1. Tap Explore
    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    expect(find.text("Today's Verse"), findsOneWidget);

    // 2. Tap Saved
    await tester.tap(find.text('Saved'));
    await tester.pumpAndSettle();
    expect(find.text('No saved verses'), findsOneWidget);

    // 3. Tap Profile
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Reading Preferences'), findsOneWidget);

    // 4. Return to Scroll
    await tester.tap(find.text('Scroll'));
    await tester.pumpAndSettle();
    expect(find.text('Gita · EN'), findsOneWidget);
  });

  testWidgets('Bookmark badge updates dynamically on bookmark toggle',
      (WidgetTester tester) async {
    final bookmarkService = BookmarkService();
    final preferencesService = PreferencesService();
    await Future.wait([
      bookmarkService.init(),
      preferencesService.init(),
    ]);

    await tester.pumpWidget(
      ScrollTheGeetaApp(
        bookmarkService: bookmarkService,
        preferencesService: preferencesService,
      ),
    );
    await tester.pumpAndSettle();

    // Initially no badge on Saved tab
    expect(find.text('1'), findsNothing);

    // Toggle bookmark service directly
    await bookmarkService.toggle('2.47');
    await tester.pumpAndSettle();

    // Badge with count '1' appears on Saved
    expect(find.text('1'), findsOneWidget);

    // Remove bookmark
    await bookmarkService.toggle('2.47');
    await tester.pumpAndSettle();
    expect(find.text('1'), findsNothing);
  });
}
