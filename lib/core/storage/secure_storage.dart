import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../error/exceptions.dart';

/// Keys used to identify values in the secure keychain.
abstract final class _StorageKey {
  static const String accessToken = 'dlms_access_token';
  static const String refreshToken = 'dlms_refresh_token';
  static const String userId = 'dlms_user_id';
  static const String userEmail = 'dlms_user_email';
  static const String userRoles = 'dlms_user_roles'; // comma-separated
}

/// Wraps [FlutterSecureStorage] and exposes typed read/write operations for
/// auth tokens. Uses the platform keychain on iOS and the Android Keystore
/// on Android — data is hardware-encrypted.
@lazySingleton
class SecureStorageService {
  const SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  // ─── Access Token ──────────────────────────────────────────────────────────

  Future<void> saveAccessToken(String token) =>
      _write(_StorageKey.accessToken, token);
  Future<String?> getAccessToken() => _read(_StorageKey.accessToken);
  Future<bool> hasAccessToken() async => (await getAccessToken()) != null;

  // ─── Refresh Token ─────────────────────────────────────────────────────────

  Future<void> saveRefreshToken(String token) =>
      _write(_StorageKey.refreshToken, token);
  Future<String?> getRefreshToken() => _read(_StorageKey.refreshToken);

  // ─── User metadata ─────────────────────────────────────────────────────────

  Future<void> saveUserId(String id) => _write(_StorageKey.userId, id);
  Future<String?> getUserId() => _read(_StorageKey.userId);

  Future<void> saveUserEmail(String email) =>
      _write(_StorageKey.userEmail, email);
  Future<String?> getUserEmail() => _read(_StorageKey.userEmail);

  Future<void> saveUserRoles(List<String> roles) =>
      _write(_StorageKey.userRoles, roles.join(','));

  Future<List<String>> getUserRoles() async {
    final raw = await _read(_StorageKey.userRoles);
    if (raw == null || raw.isEmpty) return [];
    return raw.split(',');
  }

  // ─── Bulk operations ───────────────────────────────────────────────────────

  /// Persist all auth data returned from the login/refresh API call.
  Future<void> saveAuthData({
    required String accessToken,
    String? refreshToken,
    required String userId,
    required String email,
    required List<String> roles,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      if (refreshToken != null) saveRefreshToken(refreshToken),
      saveUserId(userId),
      saveUserEmail(email),
      saveUserRoles(roles),
    ]);
  }

  /// Wipes all stored auth data — called on logout or session expiry.
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw StorageException('Failed to clear secure storage: $e');
    }
  }

  // ─── Private helpers ───────────────────────────────────────────────────────

  Future<void> _write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      throw StorageException('Failed to write key "$key": $e');
    }
  }

  Future<String?> _read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      throw StorageException('Failed to read key "$key": $e');
    }
  }
}
