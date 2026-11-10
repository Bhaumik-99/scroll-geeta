import 'package:flutter/material.dart';
import 'package:scrollgeets/data/mock_data.dart';
import 'package:scrollgeets/shared/models/models.dart';
import 'package:scrollgeets/shared/widgets/shared_widgets.dart';
import 'package:scrollgeets/shared/widgets/audio_player_sheet.dart';
import 'package:scrollgeets/theme/app_typography.dart';
import 'package:scrollgeets/core/services/bookmark_service.dart';

/// Elegant reading and study page for a single shloka.
class VerseDetailScreen extends StatefulWidget {
  final Shloka shloka;
  final BookmarkService bookmarkService;
  final void Function(Shloka shloka)? onOpenStudyAssistant;
  final void Function(Shloka shloka)? onOpenRelatedVerse;

  const VerseDetailScreen({
    super.key,
    required this.shloka,
    required this.bookmarkService,
    this.onOpenStudyAssistant,
    this.onOpenRelatedVerse,
  });

  @override
  State<VerseDetailScreen> createState() => _VerseDetailScreenState();
}

class _VerseDetailScreenState extends State<VerseDetailScreen> {
  bool _wordMeaningsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shloka = widget.shloka;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──
            _buildTopBar(context, theme),
            // ── Content ──
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // Verse heading
                    Center(
                      child: Text(
                        'CHAPTER ${shloka.chapter} · VERSE ${shloka.verse}',
                        style: AppTypography.label(theme.colorScheme.primary),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Chapter context
                    Center(
                      child: Text(
                        _chapterTitle(shloka.chapter),
                        style: AppTypography.bodySmall(
                          theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // ── Sanskrit text ──
                    _SectionLabel(label: 'SANSKRIT'),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        shloka.sanskritText,
                        style: AppTypography.sanskritVerse(
                          theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const OrnamentalDivider(),
                    // ── Transliteration ──
                    _SectionLabel(label: 'TRANSLITERATION'),
                    const SizedBox(height: 10),
                    Text(
                      shloka.transliteration,
                      style: AppTypography.transliteration(
                        theme.colorScheme.onSurface.withValues(alpha: 0.65),
                      ),
                    ),
                    const SizedBox(height: 28),
                    // ── Translation ──
                    _SectionLabel(label: 'TRANSLATION'),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shloka.englishTranslation,
                            style: AppTypography.translationBody(
                              theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Hindi translation
                          Text(
                            shloka.hindiTranslation,
                            style: AppTypography.body(
                              theme.colorScheme.onSurface.withValues(alpha: 0.75),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            shloka.translationAttribution,
                            style: AppTypography.bodySmall(
                              theme.colorScheme.onSurface.withValues(alpha: 0.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    // ── Word-by-word meaning ──
                    if (shloka.wordMeanings.isNotEmpty) ...[
                      GestureDetector(
                        onTap: () => setState(
                          () => _wordMeaningsExpanded = !_wordMeaningsExpanded,
                        ),
                        child: Row(
                          children: [
                            _SectionLabel(label: 'WORD-BY-WORD'),
                            const Spacer(),
                            AnimatedRotation(
                              turns: _wordMeaningsExpanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                Icons.expand_more_rounded,
                                size: 22,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedCrossFade(
                        firstChild: const SizedBox.shrink(),
                        secondChild: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: _buildWordMeanings(theme, shloka),
                        ),
                        crossFadeState: _wordMeaningsExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 250),
                      ),
                      const SizedBox(height: 28),
                    ],
                    // ── Explanation ──
                    _SectionLabel(label: 'EXPLANATION'),
                    const SizedBox(height: 12),
                    Text(
                      shloka.explanation,
                      style: AppTypography.body(
                        theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 28),
                    // ── Context ──
                    _SectionLabel(label: 'CONTEXT'),
                    const SizedBox(height: 12),
                    Text(
                      shloka.context,
                      style: AppTypography.body(
                        theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // ── Study assistant button ──
                    _buildStudyButton(theme),
                    const SizedBox(height: 32),
                    // ── Related verses ──
                    if (shloka.relatedVerseIds.isNotEmpty) ...[
                      _SectionLabel(label: 'RELATED VERSES'),
                      const SizedBox(height: 12),
                      _buildRelatedVerses(theme, shloka),
                    ],
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Back',
          ),
          const Spacer(),
          ListenableBuilder(
            listenable: widget.bookmarkService,
            builder: (context, _) {
              return BookmarkButton(
                isBookmarked:
                    widget.bookmarkService.isBookmarked(widget.shloka.id),
                onToggle: () =>
                    widget.bookmarkService.toggle(widget.shloka.id),
              );
            },
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.volume_up_outlined, size: 22),
            onPressed: () => showVerseAudioPlayer(context, widget.shloka),
            tooltip: 'Listen to chanting',
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.ios_share_rounded, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share — coming soon'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: 'Share',
          ),
        ],
      ),
    );
  }

  Widget _buildWordMeanings(ThemeData theme, Shloka shloka) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: shloka.wordMeanings.asMap().entries.map((entry) {
          final wm = entry.value;
          final isLast = entry.key == shloka.wordMeanings.length - 1;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    wm.sanskrit,
                    style: AppTypography.sanskritVerseCompact(
                      theme.colorScheme.onSurface,
                    ).copyWith(fontSize: 15),
                  ),
                ),
                Expanded(
                  child: Text(
                    wm.meaning,
                    style: AppTypography.body(
                      theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStudyButton(ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => widget.onOpenStudyAssistant?.call(widget.shloka),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.psychology_outlined,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ask about this shloka',
                      style: AppTypography.button(theme.colorScheme.primary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Explore deeper meaning with the AI study assistant',
                      style: AppTypography.bodySmall(
                        theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRelatedVerses(ThemeData theme, Shloka shloka) {
    final related = shloka.relatedVerseIds
        .map((id) => MockData.findShloka(id))
        .whereType<Shloka>()
        .toList();

    if (related.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: related.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final r = related[index];
          return GestureDetector(
            onTap: () => widget.onOpenRelatedVerse?.call(r),
            child: Container(
              width: 220,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outline,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chapter ${r.chapter} · Verse ${r.verse}',
                    style: AppTypography.verseId(theme.colorScheme.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    r.sanskritText.replaceAll('\n', ' '),
                    style: AppTypography.sanskritVerseCompact(
                      theme.colorScheme.onSurface,
                    ).copyWith(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    r.englishTranslation,
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _chapterTitle(int chapter) {
    try {
      return MockData.chapters
          .firstWhere((c) => c.number == chapter)
          .titleEnglish;
    } catch (_) {
      return '';
    }
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTypography.label(
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
      ),
    );
  }
}
