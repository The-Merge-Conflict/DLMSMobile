/// Base class for all data-layer exceptions.
/// Exceptions are thrown inside the data layer and caught by repository
/// implementations, which convert them into [Failure] objects before
/// returning to the domain/presentation layers.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

// ─── Network ─────────────────────────────────────────────────────────────────

/// Thrown when there is no network connectivity.
final class NoInternetException extends AppException {
  const NoInternetException() : super('No internet connection.');
}

/// Thrown when the server returns a non-2xx HTTP response.
final class ServerException extends AppException {
  const ServerException(super.message,
      {required this.statusCode, this.responseBody});

  final int statusCode;
  final String? responseBody;
}

/// Thrown when a request exceeds the configured timeout.
final class TimeoutException extends AppException {
  const TimeoutException() : super('Request timed out.');
}

// ─── Auth ─────────────────────────────────────────────────────────────────────

/// Thrown when the server returns HTTP 401.
final class UnauthorizedException extends AppException {
  const UnauthorizedException() : super('Unauthorized.');
}

/// Thrown when the server returns HTTP 403.
final class ForbiddenException extends AppException {
  const ForbiddenException() : super('Forbidden.');
}

// ─── Parsing ─────────────────────────────────────────────────────────────────

/// Thrown when JSON deserialization fails.
final class ParseException extends AppException {
  const ParseException(super.message);
}

// ─── Local Storage ───────────────────────────────────────────────────────────

/// Thrown when reading from or writing to local storage fails.
final class StorageException extends AppException {
  const StorageException(super.message);
}
