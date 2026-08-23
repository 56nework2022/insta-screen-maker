import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/user_avatar.dart';
import '../providers/post_notifier.dart';
import '../widgets/comment_tile.dart';
import '../widgets/like_button.dart';

class PostPreviewScreen extends ConsumerStatefulWidget {
  const PostPreviewScreen({super.key, required this.postId});

  final String postId;

  @override
  ConsumerState<PostPreviewScreen> createState() => _PostPreviewScreenState();
}

class _PostPreviewScreenState extends ConsumerState<PostPreviewScreen> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = ref.watch(postNotifierProvider(widget.postId));
    final notifier = ref.read(postNotifierProvider(widget.postId).notifier);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 8,
        title: Row(
          children: [
            UserAvatar(iconPath: post.userIconPath, radius: 14),
            const SizedBox(width: 8),
            Text(
              post.userName,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: const [Icon(Icons.more_vert), SizedBox(width: 12)],
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if ((details.primaryVelocity ?? 0) > 300) {
            Navigator.of(context).pop();
          }
        },
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: post.imagePath.isEmpty
                        ? Container(color: Colors.grey.shade200)
                        : Image.file(File(post.imagePath), fit: BoxFit.cover),
                  ),
                  Row(
                    children: [
                      LikeButton(
                        isLiked: post.isLiked,
                        onTap: notifier.toggleLike,
                      ),
                      const Icon(Icons.mode_comment_outlined),
                      const SizedBox(width: 16),
                      const Icon(Icons.send_outlined),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Icon(Icons.bookmark_border),
                      ),
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
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
                    child: Text.rich(
                      TextSpan(
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
                  for (final comment in post.comments)
                    CommentTile(comment: comment),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                    child: Text(
                      post.postedAtLabel,
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    UserAvatar(iconPath: post.userIconPath, radius: 14),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          hintText: 'コメントを追加...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        final body = _commentController.text.trim();
                        if (body.isEmpty) return;
                        notifier.addComment(
                          userName: post.userName,
                          userIconPath: post.userIconPath,
                          body: body,
                        );
                        _commentController.clear();
                      },
                      child: const Text('投稿'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
