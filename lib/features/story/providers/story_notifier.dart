import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../core/utils/id_generator.dart';
import '../../../data/hive/hive_boxes.dart';
import '../../../data/hive/models/story_group.dart';
import '../../../data/hive/models/story_image.dart';

class StoryNotifier extends FamilyNotifier<StoryGroup, String> {
  Box<StoryGroup> get _box => Hive.box<StoryGroup>(HiveBoxes.storyGroupBoxName);

  @override
  StoryGroup build(String arg) => _box.get(arg)!;

  void _update(StoryGroup updated) {
    _box.put(updated.id, updated);
    state = updated;
  }

  List<StoryImage> _reindexed(List<StoryImage> images) {
    return [for (var i = 0; i < images.length; i++) images[i].copyWith(order: i)];
  }

  void updateOwnerName(String ownerName) => _update(state.copyWith(ownerName: ownerName));

  void updateOwnerIconPath(String ownerIconPath) => _update(state.copyWith(ownerIconPath: ownerIconPath));

  void addImage(String imagePath) {
    final image = StoryImage(
      id: IdGenerator.generate(),
      imagePath: imagePath,
      order: state.images.length,
    );
    _update(state.copyWith(images: [...state.images, image]));
  }

  void removeImage(String id) {
    final images = state.images.where((image) => image.id != id).toList();
    _update(state.copyWith(images: _reindexed(images)));
  }

  /// [oldIndex]/[newIndex]は`ReorderableListView.onReorder`の仕様に合わせる
  /// (削除前のインデックスを基準とするため、下方向への移動時は1つ補正する)。
  void reorderImage(int oldIndex, int newIndex) {
    var targetIndex = newIndex;
    if (oldIndex < newIndex) {
      targetIndex -= 1;
    }
    final images = [...state.images];
    final moved = images.removeAt(oldIndex);
    images.insert(targetIndex, moved);
    _update(state.copyWith(images: _reindexed(images)));
  }
}

final storyNotifierProvider = NotifierProvider.family<StoryNotifier, StoryGroup, String>(
  StoryNotifier.new,
);
