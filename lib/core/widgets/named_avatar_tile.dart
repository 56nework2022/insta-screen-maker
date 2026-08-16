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
  });

  final String name;
  final String iconPath;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: UserAvatar(iconPath: iconPath, radius: 20),
      title: Text(name),
      trailing: trailing,
    );
  }
}
