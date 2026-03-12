/// Base class for all domain-layer failures.
/// UI controllers map these to user-facing messages — never raw exceptions.
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

// ─── Infrastructure failures ───────────────────────────────────────────────

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({String message = 'Server error.', this.statusCode})
      : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local cache error.']);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timed out.']);
}

// ─── Domain failures ────────────────────────────────────────────────────────

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation error.']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found.']);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Permission denied.']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred.']);
}// Typed failure classes
