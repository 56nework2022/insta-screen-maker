import 'package:hive/hive.dart';

import 'comment.dart';

part 'post.g.dart';

@HiveType(typeId: 0)
class Post {
  Post({
    required this.id,
    required this.imagePath,
    required this.caption,
    required this.likeCount,
    required this.isLiked,
    required this.userName,
    required this.userIconPath,
    required this.postedAtLabel,
    List<Comment>? comments,
  }) : comments = comments ?? const [];

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String imagePath;

  @HiveField(2)
  final String caption;

  @HiveField(3)
  final int likeCount;

  @HiveField(4)
  final bool isLiked;

  @HiveField(5)
  final String userName;

  @HiveField(6)
  final String userIconPath;

  @HiveField(7)
  final String postedAtLabel;

  @HiveField(8)
  final List<Comment> comments;

  Post copyWith({
    String? imagePath,
    String? caption,
    int? likeCount,
    bool? isLiked,
    String? userName,
    String? userIconPath,
    String? postedAtLabel,
    List<Comment>? comments,
  }) {
    return Post(
      id: id,
      imagePath: imagePath ?? this.imagePath,
      caption: caption ?? this.caption,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      userName: userName ?? this.userName,
      userIconPath: userIconPath ?? this.userIconPath,
      postedAtLabel: postedAtLabel ?? this.postedAtLabel,
      comments: comments ?? this.comments,
    );
  }
}
