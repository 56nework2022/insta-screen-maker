import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({super.key, required this.isLiked, required this.onTap});

  final bool isLiked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? AppColors.likeRed : AppColors.iconDefault,
      ),
    );
  }
}
