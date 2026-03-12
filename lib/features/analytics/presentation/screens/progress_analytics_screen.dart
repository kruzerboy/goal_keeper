import 'package:flutter/material.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/feedback/state_handler.dart';
import '../controllers/analytics_controller.dart';
import '../../domain/entities/analytics_data.dart';
import '../widgets/analytics_line_chart.dart';

class ProgressAnalyticsScreen extends StatefulWidget {
  const ProgressAnalyticsScreen({super.key});

  @override
  State<ProgressAnalyticsScreen> createState() =>
      _ProgressAnalyticsScreenState();
}

class _ProgressAnalyticsScreenState extends State<ProgressAnalyticsScreen> {
  late final AnalyticsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ServiceLocator.instance.analyticsController()
      ..addListener(_rebuild)
      ..load();
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _controller
      ..removeListener(_rebuild)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              _TopBar(),
              _RangeSelector(
                  selected: _controller.range,
                  onSelect: _controller.switchRange),
              Expanded(
                child: StateHandler<AnalyticsData>(
                  state: _controller.state,
                  onRetry: _controller.refresh,
                  onLoaded: (data) => _AnalyticsBody(data: data),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _BottomNav(),
      );
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back_ios_new,
                  size: 18, color: AppColors.textPrimary),
            ),
            const Expanded(
              child: Text('Progress Analytics',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
            ),
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.surfaceVariant,
              child: Icon(Icons.person, size: 16, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
}

class _RangeSelector extends StatelessWidget {
  final AnalyticsRange selected;
  final ValueChanged<AnalyticsRange> onSelect;
  const _RangeSelector({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: AnalyticsRange.values.map((r) {
            final isSelected = selected == r;
            final label = switch (r) {
              AnalyticsRange.week => 'Week',
              AnalyticsRange.month => 'Month',
              AnalyticsRange.year => 'Year',
            };
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelect(r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.surface : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
}

class _AnalyticsBody extends StatelessWidget {
  final AnalyticsData data;
  const _AnalyticsBody({required this.data});

  static const _weekLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CompletionCard(data: data),
            const SizedBox(height: 16),
            _StatsRow(data: data),
            const SizedBox(height: 20),
            _BadgesSection(badges: data.badges),
            const SizedBox(height: 16),
            _InsightCard(text: data.quickInsight),
          ],
        ),
      );
}

class _CompletionCard extends StatelessWidget {
  final AnalyticsData data;
  const _CompletionCard({required this.data});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Goal Completion', style: AppTypography.bodySmall),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${(data.completionRate * 100).toInt()}%',
                  style: AppTypography.displayLarge,
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_upward,
                          size: 12, color: AppColors.accent),
                      Text(
                        '+${(data.completionDelta * 100).toInt()}%',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accent),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('Activity over the last 7 days',
                style: AppTypography.bodySmall),
            const SizedBox(height: 16),
            AnalyticsLineChart(
              points: data.chartPoints,
              labels: const ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
            ),
          ],
        ),
      );
}

class _StatsRow extends StatelessWidget {
  final AnalyticsData data;
  const _StatsRow({required this.data});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: _StatCard(
              label: 'Goals Completed',
              value: '${data.goalsCompleted}',
              delta: '+${data.completedDelta}%',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              label: 'Current Streak',
              value: '${data.streakDays}\nDays',
              badge: data.isNewPR ? 'New PR' : null,
            ),
          ),
        ],
      );
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? delta;
  final String? badge;
  const _StatCard(
      {required this.label,
      required this.value,
      this.delta,
      this.badge});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.bodySmall),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTypography.headlineLarge
                      .copyWith(height: 1.2),
                ),
                if (delta != null) ...[
                  const SizedBox(width: 6),
                  Text(delta!,
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600)),
                ],
                if (badge != null) ...[
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(badge!,
                        style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ],
            ),
          ],
        ),
      );
}

class _BadgesSection extends StatelessWidget {
  final List<AnalyticsBadge> badges;
  const _BadgesSection({required this.badges});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Achievement Badges', style: AppTypography.headlineMedium),
              TextButton(
                  onPressed: () {},
                  child: const Text('View all',
                      style: TextStyle(color: AppColors.primary))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: badges
                .map((b) => Expanded(child: _BadgeTile(badge: b)))
                .toList(),
          ),
        ],
      );
}

class _BadgeTile extends StatelessWidget {
  final AnalyticsBadge badge;
  const _BadgeTile({required this.badge});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: badge.color.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: badge.color.withOpacity(0.3)),
            ),
            child: Center(
              child: Text(badge.emoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(height: 6),
          Text(badge.name,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall
                  .copyWith(fontSize: 10, color: AppColors.textPrimary)),
        ],
      );
}

class _InsightCard extends StatelessWidget {
  final String text;
  const _InsightCard({required this.text});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lightbulb_outline,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quick Insight', style: AppTypography.titleMedium),
                  const SizedBox(height: 4),
                  Text(text, style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          currentIndex: 1,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.show_chart), label: 'Analytics'),
            BottomNavigationBarItem(
                icon: Icon(Icons.track_changes_outlined), label: 'Goals'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined), label: 'Settings'),
          ],
        ),
      );
}