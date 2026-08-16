import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../data/hive/hive_boxes.dart';
import '../../../data/hive/models/feed.dart';

class FeedNotifier extends FamilyNotifier<Feed, String> {
  Box<Feed> get _box => Hive.box<Feed>(HiveBoxes.feedBoxName);

  @override
  Feed build(String arg) => _box.get(arg)!;

  void _update(Feed updated) {
    _box.put(updated.id, updated);
    state = updated;
  }

  void updateName(String name) => _update(state.copyWith(name: name));

  void addPost(String postId) {
    if (state.postIds.contains(postId)) return;
    _update(state.copyWith(postIds: [...state.postIds, postId]));
  }

  void removePost(String postId) {
    _update(state.copyWith(postIds: state.postIds.where((id) => id != postId).toList()));
  }

  /// [oldIndex]/[newIndex]は`ReorderableListView.onReorder`の仕様に合わせる。
  void reorderPost(int oldIndex, int newIndex) {
    var targetIndex = newIndex;
    if (oldIndex < newIndex) targetIndex -= 1;
    final ids = [...state.postIds];
    final moved = ids.removeAt(oldIndex);
    ids.insert(targetIndex, moved);
    _update(state.copyWith(postIds: ids));
  }

  void addStoryGroup(String storyGroupId) {
    if (state.storyGroupIds.contains(storyGroupId)) return;
    _update(state.copyWith(storyGroupIds: [...state.storyGroupIds, storyGroupId]));
  }

  void removeStoryGroup(String storyGroupId) {
    _update(state.copyWith(
      storyGroupIds: state.storyGroupIds.where((id) => id != storyGroupId).toList(),
    ));
  }

  void reorderStoryGroup(int oldIndex, int newIndex) {
    var targetIndex = newIndex;
    if (oldIndex < newIndex) targetIndex -= 1;
    final ids = [...state.storyGroupIds];
    final moved = ids.removeAt(oldIndex);
    ids.insert(targetIndex, moved);
    _update(state.copyWith(storyGroupIds: ids));
  }
}

final feedNotifierProvider = NotifierProvider.family<FeedNotifier, Feed, String>(
  FeedNotifier.new,
);
