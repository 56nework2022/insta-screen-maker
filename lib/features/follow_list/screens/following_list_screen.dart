import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/named_avatar_tile.dart';
import '../../profile/providers/profile_notifier.dart';

class FollowingListScreen extends ConsumerWidget {
  const FollowingListScreen({super.key, required this.profileId});

  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileNotifierProvider(profileId));
    final following = profile.followUsers.where((u) => u.listType == 'following').toList();

    return Scaffold(
      appBar: AppBar(title: const Text('フォロー中')),
      body: ListView(
        children: [
          for (final user in following)
            NamedAvatarTile(
              name: user.name,
              iconPath: user.iconPath,
              avatarRadius: 32,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              titleStyle: const TextStyle(fontSize: 18),
            ),
        ],
      ),
    );
  }
}
