/// Standardised UI state machine used by every screen controller.
/// This enforces a consistent pattern across all 50+ screens.
///
/// Controllers return `ScreenState<T>` and screens switch on it:
/// ```dart
/// switch (state) {
///   ScreenInitial()  => const SizedBox.shrink(),
///   ScreenLoading()  => const LoadingIndicator(),
///   ScreenLoaded(:final data) => MyWidget(data),
///   ScreenError(:final message) => ErrorView(message),
/// }
/// ```
sealed class ScreenState<T> {
  const ScreenState();
}

final class ScreenInitial<T> extends ScreenState<T> {
  const ScreenInitial();
}

final class ScreenLoading<T> extends ScreenState<T> {
  const ScreenLoading();
}

final class ScreenLoaded<T> extends ScreenState<T> {
  final T data;
  const ScreenLoaded(this.data);
}

final class ScreenError<T> extends ScreenState<T> {
  final String message;
  final Object? error;
  const ScreenError(this.message, {this.error});
}

/// For screens that support partial/paginated loading (e.g. lists).
final class ScreenLoadingMore<T> extends ScreenState<T> {
  final T currentData;
  const ScreenLoadingMore(this.currentData);
}

final class ScreenEmpty<T> extends ScreenState<T> {
  const ScreenEmpty();
}
