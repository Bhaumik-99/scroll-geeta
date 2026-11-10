import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollgeets/core/services/bookmark_service.dart';
import 'package:scrollgeets/core/services/preferences_service.dart';
import 'package:scrollgeets/data/mock_data.dart';
import 'package:scrollgeets/features/explore/presentation/chapter_detail_screen.dart';
import 'package:scrollgeets/features/explore/presentation/explore_screen.dart';
import 'package:scrollgeets/features/profile/presentation/profile_screen.dart';
import 'package:scrollgeets/features/saved/presentation/saved_screen.dart';
import 'package:scrollgeets/features/scroll/presentation/scroll_feed_screen.dart';
import 'package:scrollgeets/features/study_assistant/presentation/study_assistant_screen.dart';
import 'package:scrollgeets/features/subscription/presentation/subscription_paywall_sheet.dart';
import 'package:scrollgeets/features/verse_detail/presentation/verse_detail_screen.dart';
import 'package:scrollgeets/shared/models/models.dart';
import 'package:scrollgeets/theme/app_theme.dart';
import 'package:scrollgeets/theme/app_typography.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set immersive edge-to-edge system overlays
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  final bookmarkService = BookmarkService();
  final preferencesService = PreferencesService();

  // Initialize persistent services and scripture dataset
  await Future.wait([
    bookmarkService.init(),
    preferencesService.init(),
    MockData.init(),
  ]);

  runApp(
    ScrollTheGeetaApp(
      bookmarkService: bookmarkService,
      preferencesService: preferencesService,
    ),
  );
}

/// The root application widget for Scroll the Geeta.
class ScrollTheGeetaApp extends StatelessWidget {
  final BookmarkService bookmarkService;
  final PreferencesService preferencesService;

  const ScrollTheGeetaApp({
    super.key,
    required this.bookmarkService,
    required this.preferencesService,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: preferencesService,
      builder: (context, _) {
        ThemeMode themeMode;
        switch (preferencesService.themeMode) {
          case 'light':
            themeMode = ThemeMode.light;
            break;
          case 'dark':
            themeMode = ThemeMode.dark;
            break;
          default:
            themeMode = ThemeMode.system;
            break;
        }

        return MaterialApp(
          title: 'Scroll the Geeta',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeMode,
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);
            if (kIsWeb && mediaQuery.size.width > 700) {
              const phoneWidth = 420.0;
              final phoneHeight = (mediaQuery.size.height * 0.94).clamp(700.0, 920.0);
              return Container(
                color: const Color(0xFF12110E),
                child: Center(
                  child: Container(
                    width: phoneWidth,
                    height: phoneHeight,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(44),
                      border: Border.all(
                        color: const Color(0xFF2C2A24),
                        width: 8,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.7),
                          blurRadius: 40,
                          spreadRadius: 8,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(36),
                      child: MediaQuery(
                        data: mediaQuery.copyWith(
                          size: Size(phoneWidth, phoneHeight),
                        ),
                        child: child ?? const SizedBox(),
                      ),
                    ),
                  ),
                ),
              );
            }
            return child ?? const SizedBox();
          },
          home: AppShell(
            bookmarkService: bookmarkService,
            preferencesService: preferencesService,
          ),
        );
      },
    );
  }
}

/// Main application shell hosting the 4 core tabs and floating navigation bar.
class AppShell extends StatefulWidget {
  final BookmarkService bookmarkService;
  final PreferencesService preferencesService;

