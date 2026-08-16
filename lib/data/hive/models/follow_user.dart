import 'package:hive/hive.dart';

part 'follow_user.g.dart';

/// `listType`は `"follower"` または `"following"` のいずれかを取る(docs/glossary.md参照)。
@HiveType(typeId: 3)
class FollowUser {
  FollowUser({
    required this.id,
    required this.listType,
    required this.name,
    required this.iconPath,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String listType;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String iconPath;

  FollowUser copyWith({
    String? name,
    String? iconPath,
  }) {
    return FollowUser(
      id: id,
      listType: listType,
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
    );
  }
}
