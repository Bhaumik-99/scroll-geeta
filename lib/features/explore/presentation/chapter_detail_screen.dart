import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollgeets/data/mock_data.dart';
import 'package:scrollgeets/shared/models/models.dart';
import 'package:scrollgeets/shared/widgets/shared_widgets.dart';
import 'package:scrollgeets/theme/app_typography.dart';
import 'package:scrollgeets/core/services/bookmark_service.dart';

/// Screen detailing a single chapter of the Bhagavad Gita and its verses.
class ChapterDetailScreen extends StatelessWidget {
  final GeetaChapter chapter;
  final BookmarkService bookmarkService;
  final void Function(Shloka shloka)? onOpenDetail;
  final void Function(int chapter)? onStartReading;

  const ChapterDetailScreen({
    super.key,
    required this.chapter,
    required this.bookmarkService,
    this.onOpenDetail,
    this.onStartReading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final verses = MockData.shlokasByChapter(chapter.number);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Chapter ${chapter.number}'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sharing Chapter ${chapter.number}: ${chapter.titleEnglish}'),
                ),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Chapter Hero Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.6),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'CHAPTER ${chapter.number} OF 18',
                        style: AppTypography.label(theme.colorScheme.primary),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Sanskrit Title
                    Text(
                      chapter.titleSanskrit,
                      style: AppTypography.sanskritVerse(
                        theme.colorScheme.onSurface,
                      ).copyWith(fontSize: 24, height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // English Title
                    Text(
                      chapter.titleEnglish,
                      style: AppTypography.screenTitle(
                        theme.colorScheme.onSurface,
                      ).copyWith(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),

                    // Hindi Title
                    Text(
                      chapter.titleHindi,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    const OrnamentalDivider(),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      chapter.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Progress & Verse count
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${chapter.verseCount} Verses',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: 16,
                          color: theme.colorScheme.secondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${(chapter.readingProgress * 100).toInt()}% completed',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Reading progress track
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: chapter.readingProgress > 0
                            ? chapter.readingProgress
                            : 0.05,
                        minHeight: 6,
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Start Reading CTA
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          if (onStartReading != null) {
                            onStartReading!(chapter.number);
                          } else {
                            Navigator.pop(context, chapter.number);
                          }
                        },
                        icon: const Icon(Icons.play_arrow_rounded, size: 22),
                        label: const Text('Read from Verse 1 in Feed'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Section title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Verses in this Chapter',
                    style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18),
                  ),
                  Text(
                    '${verses.length} available',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),

          // Verses list or empty state
          if (verses.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyStateView(
                icon: Icons.auto_stories_rounded,
                title: 'More Verses Coming Soon',
                message:
                    'Sample verses are currently loaded for Chapters 2, 3, 4, 6, 9, 11, 12, and 18.',
                actionLabel: 'Explore Chapter 2 Verses',
                onAction: () {
                  final ch2 = MockData.chapters.firstWhere((c) => c.number == 2);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => ChapterDetailScreen(
                        chapter: ch2,
                        bookmarkService: bookmarkService,
                        onOpenDetail: onOpenDetail,
                        onStartReading: onStartReading,
                      ),
                    ),
                  );
                },
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final shloka = verses[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _VerseTile(
                        shloka: shloka,
                        bookmarkService: bookmarkService,
                        onTap: () => onOpenDetail?.call(shloka),
                      ),
                    );
                  },
                  childCount: verses.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _VerseTile extends StatelessWidget {
  final Shloka shloka;
  final BookmarkService bookmarkService;
  final VoidCallback onTap;

  const _VerseTile({
    required this.shloka,
    required this.bookmarkService,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.6),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'VERSE ${shloka.id}',
                      style: AppTypography.label(theme.colorScheme.primary),
                    ),
                  ),
                  ListenableBuilder(
                    listenable: bookmarkService,
                    builder: (context, _) => BookmarkButton(
                      isBookmarked: bookmarkService.isBookmarked(shloka.id),
                      onToggle: () => bookmarkService.toggle(shloka.id),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Sanskrit text snippet
              Text(
                shloka.sanskritText,
                style: AppTypography.sanskritVerseCompact(
                  theme.colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // English translation
              Text(
                shloka.englishTranslation,
                style: theme.textTheme.bodySmall?.copyWith(
                  height: 1.5,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    spacing: 6,
                    children: shloka.topics.take(2).map((t) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '#$t',
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Row(
                    children: [
                      Text(
                        'Read verse',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 11,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
