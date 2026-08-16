import 'package:hive/hive.dart';

import 'story_image.dart';

part 'story_group.g.dart';

@HiveType(typeId: 4)
class StoryGroup {
  StoryGroup({
    required this.id,
    required this.ownerName,
    required this.ownerIconPath,
    List<StoryImage>? images,
  }) : images = images ?? const [];

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String ownerName;

  @HiveField(2)
  final String ownerIconPath;

  @HiveField(3)
  final List<StoryImage> images;

  StoryGroup copyWith({
    String? ownerName,
    String? ownerIconPath,
    List<StoryImage>? images,
  }) {
    return StoryGroup(
      id: id,
      ownerName: ownerName ?? this.ownerName,
      ownerIconPath: ownerIconPath ?? this.ownerIconPath,
      images: images ?? this.images,
    );
  }
}
