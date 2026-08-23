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
    final thumbnailCount = profile.postThumbnailPaths.length;
    final followerCount = profile.followerCount;
    final followingCount = profile.followingCount;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          profile.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if ((details.primaryVelocity ?? 0) > 300) {
            Navigator.of(context).pop();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          count: profile.postCount.toString(),
                        ),
                        _StatColumn(
                          label: 'フォロワー',
                          count: followerCount,
                          onTap: () => Navigator.of(context).push<void>(
                            MaterialPageRoute(
                              builder: (_) =>
                                  FollowerListScreen(profileId: profileId),
                            ),
                          ),
                        ),
                        _StatColumn(
                          label: 'フォロー',
                          count: followingCount,
                          onTap: () => Navigator.of(context).push<void>(
                            MaterialPageRoute(
                              builder: (_) =>
                                  FollowingListScreen(profileId: profileId),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                profile.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (profile.bio.isNotEmpty) Text(profile.bio),
              const SizedBox(height: 16),
              Expanded(
                child: thumbnailCount == 0
                    ? const Center(
                        child: Text(
                          'まだ投稿がありません',
                          style: TextStyle(color: AppColors.secondaryText),
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          // 3行×3列(9枚)でグリッド領域がちょうど埋まるようセル比率を算出する。
                          const rows = 3;
                          const spacing = 2.0;
                          final cellHeight =
                              ((constraints.maxHeight - spacing * (rows - 1)) /
                                      rows)
                                  .clamp(20.0, double.infinity);
                          final cellWidth =
                              (constraints.maxWidth - spacing * 2) / 3;
                          return PostThumbnailGrid(
                            paths: profile.postThumbnailPaths,
                            childAspectRatio: cellWidth / cellHeight,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.label, required this.count, this.onTap});

  final String label;
  final String count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: const TextStyle(color: AppColors.secondaryText, fontSize: 12),
        ),
      ],
    );

    if (onTap == null) {
      return content;
    }

    return GestureDetector(onTap: onTap, child: content);
  }
}
