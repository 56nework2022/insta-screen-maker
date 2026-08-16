import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:insta_screen_maker/data/hive/hive_boxes.dart';
import 'package:insta_screen_maker/data/hive/models/story_group.dart';
import 'package:insta_screen_maker/data/hive/models/story_image.dart';
import 'package:insta_screen_maker/features/story/providers/story_notifier.dart';

void main() {
  late Directory tempDir;
  late ProviderContainer container;

  StoryGroup seedStoryGroup() {
    final storyGroup = StoryGroup(id: 'story-1', ownerName: 'taro', ownerIconPath: '');
    Hive.box<StoryGroup>(HiveBoxes.storyGroupBoxName).put(storyGroup.id, storyGroup);
    return storyGroup;
  }

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('story_notifier_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(StoryGroupAdapter());
    if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(StoryImageAdapter());
    await Hive.openBox<StoryGroup>(HiveBoxes.storyGroupBoxName);
    container = ProviderContainer();
  });

  tearDown(() async {
    container.dispose();
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  test('addImageは末尾にorder付きで追加する', () {
    seedStoryGroup();
    final notifier = container.read(storyNotifierProvider('story-1').notifier);

    notifier.addImage('/tmp/1.png');
    notifier.addImage('/tmp/2.png');

    final images = container.read(storyNotifierProvider('story-1')).images;
    expect(images.map((i) => i.imagePath), ['/tmp/1.png', '/tmp/2.png']);
    expect(images.map((i) => i.order), [0, 1]);
  });

  test('removeImageは削除後に残りのorderを詰め直す', () {
    seedStoryGroup();
    final notifier = container.read(storyNotifierProvider('story-1').notifier);
    notifier.addImage('/tmp/1.png');
    notifier.addImage('/tmp/2.png');
    notifier.addImage('/tmp/3.png');

    final targetId = container.read(storyNotifierProvider('story-1')).images[1].id;
    notifier.removeImage(targetId);

    final images = container.read(storyNotifierProvider('story-1')).images;
    expect(images.map((i) => i.imagePath), ['/tmp/1.png', '/tmp/3.png']);
    expect(images.map((i) => i.order), [0, 1]);
  });

  test('reorderImageはReorderableListViewの規約通りに並び替える', () {
    seedStoryGroup();
    final notifier = container.read(storyNotifierProvider('story-1').notifier);
    notifier.addImage('/tmp/1.png');
    notifier.addImage('/tmp/2.png');
    notifier.addImage('/tmp/3.png');

    // 先頭(index 0)を末尾(index 3、削除前基準)へ移動 => [2, 3, 1]
    notifier.reorderImage(0, 3);

    final images = container.read(storyNotifierProvider('story-1')).images;
    expect(images.map((i) => i.imagePath), ['/tmp/2.png', '/tmp/3.png', '/tmp/1.png']);
    expect(images.map((i) => i.order), [0, 1, 2]);
  });
}
