import 'package:flutter_test/flutter_test.dart';
import 'package:insta_screen_maker/data/hive/models/post.dart';
import 'package:insta_screen_maker/data/hive/models/story_group.dart';
import 'package:insta_screen_maker/features/feed/utils/feed_resolver.dart';

Post _post(String id) => Post(
      id: id,
      imagePath: '',
      caption: '',
      likeCount: 0,
      isLiked: false,
      userName: id,
      userIconPath: '',
      postedAtLabel: '',
    );

StoryGroup _storyGroup(String id) => StoryGroup(id: id, ownerName: id, ownerIconPath: '');

void main() {
  test('resolvePostsは指定した順序を保ち、存在しない参照は除外する', () {
    final allPosts = [_post('a'), _post('b'), _post('c')];

    final resolved = FeedResolver.resolvePosts(['c', 'x', 'a'], allPosts);

    expect(resolved.map((p) => p.id), ['c', 'a']);
  });

  test('resolveStoryGroupsは指定した順序を保ち、存在しない参照は除外する', () {
    final allGroups = [_storyGroup('a'), _storyGroup('b')];

    final resolved = FeedResolver.resolveStoryGroups(['b', 'deleted', 'a'], allGroups);

    expect(resolved.map((g) => g.id), ['b', 'a']);
  });
}
