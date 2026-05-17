import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../storage/secure_storage.dart';

/// Dio interceptor responsible for:
///   1. Injecting the stored JWT Bearer token into every outgoing request.
///   2. Detecting 401 Unauthorized responses and triggering a logout callback.
///
/// ### Circular dependency note
/// TokenInterceptor intentionally does NOT depend on AuthBloc. If it did,
/// we would have:
///   AuthBloc → IAuthRepository → Dio → TokenInterceptor → AuthBloc  ← cycle!
///
/// Instead, [onUnauthorized] is a nullable callback that [DlmsApp] sets once
/// the AuthBloc is alive in the widget tree:
///
/// ```dart
/// getIt<TokenInterceptor>().onUnauthorized =
///     () => authBloc.add(const AuthLoggedOutEvent());
/// ```
@lazySingleton
class TokenInterceptor extends Interceptor {
  TokenInterceptor(this._secureStorage);

  final SecureStorageService _secureStorage;

  /// Set this callback from the root widget after the AuthBloc is created.
  VoidCallback? onUnauthorized;

  // ─── Request ───────────────────────────────────────────────────────────────

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  // ─── Response ──────────────────────────────────────────────────────────────

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Pass all responses (including 4xx < 500) through so the repository
    // layer can decide how to handle them.
    handler.next(response);
  }

  // ─── Error ─────────────────────────────────────────────────────────────────
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Token is invalid or expired.
      // 1. Wipe stored credentials so the app starts clean on next launch.
      await _secureStorage.clearAll();
      // 2. Notify the AuthBloc (if the callback is wired up) so the router
      //    immediately redirects to the login screen.
      onUnauthorized?.call();
    }
    return handler.next(err);
  }
}
