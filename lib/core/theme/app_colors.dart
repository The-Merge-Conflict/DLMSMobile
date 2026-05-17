import 'package:flutter/material.dart';

/// Single source of truth for every color used in the app.
/// Never use raw hex literals outside this file.
abstract final class AppColors {
  // ─── Brand ─────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF1F3864);
  static const Color primaryLight = Color(0xFF2E75B6);
  static const Color primaryContainer = Color(0xFFD5E8F0);

  static const Color secondary = Color(0xFF2F5496);
  static const Color secondaryContainer = Color(0xFFBDD7EE);

  static const Color accent = Color(0xFF2E75B6);

  // ─── Semantic ──────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF2E7D32);
  static const Color successContainer = Color(0xFFC8E6C9);

  static const Color warning = Color(0xFFF57F17);
  static const Color warningContainer = Color(0xFFFFF9C4);

  static const Color error = Color(0xFFB71C1C);
  static const Color errorContainer = Color(0xFFFFCDD2);

  static const Color info = Color(0xFF01579B);
  static const Color infoContainer = Color(0xFFE1F5FE);

  // ─── Neutrals (Light) ──────────────────────────────────────────────────────
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF2F7FB);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color onSurfaceVariant = Color(0xFF49454F);

  static const Color outline = Color(0xFF79747E);
  static const Color outlineVariant = Color(0xFFCAC4D0);

  static const Color background = Color(0xFFF5F5F5);
  static const Color onBackground = Color(0xFF1C1B1F);

  // ─── Neutrals (Dark) ───────────────────────────────────────────────────────
  static const Color darkSurface = Color(0xFF1C1B1F);
  static const Color darkSurfaceVariant = Color(0xFF2B2930);
  static const Color darkOnSurface = Color(0xFFE6E1E5);
  static const Color darkBackground = Color(0xFF141218);
  static const Color darkOutlineVariant = Color(0xFF49454F);

  // ─── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1C1B1F);
  static const Color textSecondary = Color(0xFF49454F);
  static const Color textDisabled = Color(0xFF9E9E9E);
  static const Color textHint = Color(0xFFAEAAAE);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ─── Shimmer ───────────────────────────────────────────────────────────────
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
}