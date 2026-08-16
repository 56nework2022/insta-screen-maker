import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:insta_screen_maker/data/hive/hive_boxes.dart';
import 'package:insta_screen_maker/data/hive/models/feed.dart';
import 'package:insta_screen_maker/features/feed/providers/feed_notifier.dart';

void main() {
  late Directory tempDir;
  late ProviderContainer container;

  Feed seedFeed() {
    final feed = Feed(id: 'feed-1', name: 'メインフィード');
    Hive.box<Feed>(HiveBoxes.feedBoxName).put(feed.id, feed);
    return feed;
  }

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('feed_notifier_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(6)) Hive.registerAdapter(FeedAdapter());
    await Hive.openBox<Feed>(HiveBoxes.feedBoxName);
    container = ProviderContainer();
  });

  tearDown(() async {
    container.dispose();
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  test('addPostは重複を追加せず、末尾に追加する', () {
    seedFeed();
    final notifier = container.read(feedNotifierProvider('feed-1').notifier);

    notifier.addPost('post-1');
    notifier.addPost('post-2');
    notifier.addPost('post-1');

    expect(container.read(feedNotifierProvider('feed-1')).postIds, ['post-1', 'post-2']);
  });

  test('removePostは指定IDのみ除去する', () {
    seedFeed();
    final notifier = container.read(feedNotifierProvider('feed-1').notifier);
    notifier.addPost('post-1');
    notifier.addPost('post-2');

    notifier.removePost('post-1');

    expect(container.read(feedNotifierProvider('feed-1')).postIds, ['post-2']);
  });

  test('reorderPostはReorderableListViewの規約通りに並び替える', () {
    seedFeed();
    final notifier = container.read(feedNotifierProvider('feed-1').notifier);
    notifier.addPost('post-1');
    notifier.addPost('post-2');
    notifier.addPost('post-3');

    notifier.reorderPost(0, 3);

    expect(container.read(feedNotifierProvider('feed-1')).postIds, ['post-2', 'post-3', 'post-1']);
  });

  test('addStoryGroup/removeStoryGroupはstoryGroupIdsを更新する', () {
    seedFeed();
    final notifier = container.read(feedNotifierProvider('feed-1').notifier);

    notifier.addStoryGroup('story-1');
    notifier.addStoryGroup('story-2');
    notifier.removeStoryGroup('story-1');

    expect(container.read(feedNotifierProvider('feed-1')).storyGroupIds, ['story-2']);
  });
}
