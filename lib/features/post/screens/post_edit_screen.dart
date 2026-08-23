import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/image_picker_field.dart';
import '../../../data/hive/models/comment.dart';
import '../providers/post_notifier.dart';
import '../widgets/comment_edit_dialog.dart';
import '../widgets/comment_tile.dart';
import 'post_preview_screen.dart';

class PostEditScreen extends ConsumerStatefulWidget {
  const PostEditScreen({super.key, required this.postId});

  final String postId;

  @override
  ConsumerState<PostEditScreen> createState() => _PostEditScreenState();
}

class _PostEditScreenState extends ConsumerState<PostEditScreen> {
  late final TextEditingController _captionController;
  late final TextEditingController _likeCountController;
  late final TextEditingController _userNameController;
  late final TextEditingController _postedAtLabelController;

  @override
  void initState() {
    super.initState();
    final post = ref.read(postNotifierProvider(widget.postId));
    _captionController = TextEditingController(text: post.caption);
    _likeCountController = TextEditingController(text: post.likeCount.toString());
    _userNameController = TextEditingController(text: post.userName);
    _postedAtLabelController = TextEditingController(text: post.postedAtLabel);
  }

  @override
  void dispose() {
    _captionController.dispose();
    _likeCountController.dispose();
    _userNameController.dispose();
    _postedAtLabelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = ref.watch(postNotifierProvider(widget.postId));
    final notifier = ref.read(postNotifierProvider(widget.postId).notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿を編集'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => PostPreviewScreen(postId: widget.postId)),
              );
            },
            child: const Text('プレビュー'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: ImagePickerField(
              imagePath: post.imagePath,
              width: 200,
              height: 200,
              shape: BoxShape.rectangle,
              onImagePicked: notifier.updateImage,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              ImagePickerField(
                imagePath: post.userIconPath,
                onImagePicked: notifier.updateUserIconPath,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _userNameController,
                  decoration: const InputDecoration(labelText: '投稿者名'),
                  onChanged: notifier.updateUserName,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _captionController,
            decoration: const InputDecoration(labelText: 'キャプション'),
            maxLines: 3,
            onChanged: notifier.updateCaption,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _likeCountController,
            decoration: const InputDecoration(labelText: 'いいね数'),
            keyboardType: TextInputType.number,
            onChanged: (value) => notifier.updateLikeCount(int.tryParse(value) ?? 0),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _postedAtLabelController,
            decoration: const InputDecoration(labelText: '投稿時間ラベル(例: 3時間前)'),
            onChanged: notifier.updatePostedAtLabel,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('コメント', style: TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showCommentDialog(notifier),
              ),
            ],
          ),
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: notifier.reorderComment,
            children: [
              for (final comment in post.comments)
                CommentTile(
                  key: ValueKey(comment.id),
                  comment: comment,
                  onEdit: () => _showCommentDialog(notifier, comment: comment),
                  onDelete: () => notifier.deleteComment(comment.id),
                  showDragHandle: true,
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCommentDialog(PostNotifier notifier, {Comment? comment}) {
    showDialog<void>(
      context: context,
      builder: (_) => CommentEditDialog(
        initial: comment,
        onSave: ({required userName, required userIconPath, required body}) {
          if (comment == null) {
            notifier.addComment(userName: userName, userIconPath: userIconPath, body: body);
          } else {
            notifier.updateComment(comment.id, userName: userName, userIconPath: userIconPath, body: body);
          }
        },
      ),
    );
  }
}
