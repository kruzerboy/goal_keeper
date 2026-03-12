import 'package:flutter/material.dart';
import 'package:goal_keeper_app/core/di/service_locator.dart';
import 'package:goal_keeper_app/core/theme/app_theme.dart';
import 'package:goal_keeper_app/features/settings/domain/entities/reminder_settings.dart';
import 'package:goal_keeper_app/features/settings/presentation/controllers/reminder_settings_controller.dart';

class ReminderSettingsScreen extends StatefulWidget {
  const ReminderSettingsScreen({super.key});

  @override
  State<ReminderSettingsScreen> createState() =>
      _ReminderSettingsScreenState();
}

class _ReminderSettingsScreenState extends State<ReminderSettingsScreen> {
  late final ReminderSettingsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ServiceLocator.instance.reminderSettingsController()
      ..addListener(_rebuild);
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
    final s = _controller.settings;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle('General Notifications'),
                    const SizedBox(height: 12),
                    _ToggleRow(
                      icon: Icons.bar_chart_outlined,
                      iconColor: const Color(0xFF3B82F6),
                      title: 'Weekly Reports',
                      subtitle: 'Summary of progress every Monday.',
                      value: s.weeklyReports,
                      onChanged: _controller.toggleWeeklyReports,
                    ),
                    const SizedBox(height: 10),
                    _ToggleRow(
                      icon: Icons.emoji_events_outlined,
                      iconColor: const Color(0xFFF59E0B),
                      title: 'Achievement Alerts',
                      subtitle: 'Notifications when you hit a milestone.',
                      value: s.achievementAlerts,
                      onChanged: _controller.toggleAchievementAlerts,
                    ),
                    const SizedBox(height: 24),
                    _SectionTitle('Daily Focus'),
                    const SizedBox(height: 12),
                    _ToggleRow(
                      icon: Icons.alarm_outlined,
                      iconColor: const Color(0xFF10B981),
                      title: 'Daily Reminders',
                      subtitle: 'Stay on track with a daily nudge.',
                      value: s.dailyReminders,
                      onChanged: _controller.toggleDailyReminders,
                    ),
                    const SizedBox(height: 20),
                    Text('Notification Time', style: AppTypography.titleMedium),
                    const SizedBox(height: 14),
                    _TimePicker(settings: s, controller: _controller),
                    const SizedBox(height: 24),
                    Text('Repeat Frequency', style: AppTypography.titleMedium),
                    const SizedBox(height: 12),
                    _FrequencySelector(
                      selected: s.frequency,
                      onSelect: _controller.setFrequency,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Text(
                        'Make sure system-level notifications are enabled for Goal Keeper in your device settings to receive these alerts.',
                        style: AppTypography.bodySmall.copyWith(height: 1.5),
                      ),
                    ),
                  ],
                ),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back_ios_new,
                  size: 18, color: AppColors.textPrimary),
            ),
            const Expanded(
              child: Text('Reminder Settings',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
            ),
            const SizedBox(width: 24),
          ],
        ),
      );
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) =>
      Text(text, style: AppTypography.headlineMedium);
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleMedium),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTypography.bodySmall),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primary,
            ),
          ],
        ),
      );
}

class _TimePicker extends StatelessWidget {
  final ReminderSettings settings;
  final ReminderSettingsController controller;
  const _TimePicker({required this.settings, required this.controller});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _TimeUnit(
            value: settings.notificationHour.toString().padLeft(2, '0'),
            onInc: () => controller
                .setHour((settings.notificationHour + 1) % 13 == 0
                    ? 1
                    : (settings.notificationHour % 12) + 1),
            onDec: () => controller.setHour(
                settings.notificationHour <= 1
                    ? 12
                    : settings.notificationHour - 1),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(':',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary)),
          ),
          _TimeUnit(
            value: settings.notificationMinute.toString().padLeft(2, '0'),
            onInc: () => controller
                .setMinute((settings.notificationMinute + 5) % 60),
            onDec: () => controller.setMinute(
                settings.notificationMinute < 5
                    ? 55
                    : settings.notificationMinute - 5),
          ),
          const SizedBox(width: 12),
          _AmPmToggle(
              isAm: settings.isAm, onToggle: controller.toggleAmPm),
        ],
      );
}

class _TimeUnit extends StatelessWidget {
  final String value;
  final VoidCallback onInc;
  final VoidCallback onDec;
  const _TimeUnit(
      {required this.value, required this.onInc, required this.onDec});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      );
}

class _AmPmToggle extends StatelessWidget {
  final bool isAm;
  final VoidCallback onToggle;
  const _AmPmToggle({required this.isAm, required this.onToggle});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onToggle,
        child: Column(
          children: ['AM', 'PM'].map((label) {
            final isActive =
                (label == 'AM' && isAm) || (label == 'PM' && !isAm);
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : AppColors.textSecondary,
                ),
              ),
            );
          }).toList(),
        ),
      );
}

class _FrequencySelector extends StatelessWidget {
  final RepeatFrequency selected;
  final ValueChanged<RepeatFrequency> onSelect;
  const _FrequencySelector(
      {required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) => Row(
        children: RepeatFrequency.values.map((f) {
          final label = f == RepeatFrequency.everyDay ? 'Every Day' : 'Weekdays';
          final isSelected = selected == f;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: f == RepeatFrequency.everyDay
                    ? const EdgeInsets.only(right: 6)
                    : const EdgeInsets.only(left: 6),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.border),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
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
          currentIndex: 2,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: 'Dashboard'),
            BottomNavigationBarItem(
                icon: Icon(Icons.track_changes_outlined), label: 'Goals'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'Settings'),
          ],
        ),
      );
}

