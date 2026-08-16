import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/user_avatar.dart';
import '../providers/story_notifier.dart';
import '../widgets/progress_bar.dart';

class StoryPreviewScreen extends ConsumerStatefulWidget {
  const StoryPreviewScreen({super.key, required this.storyGroupId});

  final String storyGroupId;

  @override
  ConsumerState<StoryPreviewScreen> createState() => _StoryPreviewScreenState();
}

class _StoryPreviewScreenState extends ConsumerState<StoryPreviewScreen> {
  int _currentIndex = 0;

  void _goToNext(int imageCount) {
    if (_currentIndex >= imageCount - 1) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _currentIndex += 1);
  }

  @override
  Widget build(BuildContext context) {
    final storyGroup = ref.watch(storyNotifierProvider(widget.storyGroupId));
    final images = storyGroup.images;

    if (images.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text('画像がありません', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    final index = _currentIndex.clamp(0, images.length - 1);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          key: const Key('story-tap-area'),
          behavior: HitTestBehavior.opaque,
          onTap: () => _goToNext(images.length),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.file(File(images[index].imagePath), fit: BoxFit.contain),
              ),
              Positioned(
                top: 8,
                left: 8,
                right: 8,
                child: StoryProgressBar(itemCount: images.length, currentIndex: index),
              ),
              Positioned(
                top: 20,
                left: 8,
                right: 8,
                child: Row(
                  children: [
                    UserAvatar(iconPath: storyGroup.ownerIconPath, radius: 16),
                    const SizedBox(width: 8),
                    Text(
                      storyGroup.ownerName,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
