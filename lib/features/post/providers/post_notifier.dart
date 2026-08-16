import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../core/utils/id_generator.dart';
import '../../../data/hive/hive_boxes.dart';
import '../../../data/hive/models/comment.dart';
import '../../../data/hive/models/post.dart';

class PostNotifier extends FamilyNotifier<Post, String> {
  Box<Post> get _box => Hive.box<Post>(HiveBoxes.postBoxName);

  @override
  Post build(String arg) => _box.get(arg)!;

  void _update(Post updated) {
    _box.put(updated.id, updated);
    state = updated;
  }

  void updateImage(String imagePath) => _update(state.copyWith(imagePath: imagePath));

  void updateCaption(String caption) => _update(state.copyWith(caption: caption));

  void updateLikeCount(int likeCount) => _update(state.copyWith(likeCount: likeCount));

  void toggleLike() {
    _update(state.copyWith(
      isLiked: !state.isLiked,
      likeCount: state.isLiked ? state.likeCount - 1 : state.likeCount + 1,
    ));
  }

  void updateUserName(String userName) => _update(state.copyWith(userName: userName));

  void updateUserIconPath(String userIconPath) => _update(state.copyWith(userIconPath: userIconPath));

  void updatePostedAtLabel(String postedAtLabel) => _update(state.copyWith(postedAtLabel: postedAtLabel));

  void addComment({required String userName, required String userIconPath, required String body}) {
    final comment = Comment(
      id: IdGenerator.generate(),
      userName: userName,
      userIconPath: userIconPath,
      body: body,
    );
    _update(state.copyWith(comments: [...state.comments, comment]));
  }

  void updateComment(String commentId, {String? userName, String? userIconPath, String? body}) {
    final comments = state.comments
        .map((c) => c.id == commentId
            ? c.copyWith(userName: userName, userIconPath: userIconPath, body: body)
            : c)
        .toList();
    _update(state.copyWith(comments: comments));
  }

  void deleteComment(String commentId) {
    final comments = state.comments.where((c) => c.id != commentId).toList();
    _update(state.copyWith(comments: comments));
  }
}

final postNotifierProvider = NotifierProvider.family<PostNotifier, Post, String>(
  PostNotifier.new,
);
