import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollgeets/shared/models/models.dart';
import 'package:scrollgeets/theme/app_typography.dart';

/// Opens the audio player sheet for a given verse.
Future<void> showVerseAudioPlayer(BuildContext context, Shloka shloka) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => AudioPlayerSheet(shloka: shloka),
  );
}

/// A sacred audio chanting and recitation player bottom sheet.
class AudioPlayerSheet extends StatefulWidget {
  final Shloka shloka;

  const AudioPlayerSheet({
    super.key,
    required this.shloka,
  });

  @override
  State<AudioPlayerSheet> createState() => _AudioPlayerSheetState();
}

class _AudioPlayerSheetState extends State<AudioPlayerSheet>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = true;
  double _position = 12.0;
  final double _duration = 38.0;
  bool _isLooping = true;
  double _playbackSpeed = 1.0;
  int _selectedVoiceIndex = 0;
  Timer? _timer;

  final List<String> _voices = [
    'Traditional Vedic Pandit',
    'Meditative Tanpura Chanting',
    'Slow Word-by-Word Study',
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (t) {
      if (!mounted) return;
      if (_isPlaying) {
        setState(() {
          _position += 0.5 * _playbackSpeed;
          if (_position >= _duration) {
            if (_isLooping) {
              _position = 0;
            } else {
              _isPlaying = false;
              _position = _duration;
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _togglePlayPause() {
    HapticFeedback.lightImpact();
    setState(() => _isPlaying = !_isPlaying);
  }

  void _seekBy(double seconds) {
    HapticFeedback.selectionClick();
    setState(() {
      _position = (_position + seconds).clamp(0.0, _duration);
    });
  }

  void _cycleSpeed() {
    HapticFeedback.selectionClick();
    setState(() {
      if (_playbackSpeed == 1.0) {
        _playbackSpeed = 1.25;
      } else if (_playbackSpeed == 1.25) {
        _playbackSpeed = 0.8;
      } else {
        _playbackSpeed = 1.0;
      }
    });
  }

  String _formatTime(double sec) {
    final m = sec.toInt() ~/ 60;
    final s = sec.toInt() % 60;
    return '${m.toString().padLeft(1, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag pill
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'VERSE ${widget.shloka.id} • RECITATION',
                      style: AppTypography.label(theme.colorScheme.primary),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Sanskrit Verse Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.6),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.shloka.sanskritText,
                      style: AppTypography.sanskritVerseCompact(
                        theme.colorScheme.onSurface,
                      ).copyWith(fontSize: 19, height: 1.6),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.shloka.transliteration,
                      style: AppTypography.transliteration(
                        theme.colorScheme.onSurface.withValues(alpha: 0.65),
                      ).copyWith(fontSize: 13),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Animated Waveform Visualizer
              _WaveformVisualizer(isPlaying: _isPlaying),
              const SizedBox(height: 16),

              // Progress slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                  activeTrackColor: theme.colorScheme.primary,
                  inactiveTrackColor: theme.colorScheme.surfaceContainerHighest,
                  thumbColor: theme.colorScheme.primary,
                ),
                child: Slider(
                  value: _position.clamp(0.0, _duration),
                  min: 0.0,
                  max: _duration,
                  onChanged: (val) {
                    setState(() => _position = val);
                  },
                ),
              ),

              // Timestamps
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatTime(_position),
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                    ),
                    Text(
                      _formatTime(_duration),
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Voice selector dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<int>(
                  value: _selectedVoiceIndex,
                  underline: const SizedBox.shrink(),
                  isDense: true,
                  icon: const Icon(Icons.arrow_drop_down_rounded),
                  items: List.generate(
                    _voices.length,
                    (idx) => DropdownMenuItem(
                      value: idx,
                      child: Text(
                        _voices[idx],
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedVoiceIndex = v);
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Main audio playback controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Loop button
                  IconButton(
                    icon: Icon(
                      Icons.repeat_rounded,
                      color: _isLooping
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                    ),
                    tooltip: 'Loop verse',
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      setState(() => _isLooping = !_isLooping);
                    },
                  ),

                  // -10s
                  IconButton(
                    icon: const Icon(Icons.replay_10_rounded, size: 28),
                    onPressed: () => _seekBy(-10),
                    tooltip: '-10s',
                  ),

                  // Big Play/Pause
                  GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ),

                  // +10s
                  IconButton(
                    icon: const Icon(Icons.forward_10_rounded, size: 28),
                    onPressed: () => _seekBy(10),
                    tooltip: '+10s',
                  ),

                  // Speed toggle
                  GestureDetector(
                    onTap: _cycleSpeed,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_playbackSpeed}x',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
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

class _WaveformVisualizer extends StatelessWidget {
  final bool isPlaying;

  const _WaveformVisualizer({required this.isPlaying});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final heights = [14.0, 24.0, 18.0, 32.0, 26.0, 36.0, 20.0, 28.0, 16.0, 30.0, 22.0, 14.0];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(heights.length, (idx) {
        final h = isPlaying ? heights[idx] : 8.0;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 250 + (idx * 40)),
            width: 3.5,
            height: h,
            decoration: BoxDecoration(
              color: idx % 2 == 0
                  ? theme.colorScheme.primary
                  : theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
