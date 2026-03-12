import '../error/result.dart';

/// Every use case implements exactly one of these contracts.
/// [P] = params type, [R] = return type.
///
/// Keeping use cases single-responsibility means:
/// - Easy to unit test in isolation
/// - Easy to mock in controller tests
/// - Clear documentation of what the feature can "do"

abstract interface class UseCase<R, P> {
  AsyncResult<R> call(P params);
}

/// For use cases that need no parameters.
/// Example: `GetCurrentUserUseCase implements UseCase<User, NoParams>`
final class NoParams {
  const NoParams();
}