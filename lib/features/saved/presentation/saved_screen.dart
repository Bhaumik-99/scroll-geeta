import 'package:flutter/material.dart';
import 'package:scrollgeets/data/mock_data.dart';
import 'package:scrollgeets/shared/models/models.dart';
import 'package:scrollgeets/shared/widgets/shared_widgets.dart';
import 'package:scrollgeets/theme/app_typography.dart';
import 'package:scrollgeets/core/services/bookmark_service.dart';

/// Premium saved-verses library with search and filtering.
class SavedScreen extends StatefulWidget {
  final BookmarkService bookmarkService;
  final void Function(Shloka shloka)? onOpenDetail;
  final VoidCallback? onNavigateToScroll;

  const SavedScreen({
    super.key,
    required this.bookmarkService,
    this.onOpenDetail,
    this.onNavigateToScroll,
  });

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  String _searchQuery = '';
  String? _selectedChapterFilter;

  List<Shloka> _getFilteredBookmarks() {
    final bookmarkedIds = widget.bookmarkService.bookmarkedIds;
    var shlokas = MockData.shlokas
        .where((s) => bookmarkedIds.contains(s.id))
        .toList();

    if (_searchQuery.isNotEmpty) {
      final lower = _searchQuery.toLowerCase();
      shlokas = shlokas.where((s) {
        return s.englishTranslation.toLowerCase().contains(lower) ||
            s.sanskritText.contains(_searchQuery) ||
            s.id.contains(lower);
      }).toList();
    }

    if (_selectedChapterFilter != null) {
      final ch = int.tryParse(_selectedChapterFilter!);
      if (ch != null) {
        shlokas = shlokas.where((s) => s.chapter == ch).toList();
      }
    }

    return shlokas;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.bookmarkService,
          builder: (context, _) {
            final bookmarks = _getFilteredBookmarks();
            final totalBookmarks = widget.bookmarkService.bookmarkedIds.length;

            return CustomScrollView(
              slivers: [
                // ── Header ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saved',
                          style: AppTypography.screenTitle(
                            theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          totalBookmarks == 0
                              ? 'Your personal collection'
                              : '$totalBookmarks verse${totalBookmarks != 1 ? 's' : ''} saved',
                          style: AppTypography.subtitle(
                            theme.colorScheme.onSurface.withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // ── Search and filter ──
                if (totalBookmarks > 0) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                      child: TextField(
                        onChanged: (v) => setState(() => _searchQuery = v),
                        style: theme.textTheme.bodyMedium,
                        decoration: const InputDecoration(
                          hintText: 'Search saved verses...',
                          prefixIcon: Icon(Icons.search_rounded, size: 20),
                        ),
                      ),
                    ),
                  ),
                  // Chapter filters
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            TopicChip(
                              label: 'All',
                              isSelected: _selectedChapterFilter == null,
                              onTap: () =>
                                  setState(() => _selectedChapterFilter = null),
                            ),
                            const SizedBox(width: 8),
                            ..._getChaptersWithBookmarks().map((ch) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: TopicChip(
                                  label: 'Ch. $ch',
                                  isSelected:
                                      _selectedChapterFilter == ch.toString(),
                                  onTap: () => setState(() =>
                                      _selectedChapterFilter = ch.toString()),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                // ── Bookmarks list or empty state ──
                if (totalBookmarks == 0)
                  SliverFillRemaining(
                    child: EmptyStateView(
                      icon: Icons.bookmark_outline_rounded,
                      title: 'No saved verses',
                      message:
                          'Bookmark your favourite shlokas while reading to build your personal collection.',
                      actionLabel: 'Start Reading',
                      onAction: widget.onNavigateToScroll,
                    ),
                  )
                else if (bookmarks.isEmpty)
                  SliverFillRemaining(
                    child: EmptyStateView(
                      icon: Icons.search_off_rounded,
                      title: 'No matches',
                      message: 'No saved verses match your search.',
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final shloka = bookmarks[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _SavedShlokaCard(
                              shloka: shloka,
                              bookmarkService: widget.bookmarkService,
                              onTap: () =>
                                  widget.onOpenDetail?.call(shloka),
                            ),
                          );
                        },
                        childCount: bookmarks.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<int> _getChaptersWithBookmarks() {
    final bookmarkedIds = widget.bookmarkService.bookmarkedIds;
    final chapters = MockData.shlokas
        .where((s) => bookmarkedIds.contains(s.id))
        .map((s) => s.chapter)
        .toSet()
        .toList();
    chapters.sort();
    return chapters;
  }
}

class _SavedShlokaCard extends StatelessWidget {
  final Shloka shloka;
  final BookmarkService bookmarkService;
  final VoidCallback? onTap;

  const _SavedShlokaCard({
    required this.shloka,
    required this.bookmarkService,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline,
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chapter ${shloka.chapter} · Verse ${shloka.verse}',
                      style: AppTypography.verseId(theme.colorScheme.primary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      shloka.sanskritText.replaceAll('\n', ' '),
                      style: AppTypography.sanskritVerseCompact(
                        theme.colorScheme.onSurface,
                      ).copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      shloka.englishTranslation,
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              BookmarkButton(
                isBookmarked: true,
                onToggle: () => bookmarkService.toggle(shloka.id),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
