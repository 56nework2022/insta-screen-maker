import 'package:hive_flutter/hive_flutter.dart';

import 'models/comment.dart';
import 'models/feed.dart';
import 'models/follow_user.dart';
import 'models/post.dart';
import 'models/profile.dart';
import 'models/story_group.dart';
import 'models/story_image.dart';

class HiveBoxes {
  const HiveBoxes._();

  static const postBoxName = 'posts';
  static const profileBoxName = 'profiles';
  static const storyGroupBoxName = 'story_groups';
  static const feedBoxName = 'feeds';

  static Future<void> init() async {
    await Hive.initFlutter();
    _registerAdapters();
    await Future.wait([
      Hive.openBox<Post>(postBoxName),
      Hive.openBox<Profile>(profileBoxName),
      Hive.openBox<StoryGroup>(storyGroupBoxName),
      Hive.openBox<Feed>(feedBoxName),
    ]);
  }

  static void _registerAdapters() {
    Hive.registerAdapter(PostAdapter());
    Hive.registerAdapter(CommentAdapter());
    Hive.registerAdapter(ProfileAdapter());
    Hive.registerAdapter(FollowUserAdapter());
    Hive.registerAdapter(StoryGroupAdapter());
    Hive.registerAdapter(StoryImageAdapter());
    Hive.registerAdapter(FeedAdapter());
  }
}
