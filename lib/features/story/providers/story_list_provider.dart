import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../core/utils/id_generator.dart';
import '../../../data/hive/hive_boxes.dart';
import '../../../data/hive/models/story_group.dart';

class StoryListNotifier extends Notifier<List<StoryGroup>> {
  Box<StoryGroup> get _box => Hive.box<StoryGroup>(HiveBoxes.storyGroupBoxName);

  @override
  List<StoryGroup> build() => _box.values.toList();

  StoryGroup createStoryGroup() {
    final storyGroup = StoryGroup(
      id: IdGenerator.generate(),
      ownerName: '',
      ownerIconPath: '',
    );
    _box.put(storyGroup.id, storyGroup);
    refresh();
    return storyGroup;
  }

  void deleteStoryGroup(String id) {
    _box.delete(id);
    refresh();
  }

  void refresh() {
    state = _box.values.toList();
  }
}

final storyListProvider = NotifierProvider<StoryListNotifier, List<StoryGroup>>(
  StoryListNotifier.new,
);
