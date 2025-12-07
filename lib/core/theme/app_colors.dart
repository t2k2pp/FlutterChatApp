import 'package:flutter/material.dart';

/// アプリケーションのカラーパレット
class AppColors {
  // プライマリカラー
  static const primary = Color(0xFFD97757); // Claude-style オレンジ
  static const primaryLight = Color(0xFFE5A88F);
  static const primaryDark = Color(0xFFC45D3A);

  // 背景色
  static const background = Color(0xFFFDFDFC); // ほぼ白
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFF5F2EB); // ベージュ系

  // テキストカラー
  static const textPrimary = Color(0xFF333333);
  static const textSecondary = Color(0xFF5F5E5B);
  static const textTertiary = Color(0xFF9E9E9E);

  // ボーダー・区切り線
  static const border = Color(0xFFE5E5E0);
  static const divider = Color(0xFFEAE7E0);

  // Watson専用色
  static const watson = Color(0xFF5C6AC4); // 藍色
  static const watsonLight = Color(0xFF7C8AD4);

  // エラー
  static const error = Color(0xFFE74C3C);
  static const errorLight = Color(0xFFFF6B6B);

  // 成功
  static const success = Color(0xFF2ECC71);

  // ホバー・選択状態
  static const hoverOverlay = Color(0x0F000000); // 黒6%
  static const selectedOverlay = Color(0x1F000000); // 黒12%
}
