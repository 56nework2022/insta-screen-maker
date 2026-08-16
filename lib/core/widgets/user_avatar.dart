import 'dart:io';

import 'package:flutter/material.dart';

/// アイコン画像パスから円形アバターを表示する。空文字の場合はプレースホルダーを表示する。
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.iconPath, this.radius = 16});

  final String iconPath;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (iconPath.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade300,
        child: Icon(Icons.person, size: radius, color: Colors.grey.shade600),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundImage: FileImage(File(iconPath)),
    );
  }
}
