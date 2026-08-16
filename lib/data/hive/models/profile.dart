import 'package:hive/hive.dart';

import 'follow_user.dart';

part 'profile.g.dart';

@HiveType(typeId: 2)
class Profile {
  Profile({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.bio,
    List<String>? postThumbnailPaths,
    List<FollowUser>? followUsers,
  })  : postThumbnailPaths = postThumbnailPaths ?? const [],
        followUsers = followUsers ?? const [];

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String iconPath;

  @HiveField(3)
  final String bio;

  @HiveField(4)
  final List<String> postThumbnailPaths;

  @HiveField(5)
  final List<FollowUser> followUsers;

  Profile copyWith({
    String? name,
    String? iconPath,
    String? bio,
    List<String>? postThumbnailPaths,
    List<FollowUser>? followUsers,
  }) {
    return Profile(
      id: id,
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      bio: bio ?? this.bio,
      postThumbnailPaths: postThumbnailPaths ?? this.postThumbnailPaths,
      followUsers: followUsers ?? this.followUsers,
    );
  }
}
