import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/confirm_delete_dialog.dart';
import '../../../core/widgets/image_picker_field.dart';
import '../providers/story_notifier.dart';
import 'story_preview_screen.dart';

class StoryEditScreen extends ConsumerStatefulWidget {
  const StoryEditScreen({super.key, required this.storyGroupId});

  final String storyGroupId;

  @override
  ConsumerState<StoryEditScreen> createState() => _StoryEditScreenState();
}

class _StoryEditScreenState extends ConsumerState<StoryEditScreen> {
  late final TextEditingController _ownerNameController;

  @override
  void initState() {
    super.initState();
    final storyGroup = ref.read(storyNotifierProvider(widget.storyGroupId));
    _ownerNameController = TextEditingController(text: storyGroup.ownerName);
  }

  @override
  void dispose() {
    _ownerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storyGroup = ref.watch(storyNotifierProvider(widget.storyGroupId));
    final notifier = ref.read(storyNotifierProvider(widget.storyGroupId).notifier);
    final images = storyGroup.images;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ストーリーズを編集'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) => StoryPreviewScreen(storyGroupId: widget.storyGroupId),
                ),
              );
            },
            child: const Text('プレビュー'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              ImagePickerField(
                imagePath: storyGroup.ownerIconPath,
                onImagePicked: notifier.updateOwnerIconPath,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _ownerNameController,
                  decoration: const InputDecoration(labelText: '所有者名'),
                  onChanged: notifier.updateOwnerName,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('画像(ドラッグで順序変更)', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: notifier.reorderImage,
            children: [
              for (final image in images)
                ListTile(
                  key: ValueKey(image.id),
                  leading: Image.file(File(image.imagePath), width: 48, height: 48, fit: BoxFit.cover),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      final confirmed = await confirmDelete(
                        context,
                        message: 'この画像を削除しますか?',
                      );
                      if (confirmed) notifier.removeImage(image.id);
                    },
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: ImagePickerField(
              imagePath: '',
              shape: BoxShape.rectangle,
              onImagePicked: notifier.addImage,
            ),
          ),
        ],
      ),
    );
  }
}
