import 'package:flutter/material.dart';
import 'package:scrollgeets/theme/app_typography.dart';
import 'package:scrollgeets/core/services/preferences_service.dart';

/// Profile and preferences screen with settings and subscription entry.
class ProfileScreen extends StatelessWidget {
  final PreferencesService preferencesService;
  final VoidCallback? onOpenSubscription;

  const ProfileScreen({
    super.key,
    required this.preferencesService,
    this.onOpenSubscription,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: preferencesService,
          builder: (context, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile',
                    style: AppTypography.screenTitle(
                      theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // ── Guest state ──
                  _buildGuestHeader(theme),
                  const SizedBox(height: 28),
                  // ── Subscription ──
                  _buildSubscriptionCard(theme),
                  const SizedBox(height: 28),
                  // ── Reading preferences ──
                  _SectionTitle(title: 'Reading Preferences'),
                  const SizedBox(height: 12),
                  _PreferenceTile(
                    icon: Icons.translate_rounded,
                    title: 'Preferred Language',
                    subtitle: preferencesService.preferredLanguage == 'hindi'
                        ? 'Hindi'
                        : 'English',
                    onTap: () => _showLanguagePicker(context),
                  ),
                  _PreferenceTile(
                    icon: Icons.text_fields_rounded,
                    title: 'Show Sanskrit Text',
                    subtitle: preferencesService.showSanskrit
                        ? 'Visible'
                        : 'Hidden',
                    trailing: Switch.adaptive(
                      value: preferencesService.showSanskrit,
                      onChanged: (v) => preferencesService.setShowSanskrit(v),
                      activeThumbColor: theme.colorScheme.primary,
                    ),
                  ),
                  _PreferenceTile(
                    icon: Icons.abc_rounded,
                    title: 'Show Transliteration',
                    subtitle: preferencesService.showTransliteration
                        ? 'Visible'
                        : 'Hidden',
                    trailing: Switch.adaptive(
                      value: preferencesService.showTransliteration,
                      onChanged: (v) =>
                          preferencesService.setShowTransliteration(v),
                      activeThumbColor: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  // ── Appearance ──
                  _SectionTitle(title: 'Appearance'),
                  const SizedBox(height: 12),
                  _PreferenceTile(
                    icon: Icons.text_increase_rounded,
                    title: 'Font Size',
                    subtitle: _fontSizeLabel(preferencesService.fontSizeScale),
                    onTap: () => _showFontSizePicker(context),
                  ),
                  _PreferenceTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Theme',
                    subtitle: _themeLabel(preferencesService.themeMode),
                    onTap: () => _showThemePicker(context),
                  ),
                  const SizedBox(height: 28),
                  // ── General ──
                  _SectionTitle(title: 'General'),
                  const SizedBox(height: 12),
                  _PreferenceTile(
                    icon: Icons.notifications_outlined,
                    title: 'Daily Reminder',
                    subtitle: 'Not set',
                    onTap: () => _showComingSoon(context),
                  ),
                  _PreferenceTile(
                    icon: Icons.history_rounded,
                    title: 'Reading History',
                    subtitle: 'View your reading activity',
                    onTap: () => _showComingSoon(context),
                  ),
                  const SizedBox(height: 28),
                  // ── About ──
                  _SectionTitle(title: 'About'),
                  const SizedBox(height: 12),
                  _PreferenceTile(
                    icon: Icons.info_outline_rounded,
                    title: 'About Scroll the Geeta',
                    subtitle: 'Version 1.0.0',
                    onTap: () => _showAboutDialog(context, theme),
                  ),
                  _PreferenceTile(
                    icon: Icons.menu_book_outlined,
                    title: 'Sources & Attribution',
                    subtitle: 'Text sources and translations',
                    onTap: () => _showSourcesDialog(context, theme),
                  ),
                  _PreferenceTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'Review our privacy practices',
                    onTap: () => _showComingSoon(context),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGuestHeader(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: theme.colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Guest Reader',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Sign in to sync your progress',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              textStyle: AppTypography.bodySmall(theme.colorScheme.primary)
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onOpenSubscription,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary.withValues(alpha: 0.1),
                theme.colorScheme.secondary.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
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
                      'Upgrade to Premium',
                      style: AppTypography.button(theme.colorScheme.primary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ad-free reading & unlimited AI study',
                      style: theme.textTheme.bodySmall,
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

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _OptionSheet(
        title: 'Preferred Language',
        options: const ['English', 'Hindi'],
        selected: preferencesService.preferredLanguage == 'hindi' ? 'Hindi' : 'English',
        onSelect: (val) {
          preferencesService.setPreferredLanguage(val.toLowerCase());
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showThemePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _OptionSheet(
        title: 'Theme',
        options: const ['System', 'Light', 'Dark'],
        selected: _themeLabel(preferencesService.themeMode),
        onSelect: (val) {
          preferencesService.setThemeMode(val.toLowerCase());
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showFontSizePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _FontSizeSheet(
        currentScale: preferencesService.fontSizeScale,
        onChanged: (val) => preferencesService.setFontSizeScale(val),
      ),
    );
  }

  void _showAboutDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('About Scroll the Geeta'),
        content: const Text(
          'Scroll the Geeta is a premium Bhagavad Gita reading and study application.\n\n'
          'Version 1.0.0\n\n'
          'Designed with care for seekers of wisdom.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSourcesDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sources & Attribution'),
        content: const SingleChildScrollView(
          child: Text(
            'Sanskrit verses are from the traditional Bhagavad Gita text.\n\n'
            'Sample English translations are inspired by public-domain interpretations and adapted for clarity.\n\n'
            'Hindi translations are sample paraphrases for demonstration purposes.\n\n'
            'Typography: Outfit, Libre Baskerville, Noto Sans Devanagari (Google Fonts, OFL licence).',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _themeLabel(String mode) {
    switch (mode) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      default:
        return 'System';
    }
  }

  String _fontSizeLabel(double scale) {
    if (scale <= 0.85) return 'Small';
    if (scale <= 1.0) return 'Medium';
    if (scale <= 1.15) return 'Large';
    return 'Extra Large';
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.label(
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
      ),
    );
  }
}

class _PreferenceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _PreferenceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (trailing != null)
                trailing!
              else if (onTap != null)
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: theme.colorScheme.outline,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selected;
  final void Function(String) onSelect;

  const _OptionSheet({
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32, height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(title, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 20),
          ...options.map((opt) => ListTile(
                title: Text(opt),
                trailing: opt == selected
                    ? Icon(Icons.check_rounded, color: theme.colorScheme.primary)
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: () => onSelect(opt),
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _FontSizeSheet extends StatefulWidget {
  final double currentScale;
  final ValueChanged<double> onChanged;

  const _FontSizeSheet({
    required this.currentScale,
    required this.onChanged,
  });

  @override
  State<_FontSizeSheet> createState() => _FontSizeSheetState();
}

class _FontSizeSheetState extends State<_FontSizeSheet> {
  late double _scale;

  @override
  void initState() {
    super.initState();
    _scale = widget.currentScale;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32, height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text('Font Size', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 20),
          // Preview text
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'कर्मण्येवाधिकारस्ते',
              style: AppTypography.sanskritVerse(theme.colorScheme.onSurface)
                  .copyWith(fontSize: 26 * _scale),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text('A', style: TextStyle(fontSize: 14)),
              Expanded(
                child: Slider(
                  value: _scale,
                  min: 0.8,
                  max: 1.4,
                  divisions: 6,
                  onChanged: (val) {
                    setState(() => _scale = val);
                    widget.onChanged(val);
                  },
                ),
              ),
              const Text('A', style: TextStyle(fontSize: 22)),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
