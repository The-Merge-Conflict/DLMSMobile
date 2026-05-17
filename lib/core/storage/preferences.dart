import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keys for SharedPreferences entries.
abstract final class _PrefKey {
  static const String themeMode =
      'pref_theme_mode'; // 'system' | 'light' | 'dark'
  static const String locale = 'pref_locale'; // 'en' | 'ar'
  static const String onboardingDone = 'pref_onboarding_done';
}

/// Stores non-sensitive user preferences (theme, language, UI flags) using
/// [SharedPreferences]. For sensitive data (tokens) use [SecureStorageService].
@lazySingleton
class PreferencesService {
  const PreferencesService(this._prefs);

  final SharedPreferences _prefs;

  // ─── Theme ─────────────────────────────────────────────────────────────────

  String get themeMode => _prefs.getString(_PrefKey.themeMode) ?? 'system';

  Future<void> setThemeMode(String mode) =>
      _prefs.setString(_PrefKey.themeMode, mode);

  // ─── Locale ────────────────────────────────────────────────────────────────

  String get locale => _prefs.getString(_PrefKey.locale) ?? 'en';

  Future<void> setLocale(String languageCode) =>
      _prefs.setString(_PrefKey.locale, languageCode);

  // ─── Onboarding ────────────────────────────────────────────────────────────

  bool get isOnboardingDone => _prefs.getBool(_PrefKey.onboardingDone) ?? false;

  Future<void> setOnboardingDone() =>
      _prefs.setBool(_PrefKey.onboardingDone, true);
}
