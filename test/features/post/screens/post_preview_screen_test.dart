import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:insta_screen_maker/data/hive/hive_boxes.dart';
import 'package:insta_screen_maker/data/hive/models/comment.dart';
import 'package:insta_screen_maker/data/hive/models/post.dart';
import 'package:insta_screen_maker/features/post/screens/post_preview_screen.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('post_preview_screen_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(PostAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(CommentAdapter());
    await Hive.openBox<Post>(HiveBoxes.postBoxName);

    final post = Post(
      id: 'post-1',
      imagePath: '',
      caption: 'テストキャプション',
      likeCount: 5,
      isLiked: false,
      userName: 'taro',
      userIconPath: '',
      postedAtLabel: '3時間前',
    );
    Hive.box<Post>(HiveBoxes.postBoxName).put(post.id, post);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  testWidgets('投稿の内容(投稿者名・キャプション・いいね数・いいねアイコン)が表示される', (tester) async {
    // ListViewの既定ビューポート(800x600)では画像の正方形AspectRatioだけで
    // ビューポートを超えてしまい後続の行が構築されないため、縦に大きいビューポートを使う。
    tester.view.physicalSize = const Size(400, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: PostPreviewScreen(postId: 'post-1')),
      ),
    );

    expect(find.text('taro'), findsWidgets);
    expect(find.textContaining('テストキャプション'), findsOneWidget);
    expect(find.text('5 件のいいね'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
  });
}
