import 'package:hive/hive.dart';

part 'feed.g.dart';

@HiveType(typeId: 6)
class Feed {
  Feed({
    required this.id,
    required this.name,
    List<String>? postIds,
    List<String>? storyGroupIds,
  })  : postIds = postIds ?? const [],
        storyGroupIds = storyGroupIds ?? const [];

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<String> postIds;

  @HiveField(3)
  final List<String> storyGroupIds;

  Feed copyWith({
    String? name,
    List<String>? postIds,
    List<String>? storyGroupIds,
  }) {
    return Feed(
      id: id,
      name: name ?? this.name,
      postIds: postIds ?? this.postIds,
      storyGroupIds: storyGroupIds ?? this.storyGroupIds,
    );
  }
}
