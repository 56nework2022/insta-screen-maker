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
    int? postCount,
    String? followerCount,
    String? followingCount,
  })  : postThumbnailPaths = postThumbnailPaths ?? const [],
        followUsers = followUsers ?? const [],
        postCount = postCount ?? (postThumbnailPaths?.length ?? 0),
        followerCount = followerCount ??
            (followUsers?.where((u) => u.listType == 'follower').length ?? 0).toString(),
        followingCount = followingCount ??
            (followUsers?.where((u) => u.listType == 'following').length ?? 0).toString();

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

  @HiveField(6)
  final int postCount;

  // 注意: 7, 8はversionCode 5でint型として使用済みのため欠番とし、再利用しない。
  @HiveField(9)
  final String followerCount;

  @HiveField(10)
  final String followingCount;

  Profile copyWith({
    String? name,
    String? iconPath,
    String? bio,
    List<String>? postThumbnailPaths,
    List<FollowUser>? followUsers,
    int? postCount,
    String? followerCount,
    String? followingCount,
  }) {
    return Profile(
      id: id,
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      bio: bio ?? this.bio,
      postThumbnailPaths: postThumbnailPaths ?? this.postThumbnailPaths,
      followUsers: followUsers ?? this.followUsers,
      postCount: postCount ?? this.postCount,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
    );
  }
}
