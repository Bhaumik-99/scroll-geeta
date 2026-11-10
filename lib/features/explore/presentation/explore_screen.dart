import 'package:flutter/material.dart';
import 'package:scrollgeets/data/mock_data.dart';
import 'package:scrollgeets/shared/models/models.dart';
import 'package:scrollgeets/shared/widgets/shared_widgets.dart';
import 'package:scrollgeets/theme/app_typography.dart';
import 'package:scrollgeets/core/services/bookmark_service.dart';

/// Refined discovery interface for exploring chapters, topics,
/// and the daily shloka.
class ExploreScreen extends StatefulWidget {
  final BookmarkService bookmarkService;
  final void Function(Shloka shloka)? onOpenDetail;
  final void Function(int chapter)? onOpenChapter;
  final void Function(String topicId)? onOpenTopic;

  const ExploreScreen({
    super.key,
    required this.bookmarkService,
    this.onOpenDetail,
    this.onOpenChapter,
    this.onOpenTopic,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();
  List<Shloka> _searchResults = [];
  final List<String> _recentSearches = ['karma', 'surrender', 'duty'];

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    final lower = query.toLowerCase();
    setState(() {
      _searchResults = MockData.shlokas.where((s) {
        return s.englishTranslation.toLowerCase().contains(lower) ||
            s.explanation.toLowerCase().contains(lower) ||
            s.topics.any((t) => t.contains(lower)) ||
            s.id.contains(lower) ||
            s.hindiTranslation.contains(query) ||
            s.sanskritText.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_showSearch) {
      return _buildSearchScreen(theme);
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explore',
                      style: AppTypography.screenTitle(
                        theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Discover the wisdom of the Bhagavad Gita',
                      style: AppTypography.subtitle(
                        theme.colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ── Search bar ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: GestureDetector(
                  onTap: () => setState(() => _showSearch = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: theme.colorScheme.outline,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                        Expanded(
                          child: Text(
                            'Search verses, chapters, topics...',
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.body(
                              theme.colorScheme.onSurface.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // ── Daily shloka ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Verse",
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Your daily wisdom',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    _DailyShlokaCard(
                      shloka: MockData.shlokas[0], // BG 2.47
                      bookmarkService: widget.bookmarkService,
                      onTap: () => widget.onOpenDetail?.call(MockData.shlokas[0]),
                    ),
                  ],
                ),
              ),
            ),
            // ── Chapters ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chapters',
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'All 18 chapters of the Bhagavad Gita',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final ch = MockData.chapters[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ChapterTile(
                        chapter: ch,
                        onTap: () => widget.onOpenChapter?.call(ch.number),
                      ),
                    );
                  },
                  childCount: MockData.chapters.length,
                ),
              ),
            ),
            // ── Topics ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Topics',
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Explore by theme',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: MockData.topics.map((topic) {
                        return TopicChip(
                          label: topic.nameEnglish,
                          onTap: () => widget.onOpenTopic?.call(topic.id),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchScreen(ThemeData theme) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: _performSearch,
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Search verses, chapters, topics...',
                        prefixIcon: const Icon(Icons.search_rounded, size: 20),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close_rounded, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  _performSearch('');
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showSearch = false;
                        _searchController.clear();
                        _searchResults = [];
                      });
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Results or suggestions
            Expanded(
              child: _searchController.text.isEmpty
                  ? _buildSearchSuggestions(theme)
                  : _searchResults.isEmpty
                      ? EmptyStateView(
                          icon: Icons.search_off_rounded,
                          title: 'No results',
                          message:
                              'Try a different search term or browse by topic.',
                        )
                      : _buildSearchResults(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSuggestions(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_recentSearches.isNotEmpty) ...[
            Text('Recent', style: theme.textTheme.labelMedium),
            const SizedBox(height: 12),
            ..._recentSearches.map((search) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.history_rounded,
                    size: 18,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  title: Text(search, style: theme.textTheme.bodyMedium),
                  onTap: () {
                    _searchController.text = search;
                    _performSearch(search);
                  },
                )),
          ],
          const SizedBox(height: 24),
          Text('Suggested Topics', style: theme.textTheme.labelMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: MockData.topics.take(6).map((topic) {
              return TopicChip(
                label: topic.nameEnglish,
                onTap: () {
                  _searchController.text = topic.nameEnglish.toLowerCase();
                  _performSearch(topic.nameEnglish.toLowerCase());
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final shloka = _searchResults[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => widget.onOpenDetail?.call(shloka),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.outline,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
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
                      ).copyWith(fontSize: 15),
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
            ),
          ),
        );
      },
    );
  }
}

/// Daily shloka featured card.
class _DailyShlokaCard extends StatelessWidget {
  final Shloka shloka;
  final BookmarkService bookmarkService;
  final VoidCallback? onTap;

  const _DailyShlokaCard({
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
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'CHAPTER ${shloka.chapter} · VERSE ${shloka.verse}',
                    style: AppTypography.label(theme.colorScheme.primary),
                  ),
                  const Spacer(),
                  ListenableBuilder(
                    listenable: bookmarkService,
                    builder: (context, _) {
                      return BookmarkButton(
                        isBookmarked: bookmarkService.isBookmarked(shloka.id),
                        onToggle: () => bookmarkService.toggle(shloka.id),
                        size: 20,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                shloka.sanskritText,
                style: AppTypography.sanskritVerseCompact(
                  theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                shloka.englishTranslation,
                style: AppTypography.body(
                  theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.auto_stories_outlined,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Read more',
                    style: AppTypography.bodySmall(theme.colorScheme.primary)
                        .copyWith(fontWeight: FontWeight.w600),
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

/// Chapter tile for the chapter list.
class _ChapterTile extends StatelessWidget {
  final GeetaChapter chapter;
  final VoidCallback? onTap;

  const _ChapterTile({
    required this.chapter,
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
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    '${chapter.number}',
                    style: AppTypography.button(theme.colorScheme.primary)
                        .copyWith(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapter.titleEnglish,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      chapter.titleHindi,
                      style: AppTypography.bodySmall(
                        theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${chapter.verseCount} verses',
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                        ),
                        if (chapter.readingProgress > 0) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: chapter.readingProgress,
                                minHeight: 3,
                                backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.3),
                                valueColor: AlwaysStoppedAnimation(
                                  theme.colorScheme.primary.withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.outline,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
