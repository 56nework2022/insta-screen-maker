import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../core/utils/id_generator.dart';
import '../../../data/hive/hive_boxes.dart';
import '../../../data/hive/models/follow_user.dart';
import '../../../data/hive/models/profile.dart';

class ProfileNotifier extends FamilyNotifier<Profile, String> {
  Box<Profile> get _box => Hive.box<Profile>(HiveBoxes.profileBoxName);

  @override
  Profile build(String arg) => _box.get(arg)!;

  void _update(Profile updated) {
    _box.put(updated.id, updated);
    state = updated;
  }

  void updateName(String name) => _update(state.copyWith(name: name));

  void updateIconPath(String iconPath) => _update(state.copyWith(iconPath: iconPath));

  void updateBio(String bio) => _update(state.copyWith(bio: bio));

  void updatePostCount(int postCount) => _update(state.copyWith(postCount: postCount));

  void updateFollowerCount(String followerCount) => _update(state.copyWith(followerCount: followerCount));

  void updateFollowingCount(String followingCount) => _update(state.copyWith(followingCount: followingCount));

  void addPostThumbnail(String imagePath) {
    _update(state.copyWith(postThumbnailPaths: [...state.postThumbnailPaths, imagePath]));
  }

  void removePostThumbnail(String imagePath) {
    final paths = state.postThumbnailPaths.where((path) => path != imagePath).toList();
    _update(state.copyWith(postThumbnailPaths: paths));
  }

  void addFollowUser({required String listType, required String name, required String iconPath}) {
    final followUser = FollowUser(
      id: IdGenerator.generate(),
      listType: listType,
      name: name,
      iconPath: iconPath,
    );
    _update(state.copyWith(followUsers: [...state.followUsers, followUser]));
  }

  void updateFollowUser(String id, {String? name, String? iconPath}) {
    final followUsers = state.followUsers
        .map((u) => u.id == id ? u.copyWith(name: name, iconPath: iconPath) : u)
        .toList();
    _update(state.copyWith(followUsers: followUsers));
  }

  void deleteFollowUser(String id) {
    final followUsers = state.followUsers.where((u) => u.id != id).toList();
    _update(state.copyWith(followUsers: followUsers));
  }
}

final profileNotifierProvider = NotifierProvider.family<ProfileNotifier, Profile, String>(
  ProfileNotifier.new,
);