  const AppShell({
    super.key,
    required this.bookmarkService,
    required this.preferencesService,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentTabIndex = 0;
  int? _feedTargetChapter;
  String? _feedTargetVerseId;

  // Deep navigation helpers
  void _openVerseDetail(Shloka shloka) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => VerseDetailScreen(
          shloka: shloka,
          bookmarkService: widget.bookmarkService,
          onOpenStudyAssistant: (s) => _openStudyAssistant(s),
          onOpenRelatedVerse: (s) => _openVerseDetail(s),
        ),
      ),
    );
  }

  void _openStudyAssistant(Shloka shloka) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => StudyAssistantScreen(shloka: shloka),
      ),
    );
  }

  void _openChapter(int chapterNumber) {
    final chapter = MockData.chapters.firstWhere(
      (c) => c.number == chapterNumber,
      orElse: () => MockData.chapters[0],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => ChapterDetailScreen(
          chapter: chapter,
          bookmarkService: widget.bookmarkService,
          onOpenDetail: (s) => _openVerseDetail(s),
          onStartReading: (chapNum) {
            Navigator.pop(ctx);
            setState(() {
              _feedTargetChapter = chapNum;
              _feedTargetVerseId = null;
              _currentTabIndex = 0; // Switch to Feed tab
            });
          },
        ),
      ),
    );
  }

  void _openSubscription() {
    showSubscriptionPaywall(context);
  }

  void _onTabSelected(int index) {
    if (_currentTabIndex != index) {
      HapticFeedback.selectionClick();
      setState(() => _currentTabIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBody: true, // Allows content to flow behind floating frosted nav bar
      body: IndexedStack(
        index: _currentTabIndex,
        children: [
          // Tab 0: Scroll Feed
          ScrollFeedScreen(
            bookmarkService: widget.bookmarkService,
            initialChapter: _feedTargetChapter,
            initialVerseId: _feedTargetVerseId,
            onOpenDetail: (shloka) => _openVerseDetail(shloka),
            onOpenStudyAssistant: (shloka) => _openStudyAssistant(shloka),
            onOpenChapter: (chapter) => _openChapter(chapter),
          ),

          // Tab 1: Explore & Discovery
          ExploreScreen(
            bookmarkService: widget.bookmarkService,
            onOpenDetail: (shloka) => _openVerseDetail(shloka),
            onOpenChapter: (chapter) => _openChapter(chapter),
            onOpenTopic: (topicId) {
              final shlokas = MockData.shlokasByTopic(topicId);
              if (shlokas.isNotEmpty) {
                _openVerseDetail(shlokas.first);
              }
            },
          ),

          // Tab 2: Saved / Bookmarked Library
          SavedScreen(
            bookmarkService: widget.bookmarkService,
            onOpenDetail: (shloka) => _openVerseDetail(shloka),
            onNavigateToScroll: () => setState(() => _currentTabIndex = 0),
          ),

          // Tab 3: Profile & Settings
          ProfileScreen(
            preferencesService: widget.preferencesService,
            onOpenSubscription: _openSubscription,
          ),
        ],
      ),
      bottomNavigationBar: _FloatingNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: _onTabSelected,
        bookmarkService: widget.bookmarkService,
        theme: theme,
      ),
    );
  }
}

/// A floating glassmorphic pill bottom navigation bar.
class _FloatingNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final BookmarkService bookmarkService;
  final ThemeData theme;

  const _FloatingNavigationBar({
    required this.currentIndex,
    required this.onTap,
    required this.bookmarkService,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF22201D).withValues(alpha: 0.85)
                  : const Color(0xFFFFFDF8).withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : theme.colorScheme.primary.withValues(alpha: 0.15),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavBarItem(
                  icon: Icons.auto_stories_outlined,
                  activeIcon: Icons.auto_stories_rounded,
                  label: 'Scroll',
                  isSelected: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
                _NavBarItem(
                  icon: Icons.explore_outlined,
                  activeIcon: Icons.explore_rounded,
                  label: 'Explore',
                  isSelected: currentIndex == 1,
                  onTap: () => onTap(1),
                ),
                ListenableBuilder(
                  listenable: bookmarkService,
                  builder: (context, _) {
                    final count = bookmarkService.bookmarkedIds.length;
                    return _NavBarItem(
                      icon: Icons.bookmark_outline_rounded,
                      activeIcon: Icons.bookmark_rounded,
                      label: 'Saved',
                      isSelected: currentIndex == 2,
                      badgeCount: count,
                      onTap: () => onTap(2),
                    );
                  },
                ),
                _NavBarItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'Profile',
                  isSelected: currentIndex == 3,
                  onTap: () => onTap(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int? badgeCount;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final unselectedColor =
        theme.colorScheme.onSurface.withValues(alpha: 0.5);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedScale(
                    scale: isSelected ? 1.15 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    child: Icon(
                      isSelected ? activeIcon : icon,
                      size: 24,
                      color: isSelected ? primaryColor : unselectedColor,
                    ),
                  ),
                  if (badgeCount != null && badgeCount! > 0)
                    Positioned(
                      top: -4,
                      right: -8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Center(
                          child: Text(
                            '$badgeCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTypography.label(
                  isSelected ? primaryColor : unselectedColor,
                ).copyWith(
                  fontSize: 10,
                  letterSpacing: 0.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
