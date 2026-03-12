import 'package:flutter/material.dart';
import 'package:goal_keeper_app/core/utils/screen_state.dart';

import '../../theme/app_theme.dart';

/// Drop-in widget that handles the 5 states every screen can be in.
/// Screens use this so they NEVER repeat the loading/error boilerplate.
///
/// ```dart
/// StateHandler<DashboardData>(
///   state: controller.state,
///   onLoaded: (data) => DashboardContent(data: data),
/// )
/// ```
class StateHandler<T> extends StatelessWidget {
  final ScreenState<T> state;
  final Widget Function(T data) onLoaded;
  final Widget? loadingWidget;
  final Widget Function(String message)? onError;
  final Widget? emptyWidget;
  final VoidCallback? onRetry;

  const StateHandler({
    super.key,
    required this.state,
    required this.onLoaded,
    this.loadingWidget,
    this.onError,
    this.emptyWidget,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      ScreenInitial() || ScreenLoading() =>
        loadingWidget ?? const _DefaultLoader(),
      ScreenEmpty() => emptyWidget ?? const _DefaultEmpty(),
      ScreenLoaded(:final data) => onLoaded(data),
      ScreenLoadingMore(:final currentData) => onLoaded(currentData),
      ScreenError(:final message) => onError != null
          ? onError!(message)
          : _DefaultError(message: message, onRetry: onRetry),
    };
  }
}

class _DefaultLoader extends StatelessWidget {
  const _DefaultLoader();

  @override
  Widget build(BuildContext context) => const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.primary,
        ),
      );
}

class _DefaultEmpty extends StatelessWidget {
  const _DefaultEmpty();

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined,
                size: 48, color: AppColors.textHint),
            const SizedBox(height: AppSpacing.md),
            Text('Nothing here yet', style: AppTypography.bodyMedium),
          ],
        ),
      );
}

class _DefaultError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _DefaultError({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline,
                  size: 48, color: AppColors.error),
              const SizedBox(height: AppSpacing.md),
              Text(message,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium),
              if (onRetry != null) ...[
                const SizedBox(height: AppSpacing.lg),
                TextButton(
                  onPressed: onRetry,
                  child: const Text('Try again'),
                ),
              ],
            ],
          ),
        ),
      );
}
