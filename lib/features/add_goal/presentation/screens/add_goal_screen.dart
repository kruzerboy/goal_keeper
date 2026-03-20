import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_keeper_app/core/di/service_locator.dart';
import 'package:goal_keeper_app/core/router/app_router.dart';
import 'package:goal_keeper_app/core/theme/app_theme.dart';
import 'package:goal_keeper_app/core/utils/screen_state.dart';
import 'package:goal_keeper_app/features/goals/domain/entities/goal_item.dart';
import 'package:goal_keeper_app/features/add_goal/presentation/controllers/add_goal_controller.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  late final AddGoalController _controller;
  final _nameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = ServiceLocator.instance.addGoalController()
      ..addListener(_rebuild);
  }

  void _rebuild() {
    if (!mounted) return;
    setState(() {});
  }

  void _closeScreen() {
    if (!mounted) return;
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutes.dashboard);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_rebuild)
      ..dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _controller.submitState is ScreenLoading;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(onClose: _closeScreen),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionLabel('BASICS'),
                    const SizedBox(height: 12),
                    const _FieldLabel('Goal Name'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameCtrl,
                      onChanged: _controller.updateName,
                      decoration: const InputDecoration(
                          hintText: 'e.g. Learn UI Design'),
                    ),
                    const SizedBox(height: 16),
                    const _FieldLabel('Category'),
                    const SizedBox(height: 8),
                    _CategoryDropdown(
                      value: _controller.form.category,
                      onChanged: _controller.updateCategory,
                    ),
                    const SizedBox(height: 24),
                    const _SectionLabel('IMPORTANCE'),
                    const SizedBox(height: 12),
                    const _FieldLabel('Priority Level'),
                    const SizedBox(height: 10),
                    _PrioritySelector(
                      selected: _controller.form.priority,
                      onSelect: _controller.updatePriority,
                    ),
                    const SizedBox(height: 24),
                    const _SectionLabel('TIMELINE'),
                    const SizedBox(height: 12),
                    const _FieldLabel('Target Deadline'),
                    const SizedBox(height: 10),
                    _CalendarPicker(controller: _controller),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            _SaveButton(
              isLoading: isLoading,
              enabled: _controller.form.isValid && !isLoading,
              onSave: () => _controller.saveGoal(
                onSuccess: _closeScreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final VoidCallback onClose;

  const _TopBar({required this.onClose});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            GestureDetector(
              onTap: onClose,
              child: const Icon(Icons.close, color: AppColors.textPrimary),
            ),
            const Expanded(
              child: Text('Add New Goal',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.question_mark,
                  color: Colors.white, size: 14),
            ),
          ],
        ),
      );
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: AppTypography.labelSmall
            .copyWith(letterSpacing: 1.5, color: AppColors.textSecondary),
      );
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) =>
      Text(text, style: AppTypography.titleMedium);
}

class _CategoryDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  const _CategoryDropdown({this.value, required this.onChanged});

  static const _categories = [
    'Health', 'Work', 'Fitness', 'Learning', 'Personal', 'Finance'
  ];

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            hint: Text('Select category', style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textHint)),
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down,
                color: AppColors.textSecondary),
            items: _categories
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      );
}

class _PrioritySelector extends StatelessWidget {
  final PriorityLevel selected;
  final ValueChanged<PriorityLevel> onSelect;
  const _PrioritySelector(
      {required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: PriorityLevel.values.map((p) {
            final isSelected = selected == p;
            final label = switch (p) {
              PriorityLevel.low => 'Low',
              PriorityLevel.medium => 'Medium',
              PriorityLevel.high => 'High',
            };
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelect(p),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
}

class _CalendarPicker extends StatelessWidget {
  final AddGoalController controller;
  const _CalendarPicker({required this.controller});

  static const _weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  static const _months = [
    '', 'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  Widget build(BuildContext context) {
    final month = controller.calendarMonth;
    final firstDay = DateTime(month.year, month.month, 1).weekday % 7;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final selected = controller.form.deadline;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          // Month nav
          Row(
            children: [
              GestureDetector(
                onTap: controller.prevMonth,
                child: const Icon(Icons.chevron_left,
                    color: AppColors.textSecondary),
              ),
              Expanded(
                child: Text(
                  '${_months[month.month]} ${month.year}',
                  textAlign: TextAlign.center,
                  style: AppTypography.titleLarge,
                ),
              ),
              GestureDetector(
                onTap: controller.nextMonth,
                child: const Icon(Icons.chevron_right,
                    color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Weekday headers
          Row(
            children: _weekdays
                .map((d) => Expanded(
                      child: Text(d,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodySmall),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          // Days grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 1,
            ),
            itemCount: firstDay + daysInMonth,
            itemBuilder: (_, i) {
              if (i < firstDay) return const SizedBox();
              final day = i - firstDay + 1;
              final date = DateTime(month.year, month.month, day);
              final isSelected = selected != null &&
                  selected.year == date.year &&
                  selected.month == date.month &&
                  selected.day == date.day;
              return GestureDetector(
                onTap: () => controller.selectDeadline(date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.normal,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final bool isLoading;
  final bool enabled;
  final VoidCallback onSave;
  const _SaveButton(
      {required this.isLoading,
      required this.enabled,
      required this.onSave});

  @override
  Widget build(BuildContext context) => Container(
        color: AppColors.surface,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: ElevatedButton.icon(
          onPressed: enabled ? onSave : null,
          icon: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.check_circle_outline, size: 18),
          label: const Text('Save Goal'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.full)),
          ),
        ),
      );
}