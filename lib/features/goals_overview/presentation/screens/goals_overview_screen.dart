import 'package:flutter/material.dart';
import 'package:goal_keeper_app/core/theme/app_theme.dart';
import 'package:goal_keeper_app/core/widgets/feedback/state_handler.dart';
import 'package:goal_keeper_app/features/goals_overview/presentation/controllers/goals_overview_controller.dart';
import 'package:goal_keeper_app/features/goals_overview/presentation/widgets/goal_card.dart';

class GoalsOverviewScreen extends StatefulWidget {
  const GoalsOverviewScreen({super.key});

  @override
  State<GoalsOverviewScreen> createState() => _GoalsOverviewScreenState();
}

class _GoalsOverviewScreenState extends State<GoalsOverviewScreen> {
  late final GoalsOverviewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = throw UnimplementedError('Wire GoalsOverviewController in ServiceLocator');
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _controller
      ..removeListener(_rebuild)
      ..dispose();
    super.dispose();
  }

  static const List<(dynamic, String)> _tabs = [
    // (GoalTimeframe.daily, 'Daily'),
    // (GoalTimeframe.weekly, 'Weekly'),
    // (GoalTimeframe.monthly, 'Monthly'),
    // (GoalTimeframe.yearly, 'Yearly'),
    // (GoalTimeframe.life, 'Life'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TopBar(),
            _Header(controller: _controller, tabs: _tabs),
            Expanded(
              child: StateHandler<GoalsOverviewData>(
                state: _controller.state,
                onRetry: _controller.refresh,
                onLoaded: (data) => _GoalsList(data: data),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.surfaceVariant,
              child: Icon(Icons.person, color: AppColors.textSecondary, size: 18),
            ),
            const Spacer(),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: const Icon(Icons.add, color: AppColors.primary, size: 20),
            ),
          ],
        ),
      );
}

class _Header extends StatelessWidget {
  final GoalsOverviewController controller;
  final List<(dynamic, String)> tabs;
  const _Header({required this.controller, required this.tabs});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Text('Goals',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -1)),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: tabs.map((t) {
                final isActive = controller.activeTab == t.$1;
                return GestureDetector(
                  onTap: () => controller.switchTab(t.$1),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(
                      children: [
                        Text(
                          t.$2,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: isActive
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (isActive)
                          Container(
                            width: 20,
                            height: 3,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
        ],
      );
}

class _GoalsList extends StatelessWidget {
  final GoalsOverviewData data;
  const _GoalsList({required this.data});

  @override
  Widget build(BuildContext context) => ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: data.goals.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => GoalCard(goal: data.goals[i]),
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
          currentIndex: 0,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.track_changes_outlined),
                activeIcon: Icon(Icons.track_changes),
                label: 'Goals'),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_outlined),
                activeIcon: Icon(Icons.bar_chart),
                label: 'Stats'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'Settings'),
          ],
        ),
      );
}

