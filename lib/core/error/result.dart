import 'failures.dart';

/// A discriminated union that holds either a [Failure] (Left) or a success
/// value [R] (Right). Use cases always return `AsyncResult<T>` so that the
/// presentation layer never has to catch exceptions.
///
/// Usage:
/// ```dart
/// final result = await getGoalsUseCase(NoParams());
/// result.when(
///   failure: (f) => state = ErrorState(f.message),
///   success: (goals) => state = LoadedState(goals),
/// );
/// ```
sealed class Result<R> {
  const Result();

  bool get isSuccess => this is Success<R>;
  bool get isFailure => this is Failure_<R>;

  R? get dataOrNull => switch (this) {
        Success(:final data) => data,
        _ => null,
      };

  Failure? get failureOrNull => switch (this) {
        Failure_(:final failure) => failure,
        _ => null,
      };

  T when<T>({
    required T Function(Failure failure) failure,
    required T Function(R data) success,
  }) =>
      switch (this) {
        Failure_(failure: final f) => failure(f),
        Success(:final data) => success(data),
      };

  /// Transforms the success value without unwrapping.
  Result<T> map<T>(T Function(R data) transform) => switch (this) {
        Failure_(failure: final f) => Failure_<T>(f),
        Success(:final data) => Success(transform(data)),
      };
}

final class Success<R> extends Result<R> {
  final R data;
  const Success(this.data);
}

final class Failure_<R> extends Result<R> {
  final Failure failure;
  const Failure_(this.failure);
}

/// Shorthand constructors
Result<R> success<R>(R data) => Success(data);
Result<R> failure<R>(Failure f) => Failure_(f);

/// Convenience typedef
typedef AsyncResult<R> = Future<Result<R>>;// Result<T> = Success | Failure
