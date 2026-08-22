import 'dart:io';

import 'package:flutter/material.dart';

class PostThumbnailGrid extends StatelessWidget {
  const PostThumbnailGrid({
    super.key,
    required this.paths,
    this.shrinkWrap = false,
    this.physics,
    this.childAspectRatio = 1,
  });

  final List<String> paths;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      shrinkWrap: shrinkWrap,
      physics: physics,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: paths.length,
      itemBuilder: (context, index) {
        return Image.file(
          File(paths[index]),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const _BrokenThumbnail(),
        );
      },
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
