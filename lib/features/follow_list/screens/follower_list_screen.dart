import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/named_avatar_tile.dart';
import '../../profile/providers/profile_notifier.dart';

class FollowerListScreen extends ConsumerWidget {
  const FollowerListScreen({super.key, required this.profileId});

  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileNotifierProvider(profileId));
    final followers = profile.followUsers.where((u) => u.listType == 'follower').toList();

    return Scaffold(
      appBar: AppBar(title: const Text('フォロワー')),
      body: ListView(
        children: [
          for (final user in followers) NamedAvatarTile(name: user.name, iconPath: user.iconPath),
        ],
      ),
    );
  }
}
