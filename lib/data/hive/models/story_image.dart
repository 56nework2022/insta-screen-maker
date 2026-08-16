import 'package:hive/hive.dart';

part 'story_image.g.dart';

@HiveType(typeId: 5)
class StoryImage {
  StoryImage({
    required this.id,
    required this.imagePath,
    required this.order,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String imagePath;

  @HiveField(2)
  final int order;

  StoryImage copyWith({
    String? imagePath,
    int? order,
  }) {
    return StoryImage(
      id: id,
      imagePath: imagePath ?? this.imagePath,
      order: order ?? this.order,
    );
  }
}
