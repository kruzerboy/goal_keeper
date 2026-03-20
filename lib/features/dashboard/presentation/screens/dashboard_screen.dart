import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_keeper_app/core/di/service_locator.dart';
import 'package:goal_keeper_app/core/router/app_router.dart';
import 'package:goal_keeper_app/core/theme/app_theme.dart';
import 'package:goal_keeper_app/core/widgets/feedback/state_handler.dart';
import 'package:goal_keeper_app/features/dashboard/presentation/widgets/goal_score_ring.dart';
import 'package:goal_keeper_app/features/dashboard/presentation/widgets/goal_item_widget.dart';
import 'package:goal_keeper_app/features/dashboard/presentation/controllers/dashboard_controller.dart';

/// DashboardScreen is intentionally thin:
/// - Describes how to render [DashboardData]
/// - Calls controller methods on interaction
/// - Zero business logic, zero direct use case calls
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ServiceLocator.instance.dashboardController()
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(),
            Expanded(
              child: StateHandler<DashboardData>(
                state: _controller.state,
                onRetry: _controller.refresh,
                onLoaded: (data) => _Body(
                  data: data,
                  controller: _controller,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addGoal),
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// ─── Sub-widgets (purely presentational) ──────────────────────────────────

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: AppColors.surface,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.surfaceVariant,
              child: Icon(Icons.person, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Monday, June 12', style: AppTypography.bodySmall),
                Text('Good Morning, Alex',
                    style: AppTypography.headlineMedium),
              ],
            ),
            const Spacer(),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search, color: AppColors.textPrimary)),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.textPrimary)),
          ],
        ),
      );
}

class _Body extends StatelessWidget {
  final DashboardData data;
  final DashboardController controller;

  const _Body({required this.data, required this.controller});

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: controller.refresh,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(child: GoalScoreRing(percentage: data.goalScore)),
              const SizedBox(height: 20),
              _MilestoneTile(
                  completed: data.weeklyCompleted, total: data.weeklyTotal),
              const SizedBox(height: 24),
              _GoalsSection(data: data, controller: controller),
              const SizedBox(height: 20),
              _WisdomCard(quote: data.dailyWisdom),
              const SizedBox(height: 80),
            ],
          ),
        ),
      );
}

class _MilestoneTile extends StatelessWidget {
  final int completed;
  final int total;
  const _MilestoneTile({required this.completed, required this.total});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Weekly Milestone', style: AppTypography.titleLarge),
                Text('$completed / $total Tasks',
                    style: AppTypography.titleMedium
                        .copyWith(color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : completed / total,
                minHeight: 6,
                backgroundColor: const Color(0xFFE0E7FF),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 8),
            Text("You're on track to hit your weekly goal!",
                style: AppTypography.bodySmall),
          ],
        ),
      );
}

class _GoalsSection extends StatelessWidget {
  final DashboardData data;
  final DashboardController controller;
  const _GoalsSection({required this.data, required this.controller});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Today's Goals", style: AppTypography.headlineMedium),
              TextButton(
                onPressed: () => context.go(AppRoutes.goalsList),
                child: const Text('View all',
                    style: TextStyle(color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...data.todaysGoals.map(
            (goal) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GoalItemWidget(
                goal: goal,
                isPending: controller.isPendingToggle(goal.id),
                onToggle: () => controller.toggleGoal(goal.id),
              ),
            ),
          ),
        ],
      );
}

class _WisdomCard extends StatelessWidget {
  final String quote;
  const _WisdomCard({required this.quote});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('❝',
                style: AppTypography.displayMedium
                    .copyWith(color: Colors.white70, height: 1)),
            const SizedBox(height: 8),
            Text(quote,
                style: AppTypography.titleLarge
                    .copyWith(color: Colors.white, height: 1.5)),
            const SizedBox(height: 12),
            Text('— DAILY WISDOM',
                style: AppTypography.labelSmall
                    .copyWith(color: Colors.white70)),
          ],
        ),
      );
}

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.border))),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          currentIndex: 0,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_outlined),
                activeIcon: Icon(Icons.bar_chart_rounded),
                label: 'Trends'),
            BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                activeIcon: Icon(Icons.people_rounded),
                label: 'Social'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings_rounded),
                label: 'Settings'),
          ],
        ),
      );
}

