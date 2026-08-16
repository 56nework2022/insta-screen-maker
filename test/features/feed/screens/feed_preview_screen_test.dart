import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:insta_screen_maker/data/hive/hive_boxes.dart';
import 'package:insta_screen_maker/data/hive/models/comment.dart';
import 'package:insta_screen_maker/data/hive/models/feed.dart';
import 'package:insta_screen_maker/data/hive/models/post.dart';
import 'package:insta_screen_maker/data/hive/models/story_group.dart';
import 'package:insta_screen_maker/data/hive/models/story_image.dart';
import 'package:insta_screen_maker/features/feed/screens/feed_preview_screen.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('feed_preview_screen_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(PostAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(CommentAdapter());
    if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(StoryGroupAdapter());
    if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(StoryImageAdapter());
    if (!Hive.isAdapterRegistered(6)) Hive.registerAdapter(FeedAdapter());
    await Hive.openBox<Post>(HiveBoxes.postBoxName);
    await Hive.openBox<StoryGroup>(HiveBoxes.storyGroupBoxName);
    await Hive.openBox<Feed>(HiveBoxes.feedBoxName);

    Hive.box<Post>(HiveBoxes.postBoxName).put(
      'post-1',
      Post(
        id: 'post-1',
        imagePath: '',
        caption: '生存している投稿',
        likeCount: 3,
        isLiked: false,
        userName: 'taro',
        userIconPath: '',
        postedAtLabel: '1時間前',
      ),
    );

    Hive.box<Feed>(HiveBoxes.feedBoxName).put(
      'feed-1',
      Feed(id: 'feed-1', name: 'マイフィード', postIds: const ['post-1', 'deleted-post']),
    );
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  testWidgets('削除済みの投稿への参照は表示されず、存在する投稿のみ表示される', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: FeedPreviewScreen(feedId: 'feed-1')),
      ),
    );

    expect(find.text('マイフィード'), findsOneWidget);
    expect(find.textContaining('生存している投稿'), findsOneWidget);
    expect(find.text('3 件のいいね'), findsOneWidget);
  });
}
