import 'package:flutter/material.dart';
import 'package:goal_keeper_app/core/theme/app_theme.dart';
import 'package:goal_keeper_app/features/goals/domain/entities/goal.dart';

/// A widget that displays a single goal item with toggle functionality.
class GoalItemWidget extends StatelessWidget {
  final Goal goal;
  final bool isPending;
  final VoidCallback onToggle;

  const GoalItemWidget({
    super.key,
    required this.goal,
    required this.isPending,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: goal.isCompleted ? AppColors.success : AppColors.border,
          width: goal.isCompleted ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: isPending ? null : onToggle,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: goal.isCompleted
                    ? AppColors.success
                    : Colors.transparent,
                border: Border.all(
                  color: goal.isCompleted
                      ? AppColors.success
                      : AppColors.border,
                  width: 2,
                ),
              ),
              child: goal.isCompleted
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.title,
                  style: AppTypography.titleMedium.copyWith(
                    decoration: goal.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: goal.isCompleted
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                ),
                if (goal.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    goal.description,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (goal.scheduledTime != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        goal.scheduledTime!,
                        style: AppTypography.labelSmall,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (goal.priority == GoalPriority.high)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                goal.priority.label,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (isPending) ...[
            const SizedBox(width: AppSpacing.sm),
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

