import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../core/utils/id_generator.dart';
import '../../../data/hive/hive_boxes.dart';
import '../../../data/hive/models/profile.dart';

class ProfileListNotifier extends Notifier<List<Profile>> {
  Box<Profile> get _box => Hive.box<Profile>(HiveBoxes.profileBoxName);

  @override
  List<Profile> build() => _box.values.toList();

  Profile createProfile() {
    final profile = Profile(
      id: IdGenerator.generate(),
      name: '',
      iconPath: '',
      bio: '',
    );
    _box.put(profile.id, profile);
    refresh();
    return profile;
  }

  void deleteProfile(String id) {
    _box.delete(id);
    refresh();
  }

  void refresh() {
    state = _box.values.toList();
  }
}

final profileListProvider = NotifierProvider<ProfileListNotifier, List<Profile>>(
  ProfileListNotifier.new,
);
