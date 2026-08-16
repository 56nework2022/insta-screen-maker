import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const background = Colors.white;
  static const primaryText = Color(0xFF262626);
  static const secondaryText = Color(0xFF8E8E8E);
  static const divider = Color(0xFFDBDBDB);
  static const likeRed = Color(0xFFED4956);
  static const linkBlue = Color(0xFF00376B);
  static const iconDefault = Color(0xFF262626);

  static const storyRingGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFEDA75),
      Color(0xFFFA7E1E),
      Color(0xFFD62976),
      Color(0xFF962FBF),
      Color(0xFF4F5BD5),
    ],
  );
}
