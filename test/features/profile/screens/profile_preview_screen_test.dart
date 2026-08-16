import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:insta_screen_maker/data/hive/hive_boxes.dart';
import 'package:insta_screen_maker/data/hive/models/follow_user.dart';
import 'package:insta_screen_maker/data/hive/models/profile.dart';
import 'package:insta_screen_maker/features/profile/screens/profile_preview_screen.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('profile_preview_screen_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(ProfileAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(FollowUserAdapter());
    await Hive.openBox<Profile>(HiveBoxes.profileBoxName);

    final profile = Profile(
      id: 'profile-1',
      name: 'taro',
      iconPath: '',
      bio: 'よろしくお願いします',
      followUsers: [
        FollowUser(id: 'f1', listType: 'follower', name: 'hanako', iconPath: ''),
        FollowUser(id: 'f2', listType: 'follower', name: 'saburo', iconPath: ''),
        FollowUser(id: 'f3', listType: 'following', name: 'jiro', iconPath: ''),
      ],
    );
    Hive.box<Profile>(HiveBoxes.profileBoxName).put(profile.id, profile);
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  testWidgets('プロフィール情報とフォロワー/フォロー数が表示される', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: ProfilePreviewScreen(profileId: 'profile-1')),
      ),
    );

    expect(find.text('taro'), findsWidgets);
    expect(find.text('よろしくお願いします'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('フォロワー'), findsOneWidget);
    expect(find.text('フォロー'), findsOneWidget);
  });
}
