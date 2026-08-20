import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/profile_notifier.dart';
import '../widgets/post_thumbnail_grid.dart';

class PostGridScreen extends ConsumerWidget {
  const PostGridScreen({super.key, required this.profileId});

  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileNotifierProvider(profileId));

    return Scaffold(
      appBar: AppBar(title: Text('${profile.name}の投稿')),
      body: PostThumbnailGrid(paths: profile.postThumbnailPaths),
    );
  }
}
