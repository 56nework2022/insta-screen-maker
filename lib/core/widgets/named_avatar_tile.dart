import 'package:flutter/material.dart';

import 'user_avatar.dart';

/// アイコン+名前のリスト行。フォロワー/フォロー一覧など複数フィーチャーで使う共通Widget。
class NamedAvatarTile extends StatelessWidget {
  const NamedAvatarTile({
    super.key,
    required this.name,
    required this.iconPath,
    this.onTap,
    this.trailing,
    this.avatarRadius = 20,
    this.contentPadding,
    this.titleStyle,
  });

  final String name;
  final String iconPath;
  final VoidCallback? onTap;
  final Widget? trailing;
  final double avatarRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: contentPadding,
      leading: UserAvatar(iconPath: iconPath, radius: avatarRadius),
      title: Text(name, style: titleStyle),
      trailing: trailing,
    );
  }
}
