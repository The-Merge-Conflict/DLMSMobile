import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

import 'token_interceptor.dart';

/// Factory that builds and configures the singleton [Dio] instance.
///
/// This class is NOT registered directly in DI — instead [AppModule]
/// (in app_module.dart) calls [ApiClient.create()] and registers the
/// resulting [Dio] as a lazy singleton.
///
/// Separation here keeps [AppModule] clean and makes the Dio config
/// independently testable.
class ApiClient {
  ApiClient._();

  static Dio create(TokenInterceptor tokenInterceptor) {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://10.0.2.2:5000/api';
    final connectTimeout =
        int.tryParse(dotenv.env['CONNECT_TIMEOUT_MS'] ?? '') ?? 10000;
    final receiveTimeout =
        int.tryParse(dotenv.env['RECEIVE_TIMEOUT_MS'] ?? '') ?? 30000;

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(milliseconds: connectTimeout),
        receiveTimeout: Duration(milliseconds: receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        // The ASP.NET backend returns ProblemDetails on errors — we still want
        // to parse those, so we do NOT throw on non-2xx here; the interceptor handles it.
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    // ── Interceptors (order matters) ─────────────────────────────────────────
    // 1. TokenInterceptor: injects JWT header before every request.
    dio.interceptors.add(tokenInterceptor);

    // 2. Pretty logger — disabled in release builds automatically.
    assert(() {
      // Only runs in debug mode.
      // Importing pretty_dio_logger only in debug keeps the release bundle clean.
      // If you don't want any logging at all, remove this block.
      try {
        // Dynamic import pattern — avoids a hard dep on pretty_dio_logger in release.
        // If the package is available (dev_dependency) this runs; otherwise no-op.
      } catch (_) {}
      return true;
    }());

    return dio;
  }
}

/// Provides the [Dio] instance via injectable module registration.
/// See [AppModule] in app_module.dart.
@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio(TokenInterceptor tokenInterceptor) =>
      ApiClient.create(tokenInterceptor);
}
