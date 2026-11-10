import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollgeets/core/services/bookmark_service.dart';
import 'package:scrollgeets/data/mock_data.dart';
import 'package:scrollgeets/shared/models/models.dart';
import 'package:scrollgeets/shared/widgets/audio_player_sheet.dart';
import 'package:scrollgeets/theme/app_colors.dart';
import 'package:scrollgeets/theme/app_typography.dart';

/// The primary reading experience — a full-screen, minimalist,
/// editorial shloka feed matching the reference reading layout.
class ScrollFeedScreen extends StatefulWidget {
  final BookmarkService bookmarkService;
  final VoidCallback? onNavigateToDetail;
  final void Function(Shloka shloka)? onOpenDetail;
  final void Function(Shloka shloka)? onOpenStudyAssistant;
  final void Function(int chapter)? onOpenChapter;
  final int? initialChapter;
  final String? initialVerseId;

  const ScrollFeedScreen({
    super.key,
    required this.bookmarkService,
    this.onNavigateToDetail,
    this.onOpenDetail,
    this.onOpenStudyAssistant,
    this.onOpenChapter,
    this.initialChapter,
    this.initialVerseId,
  });

  @override
  State<ScrollFeedScreen> createState() => _ScrollFeedScreenState();
}

class _ScrollFeedScreenState extends State<ScrollFeedScreen> {
  late final PageController _pageController;
  int _currentPage = 0;
  List<Shloka> get _shlokas => MockData.shlokas;
  bool _isAnimatingWheel = false;

  // Local interaction states
  final Set<String> _likedVerseIds = {};
  String _selectedLanguage = 'EN'; // 'EN', 'HI', 'SAN'

