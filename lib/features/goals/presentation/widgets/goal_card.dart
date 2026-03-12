import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import 'package:goal_keeper_app/features/goals/domain/entities/goal_item.dart';

class GoalCard extends StatelessWidget {
  final GoalItem goal;
  final VoidCallback? onAction;

  const GoalCard({super.key, required this.goal, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatusBadge(status: goal.status),
              const Spacer(),
              _GoalImage(imageAsset: goal.imageAsset),
            ],
          ),
          const SizedBox(height: 8),
          Text(goal.title, style: AppTypography.headlineMedium),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('Progress', style: AppTypography.bodySmall),
              const Spacer(),
              Text('${(goal.progress * 100).toInt()}%',
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: goal.progress,
              minHeight: 5,
              backgroundColor: AppColors.surfaceVariant,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time_rounded,
                  size: 13, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(goal.dueLabel, style: AppTypography.bodySmall),
              const Spacer(),
              _ActionButton(status: goal.status, onTap: onAction),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final GoalStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      GoalStatus.inProgress => (
          const Color(0xFFEFF6FF),
          AppColors.primary
        ),
      GoalStatus.toDo => (
          const Color(0xFFF1F5F9),
          AppColors.textSecondary
        ),
      GoalStatus.completed => (
          const Color(0xFFECFDF5),
          AppColors.accent
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(AppRadius.full)),
      child: Text(status.label,
          style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: fg)),
    );
  }
}

class _GoalImage extends StatelessWidget {
  final String? imageAsset;
  const _GoalImage({this.imageAsset});

  @override
  Widget build(BuildContext context) => Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: const Icon(Icons.image_outlined,
            color: AppColors.textHint, size: 20),
      );
}

class _ActionButton extends StatelessWidget {
  final GoalStatus status;
  final VoidCallback? onTap;
  const _ActionButton({required this.status, this.onTap});

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      GoalStatus.inProgress => 'Update',
      GoalStatus.toDo => 'Start',
      GoalStatus.completed => 'Done',
    };
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(72, 30),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        textStyle:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full)),
      ),
      child: Text(label),
    );
  }
}