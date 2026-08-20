import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../follow_list/screens/follower_list_screen.dart';
import '../../follow_list/screens/following_list_screen.dart';
import '../providers/profile_notifier.dart';
import '../widgets/post_thumbnail_grid.dart';

class ProfilePreviewScreen extends ConsumerWidget {
  const ProfilePreviewScreen({super.key, required this.profileId});

  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileNotifierProvider(profileId));
    final postCount = profile.postThumbnailPaths.length;
    final followerCount = profile.followUsers.where((u) => u.listType == 'follower').length;
    final followingCount = profile.followUsers.where((u) => u.listType == 'following').length;

    return Scaffold(
      appBar: AppBar(title: Text(profile.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              UserAvatar(iconPath: profile.iconPath, radius: 40),
              const SizedBox(width: 24),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatColumn(
                      label: '投稿',
                      count: postCount,
                    ),
                    _StatColumn(
                      label: 'フォロワー',
                      count: followerCount,
                      onTap: () => Navigator.of(context).push<void>(
                        MaterialPageRoute(builder: (_) => FollowerListScreen(profileId: profileId)),
                      ),
                    ),
                    _StatColumn(
                      label: 'フォロー',
                      count: followingCount,
                      onTap: () => Navigator.of(context).push<void>(
                        MaterialPageRoute(builder: (_) => FollowingListScreen(profileId: profileId)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(profile.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (profile.bio.isNotEmpty) Text(profile.bio),
          const SizedBox(height: 16),
          if (postCount == 0)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text('まだ投稿がありません', style: TextStyle(color: AppColors.secondaryText)),
              ),
            )
          else
            PostThumbnailGrid(
              paths: profile.postThumbnailPaths,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.label, required this.count, this.onTap});

  final String label;
  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        Text('$count', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: AppColors.secondaryText, fontSize: 12)),
      ],
    );

    if (onTap == null) {
      return content;
    }

    return GestureDetector(onTap: onTap, child: content);
  }
}
