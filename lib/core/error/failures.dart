import 'package:equatable/equatable.dart';

/// Base class for all domain-layer failures.
/// Failures are the typed, user-safe representation of errors — they cross
/// the boundary from the data layer into the domain/presentation layers.
/// They never contain raw stack traces or internal implementation details.
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// ─── Network ─────────────────────────────────────────────────────────────────

/// The device has no internet connection.
final class NoInternetFailure extends Failure {
  const NoInternetFailure()
      : super('No internet connection. Please check your network.');
}

/// The server returned an unexpected HTTP error.
final class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});

  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// The request timed out.
final class TimeoutFailure extends Failure {
  const TimeoutFailure() : super('The request timed out. Please try again.');
}

// ─── Auth ─────────────────────────────────────────────────────────────────────

/// Invalid credentials supplied during login.
final class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure() : super('Invalid email or password.');
}

/// The user's session has expired and they must log in again.
final class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure()
      : super('Your session has expired. Please log in again.');
}

/// The current user is not authorized to perform this action.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure()
      : super('You do not have permission to perform this action.');
}

// ─── Validation ──────────────────────────────────────────────────────────────

/// The server returned a 422 / 400 with validation errors.
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {this.fieldErrors});

  /// Map of field name → list of error messages.
  final Map<String, List<String>>? fieldErrors;

  @override
  List<Object?> get props => [message, fieldErrors];
}

// ─── Local Storage ───────────────────────────────────────────────────────────

/// Reading from or writing to local storage failed.
final class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

// ─── Unknown ─────────────────────────────────────────────────────────────────

/// A catch-all for unexpected errors that do not fit a specific category.
final class UnknownFailure extends Failure {
  const UnknownFailure([String message = 'An unexpected error occurred.'])
      : super(message);
}
