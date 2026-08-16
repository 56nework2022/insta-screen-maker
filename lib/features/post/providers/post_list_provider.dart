import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../core/utils/id_generator.dart';
import '../../../data/hive/hive_boxes.dart';
import '../../../data/hive/models/post.dart';

class PostListNotifier extends Notifier<List<Post>> {
  Box<Post> get _box => Hive.box<Post>(HiveBoxes.postBoxName);

  @override
  List<Post> build() => _box.values.toList();

  Post createPost() {
    final post = Post(
      id: IdGenerator.generate(),
      imagePath: '',
      caption: '',
      likeCount: 0,
      isLiked: false,
      userName: '',
      userIconPath: '',
      postedAtLabel: '',
    );
    _box.put(post.id, post);
    refresh();
    return post;
  }

  void deletePost(String id) {
    _box.delete(id);
    refresh();
  }

  void refresh() {
    state = _box.values.toList();
  }
}

final postListProvider = NotifierProvider<PostListNotifier, List<Post>>(
  PostListNotifier.new,
);
