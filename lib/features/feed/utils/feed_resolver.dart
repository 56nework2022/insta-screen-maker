import '../../../data/hive/models/post.dart';
import '../../../data/hive/models/story_group.dart';

/// フィードが参照する投稿/ストーリーズグループを、並び順を保ったまま解決する。
/// 参照先が削除済みで存在しないIDはフィード上で非表示にする(functional-design.md 4.3節)。
class FeedResolver {
  const FeedResolver._();

  static List<Post> resolvePosts(List<String> postIds, List<Post> allPosts) {
    final postsById = {for (final post in allPosts) post.id: post};
    return [
      for (final id in postIds)
        if (postsById.containsKey(id)) postsById[id]!,
    ];
  }

  static List<StoryGroup> resolveStoryGroups(
    List<String> storyGroupIds,
    List<StoryGroup> allStoryGroups,
  ) {
    final groupsById = {for (final group in allStoryGroups) group.id: group};
    return [
      for (final id in storyGroupIds)
        if (groupsById.containsKey(id)) groupsById[id]!,
    ];
  }
}
