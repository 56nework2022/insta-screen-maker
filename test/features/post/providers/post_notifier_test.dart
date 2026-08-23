import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:insta_screen_maker/data/hive/hive_boxes.dart';
import 'package:insta_screen_maker/data/hive/models/comment.dart';
import 'package:insta_screen_maker/data/hive/models/post.dart';
import 'package:insta_screen_maker/features/post/providers/post_notifier.dart';

void main() {
  late Directory tempDir;
  late ProviderContainer container;

  Post seedPost() {
    final post = Post(
      id: 'post-1',
      imagePath: '',
      caption: '元のキャプション',
      likeCount: 10,
      isLiked: false,
      userName: 'taro',
      userIconPath: '',
      postedAtLabel: '3時間前',
    );
    Hive.box<Post>(HiveBoxes.postBoxName).put(post.id, post);
    return post;
  }

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('post_notifier_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(PostAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(CommentAdapter());
    await Hive.openBox<Post>(HiveBoxes.postBoxName);
    container = ProviderContainer();
  });

  tearDown(() async {
    container.dispose();
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  test('toggleLikeはisLikedを反転させ、いいね数を増減しBoxへ反映する', () {
    seedPost();

    final notifier = container.read(postNotifierProvider('post-1').notifier);
    notifier.toggleLike();

    final liked = container.read(postNotifierProvider('post-1'));
    expect(liked.isLiked, isTrue);
    expect(liked.likeCount, 11);
    expect(Hive.box<Post>(HiveBoxes.postBoxName).get('post-1')!.isLiked, isTrue);

    notifier.toggleLike();
    final unliked = container.read(postNotifierProvider('post-1'));
    expect(unliked.isLiked, isFalse);
    expect(unliked.likeCount, 10);
  });

  test('addCommentはコメントを追加し永続化する', () {
    seedPost();

    final notifier = container.read(postNotifierProvider('post-1').notifier);
    notifier.addComment(userName: 'hanako', userIconPath: '', body: 'いいですね');

    final updated = container.read(postNotifierProvider('post-1'));
    expect(updated.comments, hasLength(1));
    expect(updated.comments.first.userName, 'hanako');
    expect(updated.comments.first.body, 'いいですね');
    expect(Hive.box<Post>(HiveBoxes.postBoxName).get('post-1')!.comments, hasLength(1));
  });

  test('deleteCommentは指定したコメントのみ削除する', () {
    seedPost();
    final notifier = container.read(postNotifierProvider('post-1').notifier);
    notifier.addComment(userName: 'a', userIconPath: '', body: 'first');
    notifier.addComment(userName: 'b', userIconPath: '', body: 'second');

    final firstCommentId = container.read(postNotifierProvider('post-1')).comments.first.id;
    notifier.deleteComment(firstCommentId);

    final updated = container.read(postNotifierProvider('post-1'));
    expect(updated.comments, hasLength(1));
    expect(updated.comments.first.body, 'second');
  });

  test('reorderCommentはReorderableListViewの規約通りに並び替える', () {
    seedPost();
    final notifier = container.read(postNotifierProvider('post-1').notifier);
    notifier.addComment(userName: 'a', userIconPath: '', body: 'first');
    notifier.addComment(userName: 'b', userIconPath: '', body: 'second');
    notifier.addComment(userName: 'c', userIconPath: '', body: 'third');

    notifier.reorderComment(0, 3);

    final updated = container.read(postNotifierProvider('post-1'));
    expect(updated.comments.map((c) => c.body), ['second', 'third', 'first']);
    expect(
      Hive.box<Post>(HiveBoxes.postBoxName).get('post-1')!.comments.map((c) => c.body),
      ['second', 'third', 'first'],
    );
  });

  test('updateCaptionはキャプションを更新する', () {
    seedPost();
    final notifier = container.read(postNotifierProvider('post-1').notifier);
    notifier.updateCaption('新しいキャプション');

    expect(container.read(postNotifierProvider('post-1')).caption, '新しいキャプション');
  });
}