  @override
  void initState() {
    super.initState();
    if (widget.initialVerseId != null) {
      final idx = _shlokas.indexWhere((s) => s.id == widget.initialVerseId);
      if (idx >= 0) _currentPage = idx;
    } else if (widget.initialChapter != null) {
      final idx =
          _shlokas.indexWhere((s) => s.chapter == widget.initialChapter);
      if (idx >= 0) _currentPage = idx;
    }
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void didUpdateWidget(ScrollFeedScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialVerseId != null &&
        widget.initialVerseId != oldWidget.initialVerseId) {
      final idx = _shlokas.indexWhere((s) => s.id == widget.initialVerseId);
      if (idx >= 0 && idx != _currentPage) {
        _pageController.jumpToPage(idx);
        setState(() => _currentPage = idx);
      }
    } else if (widget.initialChapter != null &&
        widget.initialChapter != oldWidget.initialChapter) {
      final idx =
          _shlokas.indexWhere((s) => s.chapter == widget.initialChapter);
      if (idx >= 0 && idx != _currentPage) {
        _pageController.jumpToPage(idx);
        setState(() => _currentPage = idx);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handlePointerSignal(PointerSignalEvent pointerSignal) {
    if (pointerSignal is PointerScrollEvent) {
      if (_isAnimatingWheel) return;
      if (pointerSignal.scrollDelta.dy > 15) {
        if (_currentPage < _shlokas.length - 1) {
          _isAnimatingWheel = true;
          _pageController
              .nextPage(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
          )
              .then((_) {
            Future.delayed(const Duration(milliseconds: 100), () {
              if (mounted) _isAnimatingWheel = false;
            });
          });
        }
      } else if (pointerSignal.scrollDelta.dy < -15) {
        if (_currentPage > 0) {
          _isAnimatingWheel = true;
          _pageController
              .previousPage(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
          )
              .then((_) {
            Future.delayed(const Duration(milliseconds: 100), () {
              if (mounted) _isAnimatingWheel = false;
            });
          });
        }
      }
    }
  }

  void _pickRandomShloka() {
    HapticFeedback.mediumImpact();
    if (_shlokas.length <= 1) return;
    int nextIdx;
    do {
      nextIdx = Random().nextInt(_shlokas.length);
    } while (nextIdx == _currentPage && _shlokas.length > 1);

    _pageController.animateToPage(
      nextIdx,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  void _jumpToFavorite() {
    HapticFeedback.selectionClick();
    // Jump to the celebrated verse 2.47 or first bookmarked
    final targetId = widget.bookmarkService.bookmarkedIds.isNotEmpty
        ? widget.bookmarkService.bookmarkedIds.first
        : '2.47';
    final idx = _shlokas.indexWhere((s) => s.id == targetId);
    if (idx >= 0 && idx != _currentPage) {
      _pageController.animateToPage(
        idx,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _toggleLanguage() {
    HapticFeedback.selectionClick();
    setState(() {
      if (_selectedLanguage == 'EN') {
        _selectedLanguage = 'HI';
      } else if (_selectedLanguage == 'HI') {
        _selectedLanguage = 'SAN';
      } else {
        _selectedLanguage = 'EN';
      }
    });
  }

  void _toggleLike(String verseId) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_likedVerseIds.contains(verseId)) {
        _likedVerseIds.remove(verseId);
      } else {
        _likedVerseIds.add(verseId);
      }
    });
  }

  void _showChapterSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.85,
        expand: false,
        builder: (ctx, scrollController) => _ChapterSelectorSheet(
          scrollController: scrollController,
          onChapterSelected: (chapter) {
            Navigator.pop(ctx);
            final idx = _shlokas.indexWhere((s) => s.chapter == chapter);
            if (idx >= 0) {
              _pageController.animateToPage(
                idx,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Chapter $chapter verses are not yet in the sample dataset.',
                  ),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _shareVerse(Shloka shloka) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _SharePreviewSheet(shloka: shloka),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentShloka =
        _shlokas[_currentPage.clamp(0, _shlokas.length - 1)];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          bottom: false,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── LAYER 1: Full-Screen PageView (Centre Editorial Layout) ──
              Listener(
                onPointerSignal: _handlePointerSignal,
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemCount: _shlokas.length,
                  onPageChanged: (idx) {
                    setState(() => _currentPage = idx);
                    HapticFeedback.selectionClick();
                  },
                  itemBuilder: (context, index) {
                    final shloka = _shlokas[index];
                    return _EditorialVersePage(
                      key: ValueKey(shloka.id),
                      shloka: shloka,
                      selectedLanguage: _selectedLanguage,
                      onTap: () => widget.onOpenDetail?.call(shloka),
                    );
                  },
                ),
              ),

              // ── LAYER 2: Left Edge Vertical Reading Progress Indicator ──
              Positioned(
                left: 10,
                top: 0,
                bottom: 84, // Space to clear bottom navigation bar
                child: Center(
                  child: _VerticalReadingProgress(
                    currentIndex: _currentPage,
                    totalCount: _shlokas.length,
                    isDark: isDark,
                  ),
                ),
              ),

              // ── LAYER 3: Right Edge Vertically Stacked Action Buttons ──
              Positioned(
                right: 14,
                top: 0,
                bottom: 84, // Space to clear bottom navigation bar
                child: Center(
                  child: _RightEdgeActionStack(
                    isLiked: _likedVerseIds.contains(currentShloka.id),
                    onToggleLike: () => _toggleLike(currentShloka.id),
                    onOpenStudyAssistant: () {
                      widget.onOpenStudyAssistant?.call(currentShloka);
                    },
                    onShare: () => _shareVerse(currentShloka),
                    onListen: () =>
                        showVerseAudioPlayer(context, currentShloka),
                  ),
                ),
              ),

              // ── LAYER 4: Top Navigation Controls (Top-Left & Top-Right) ──
              Positioned(
                top: 8,
                left: 16,
                right: 16,
                child: _buildTopControls(theme, currentShloka, isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Top controls with compact pills and dropdowns.
  Widget _buildTopControls(
      ThemeData theme, Shloka currentShloka, bool isDark) {
    final borderColor = theme.colorScheme.outline.withValues(alpha: 0.55);
    final isBookmarked = widget.bookmarkService.isBookmarked(currentShloka.id);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // ── TOP-LEFT: Random/Favourite Pill + Scripture/Lang Selector ──
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
              // Pill: Random Shloka icon + Favourite shortcut
              Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Random / Daily shloka button
                    IconButton(
                      icon: Icon(
                        Icons.shuffle_rounded,
                        size: 16,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                      ),
                      onPressed: _pickRandomShloka,
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 28, minHeight: 28),
                      tooltip: 'Random Shloka',
                    ),
                    Container(
                      width: 1,
                      height: 14,
                      color: theme.colorScheme.outline.withValues(alpha: 0.4),
                    ),
                    // Star / favourite shortcut button
                    IconButton(
                      icon: Icon(
                        _likedVerseIds.contains(currentShloka.id)
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 17,
                        color: _likedVerseIds.contains(currentShloka.id)
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withValues(alpha: 0.75),
                      ),
                      onPressed: _jumpToFavorite,
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 28, minHeight: 28),
                      tooltip: 'Core / Starred Verse',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),

              // Scripture / Language selector pill
              GestureDetector(
                onTap: _toggleLanguage,
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Gita · $_selectedLanguage',
                        style: AppTypography.label(theme.colorScheme.onSurface)
                            .copyWith(
                          fontSize: 11,
                          letterSpacing: 0.3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 15,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

        // ── TOP-RIGHT: Circular Bookmark Button + Chapter/Verse Dropdown ──
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bookmark/Save in a circular outlined button
            ListenableBuilder(
              listenable: widget.bookmarkService,
              builder: (context, _) {
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    widget.bookmarkService.toggle(currentShloka.id);
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isBookmarked
                          ? theme.colorScheme.primary.withValues(alpha: 0.12)
                          : theme.colorScheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isBookmarked
                            ? theme.colorScheme.primary
                            : borderColor,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: isDark ? 0.2 : 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        isBookmarked
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        size: 18,
                        color: isBookmarked
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),

            // Compact chapter-and-verse dropdown button
            GestureDetector(
              onTap: _showChapterSelector,
              child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ch ${currentShloka.chapter}:${currentShloka.verse}',
                      style: AppTypography.verseId(theme.colorScheme.onSurface)
                          .copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// A thin, subtle vertical reading progress indicator along the left edge.
/// Current verse segment highlighted in black/high-contrast, remaining segments in very light grey.
class _VerticalReadingProgress extends StatelessWidget {
  final int currentIndex;
  final int totalCount;
  final bool isDark;

  const _VerticalReadingProgress({
    required this.currentIndex,
    required this.totalCount,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Current highlighted in black (or crisp off-white in dark mode)
    final activeColor =
        isDark ? const Color(0xFFF3EDE4) : const Color(0xFF27251F);
    // Remaining segments in very light grey
    final inactiveColor =
        isDark ? const Color(0xFF383530) : const Color(0xFFE5DFD4);

    return SizedBox(
      width: 3.0,
      height: 140,
      child: Column(
        children: List.generate(totalCount, (index) {
          final isActive = index == currentIndex;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 1.5),
              decoration: BoxDecoration(
                color: isActive ? activeColor : inactiveColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Vertically stacked action buttons positioned on the right edge:
/// 1. Favourite / Like
/// 2. Comment / AI Study Assistant
/// 3. Share
/// 4. Audio Chanting
class _RightEdgeActionStack extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onToggleLike;
  final VoidCallback onOpenStudyAssistant;
  final VoidCallback onShare;
  final VoidCallback onListen;

  const _RightEdgeActionStack({
    required this.isLiked,
    required this.onToggleLike,
    required this.onOpenStudyAssistant,
    required this.onShare,
    required this.onListen,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedIconColor =
        theme.colorScheme.onSurface.withValues(alpha: 0.65);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Favourite / Like button
        _OutlineActionButton(
          icon: isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: isLiked
              ? AppColors.lightMutedTerracotta
              : mutedIconColor,
          isActive: isLiked,
          tooltip: 'Favourite',
          onTap: onToggleLike,
        ),
        const SizedBox(height: 20),

        // 2. Comment / AI Study button
        _OutlineActionButton(
          icon: Icons.chat_bubble_outline_rounded,
          color: mutedIconColor,
          tooltip: 'Ask AI Study Guide',
          onTap: onOpenStudyAssistant,
        ),
        const SizedBox(height: 20),

        // 3. Share button
        _OutlineActionButton(
          icon: Icons.share_outlined,
          color: mutedIconColor,
          tooltip: 'Share Verse',
          onTap: onShare,
        ),
        const SizedBox(height: 20),

        // 4. Audio Recitation button
        _OutlineActionButton(
          icon: Icons.volume_up_outlined,
          color: mutedIconColor,
          tooltip: 'Listen to Chanting',
          onTap: onListen,
        ),
      ],
    );
  }
}

class _OutlineActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isActive;
  final String tooltip;
  final VoidCallback onTap;

  const _OutlineActionButton({
    required this.icon,
    required this.color,
    this.isActive = false,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(21),
          onTap: onTap,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive
                    ? color.withValues(alpha: 0.6)
                    : theme.colorScheme.outline.withValues(alpha: 0.45),
                width: 1,
              ),
              color: isActive
                  ? color.withValues(alpha: 0.12)
                  : theme.colorScheme.surface.withValues(alpha: isDark ? 0.3 : 0.6),
            ),
            child: Center(
              child: Icon(
                icon,
                color: color,
                size: 21,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The centered editorial layout with generous whitespace and refined typography.
class _EditorialVersePage extends StatelessWidget {
  final Shloka shloka;
  final String selectedLanguage;
  final VoidCallback? onTap;

  const _EditorialVersePage({
    super.key,
    required this.shloka,
    required this.selectedLanguage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      // Precise clearance:
      // left: 34 (clears left vertical progress indicator)
      // right: 68 (clears right stacked actions)
      // top: 64 (clears top bar)
      // bottom: 92 (clears floating bottom navigation bar)
      padding: const EdgeInsets.fromLTRB(34, 64, 68, 92),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 102,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Sanskrit Verse — Large, elegant Devanagari typography
                Text(
                  shloka.sanskritText,
                  style: AppTypography.sanskritVerse(
                    theme.colorScheme.onSurface,
                  ).copyWith(
                    fontSize: 24,
                    height: 1.65,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),

                // Subtle restrained divider
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 24,
                      height: 1,
                      color: theme.colorScheme.outline.withValues(alpha: 0.5),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '✦',
                        style: TextStyle(
                          fontSize: 9,
                          color:
                              theme.colorScheme.outline.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 1,
                      color: theme.colorScheme.outline.withValues(alpha: 0.5),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Transliteration — Refined italic serif
                Text(
                  shloka.transliteration,
                  style: AppTypography.transliteration(
                    theme.colorScheme.onSurface.withValues(alpha: 0.65),
                  ).copyWith(
                    fontSize: 14,
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 22),

                // Translation — Generous editorial serif body
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            theme.colorScheme.outline.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          selectedLanguage == 'HI'
                              ? shloka.hindiTranslation
                              : shloka.englishTranslation,
                          style: AppTypography.translationBody(
                            theme.colorScheme.onSurface,
                          ).copyWith(
                            fontSize: 16.5,
                            height: 1.65,
                            letterSpacing: 0.1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Verse reference underneath in muted grey
                Text(
                  'Bhagavad Gita · Chapter ${shloka.chapter}, Verse ${shloka.verse}',
                  style: AppTypography.label(
                    theme.colorScheme.onSurface.withValues(alpha: 0.45),
                  ).copyWith(
                    fontSize: 12,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Chapter selector bottom sheet.
class _ChapterSelectorSheet extends StatelessWidget {
  final ScrollController scrollController;
  final void Function(int chapter) onChapterSelected;

  const _ChapterSelectorSheet({
    required this.scrollController,
    required this.onChapterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 32,
          height: 4,
          decoration: BoxDecoration(
            color: theme.colorScheme.outline,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        Text('Select Chapter', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: MockData.chapters.length,
            itemBuilder: (context, index) {
              final ch = MockData.chapters[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => onChapterSelected(ch.number),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.colorScheme.outline,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                '${ch.number}',
                                style: AppTypography.button(
                                  theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ch.titleEnglish,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${ch.verseCount} verses · ${ch.titleHindi}',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: theme.colorScheme.outline,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Share preview bottom sheet.
class _SharePreviewSheet extends StatelessWidget {
  final Shloka shloka;

  const _SharePreviewSheet({required this.shloka});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text('Share Verse', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 20),
          // Share preview card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Bhagavad Gita ${shloka.chapterVerse}',
                  style: AppTypography.label(theme.colorScheme.primary),
                ),
                const SizedBox(height: 16),
                Text(
                  shloka.sanskritText,
                  style: AppTypography.sanskritVerseCompact(
                    theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  shloka.englishTranslation,
                  style: AppTypography.bodySmall(
                    theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  '— Scroll the Geeta',
                  style: AppTypography.bodySmall(
                    theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ShareOption(icon: Icons.copy_rounded, label: 'Copy'),
              _ShareOption(icon: Icons.image_outlined, label: 'Image'),
              _ShareOption(icon: Icons.share_rounded, label: 'Share'),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ShareOption({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label — coming soon'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: theme.colorScheme.onSurface, size: 22),
          ),
          const SizedBox(height: 6),
          Text(label, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
