import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/user_avatar.dart';
import '../../post/providers/post_list_provider.dart';
import '../../post/providers/post_notifier.dart';
import '../../post/widgets/like_button.dart';
import '../../story/providers/story_list_provider.dart';
import '../../story/screens/story_preview_screen.dart';
import '../providers/feed_notifier.dart';
import '../utils/feed_resolver.dart';
import '../widgets/story_ring.dart';

class FeedPreviewScreen extends ConsumerWidget {
  const FeedPreviewScreen({super.key, required this.feedId});

  final String feedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feed = ref.watch(feedNotifierProvider(feedId));
    final allPosts = ref.watch(postListProvider);
    final allStoryGroups = ref.watch(storyListProvider);

    final visiblePosts = FeedResolver.resolvePosts(feed.postIds, allPosts);
    final visibleStoryGroups = FeedResolver.resolveStoryGroups(
      feed.storyGroupIds,
      allStoryGroups,
    );

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if ((details.primaryVelocity ?? 0) > 300) {
            Navigator.of(context).pop();
          }
        },
        child: ListView(
          children: [
            if (visibleStoryGroups.isNotEmpty)
              SizedBox(
                height: 116,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: [
                    for (final storyGroup in visibleStoryGroups)
                      StoryRing(
                        name: storyGroup.ownerName,
                        iconPath: storyGroup.ownerIconPath,
                        onTap: () => Navigator.of(context).push<void>(
                          MaterialPageRoute(
                            builder: (_) =>
                                StoryPreviewScreen(storyGroupId: storyGroup.id),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            const Divider(height: 1),
            for (final post in visiblePosts) _FeedPostTile(postId: post.id),
          ],
        ),
      ),
    );
  }
}

class _FeedPostTile extends ConsumerWidget {
  const _FeedPostTile({required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(postNotifierProvider(postId));
    final notifier = ref.read(postNotifierProvider(postId).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              UserAvatar(iconPath: post.userIconPath, radius: 16),
              const SizedBox(width: 8),
              Text(
                post.userName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        AspectRatio(
          aspectRatio: 1,
          child: post.imagePath.isEmpty
              ? Container(color: Colors.grey.shade200)
              : Image.file(File(post.imagePath), fit: BoxFit.cover),
        ),
        Row(
          children: [
            LikeButton(isLiked: post.isLiked, onTap: notifier.toggleLike),
            const Icon(Icons.mode_comment_outlined),
            const SizedBox(width: 16),
            const Icon(Icons.send_outlined),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '${post.likeCount} 件のいいね',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
          child: Text.rich(
            TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: '${post.userName}  ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: post.caption),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
