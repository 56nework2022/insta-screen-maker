import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:insta_screen_maker/data/hive/hive_boxes.dart';
import 'package:insta_screen_maker/data/hive/models/follow_user.dart';
import 'package:insta_screen_maker/data/hive/models/profile.dart';
import 'package:insta_screen_maker/features/profile/providers/profile_notifier.dart';

void main() {
  late Directory tempDir;
  late ProviderContainer container;

  Profile seedProfile() {
    final profile = Profile(id: 'profile-1', name: 'taro', iconPath: '', bio: 'よろしく');
    Hive.box<Profile>(HiveBoxes.profileBoxName).put(profile.id, profile);
    return profile;
  }

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('profile_notifier_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(ProfileAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(FollowUserAdapter());
    await Hive.openBox<Profile>(HiveBoxes.profileBoxName);
    container = ProviderContainer();
  });

  tearDown(() async {
    container.dispose();
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  test('addFollowUserはlistTypeごとに一覧へ追加し永続化する', () {
    seedProfile();
    final notifier = container.read(profileNotifierProvider('profile-1').notifier);

    notifier.addFollowUser(listType: 'follower', name: 'hanako', iconPath: '');
    notifier.addFollowUser(listType: 'following', name: 'jiro', iconPath: '');

    final updated = container.read(profileNotifierProvider('profile-1'));
    expect(updated.followUsers.where((u) => u.listType == 'follower'), hasLength(1));
    expect(updated.followUsers.where((u) => u.listType == 'following'), hasLength(1));
    expect(Hive.box<Profile>(HiveBoxes.profileBoxName).get('profile-1')!.followUsers, hasLength(2));
  });

  test('deleteFollowUserは指定したユーザーのみ削除する', () {
    seedProfile();
    final notifier = container.read(profileNotifierProvider('profile-1').notifier);
    notifier.addFollowUser(listType: 'follower', name: 'a', iconPath: '');
    notifier.addFollowUser(listType: 'follower', name: 'b', iconPath: '');

    final targetId = container.read(profileNotifierProvider('profile-1')).followUsers.first.id;
    notifier.deleteFollowUser(targetId);

    final updated = container.read(profileNotifierProvider('profile-1'));
    expect(updated.followUsers, hasLength(1));
    expect(updated.followUsers.first.name, 'b');
  });

  test('addPostThumbnail/removePostThumbnailはサムネイル一覧を更新する', () {
    seedProfile();
    final notifier = container.read(profileNotifierProvider('profile-1').notifier);

    notifier.addPostThumbnail('/tmp/a.png');
    notifier.addPostThumbnail('/tmp/b.png');
    expect(container.read(profileNotifierProvider('profile-1')).postThumbnailPaths, hasLength(2));

    notifier.removePostThumbnail('/tmp/a.png');
    final updated = container.read(profileNotifierProvider('profile-1'));
    expect(updated.postThumbnailPaths, ['/tmp/b.png']);
  });
}
