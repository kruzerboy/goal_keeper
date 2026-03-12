import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

enum AppButtonVariant { primary, outlined, ghost }

/// Single reusable button component for all 50+ screens.
/// Handles loading, disabled, and icon states consistently.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool fullWidth;
  final Widget? leadingIcon;
  final double? height;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.fullWidth = true,
    this.leadingIcon,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    final child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: variant == AppButtonVariant.primary
                  ? Colors.white
                  : AppColors.primary,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                leadingIcon!,
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(label),
            ],
          );

    final size = ButtonStyle(
      minimumSize: WidgetStateProperty.all(
        Size(fullWidth ? double.infinity : 0, height ?? 52),
      ),
    );

    return switch (variant) {
      AppButtonVariant.primary => ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom().merge(size),
          child: child,
        ),
      AppButtonVariant.outlined => OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom().merge(size),
          child: child,
        ),
      AppButtonVariant.ghost => TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: TextButton.styleFrom(
            minimumSize: Size(fullWidth ? double.infinity : 0, height ?? 52),
          ),
          child: child,
        ),
    };
  }
}