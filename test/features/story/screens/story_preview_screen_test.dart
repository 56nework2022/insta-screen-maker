import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:insta_screen_maker/data/hive/hive_boxes.dart';
import 'package:insta_screen_maker/data/hive/models/story_group.dart';
import 'package:insta_screen_maker/data/hive/models/story_image.dart';
import 'package:insta_screen_maker/features/story/screens/story_preview_screen.dart';
import 'package:insta_screen_maker/features/story/widgets/progress_bar.dart';

const _transparentPngBase64 =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('story_preview_screen_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(StoryGroupAdapter());
    if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(StoryImageAdapter());
    await Hive.openBox<StoryGroup>(HiveBoxes.storyGroupBoxName);

    final bytes = base64Decode(_transparentPngBase64);
    final image1 = File('${tempDir.path}/1.png')..writeAsBytesSync(bytes);
    final image2 = File('${tempDir.path}/2.png')..writeAsBytesSync(bytes);

    final storyGroup = StoryGroup(
      id: 'story-1',
      ownerName: 'taro',
      ownerIconPath: '',
      images: [
        StoryImage(id: 'i1', imagePath: image1.path, order: 0),
        StoryImage(id: 'i2', imagePath: image2.path, order: 1),
      ],
    );
    Hive.box<StoryGroup>(HiveBoxes.storyGroupBoxName).put(storyGroup.id, storyGroup);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  testWidgets('所有者名と進捗バーが画像枚数分表示され、タップで次の画像へ進む', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: StoryPreviewScreen(storyGroupId: 'story-1')),
      ),
    );
    await tester.pump();

    expect(find.text('taro'), findsOneWidget);
    final progressBar = tester.widget<StoryProgressBar>(find.byType(StoryProgressBar));
    expect(progressBar.itemCount, 2);
    expect(progressBar.currentIndex, 0);

    await tester.tap(find.byKey(const Key('story-tap-area')));
    await tester.pump();

    final progressBarAfterTap = tester.widget<StoryProgressBar>(find.byType(StoryProgressBar));
    expect(progressBarAfterTap.currentIndex, 1);
  });
}
