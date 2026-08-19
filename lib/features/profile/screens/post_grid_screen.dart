import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/profile_notifier.dart';

class PostGridScreen extends ConsumerWidget {
  const PostGridScreen({super.key, required this.profileId});

  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileNotifierProvider(profileId));

    return Scaffold(
      appBar: AppBar(title: Text('${profile.name}の投稿')),
      body: GridView.builder(
        padding: const EdgeInsets.all(2),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemCount: profile.postThumbnailPaths.length,
        itemBuilder: (context, index) {
          return Image.file(
            File(profile.postThumbnailPaths[index]),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const _BrokenThumbnail(),
          );
        },
      ),
    );
  }
}

class _BrokenThumbnail extends StatelessWidget {
  const _BrokenThumbnail();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Icon(Icons.broken_image, color: Colors.grey.shade500),
    );
  }
}
