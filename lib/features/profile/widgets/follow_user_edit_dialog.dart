import 'package:flutter/material.dart';

import '../../../core/widgets/image_picker_field.dart';
import '../../../data/hive/models/follow_user.dart';

typedef FollowUserSaveCallback = void Function({required String name, required String iconPath});

class FollowUserEditDialog extends StatefulWidget {
  const FollowUserEditDialog({
    super.key,
    required this.title,
    this.initial,
    required this.onSave,
  });

  final String title;
  final FollowUser? initial;
  final FollowUserSaveCallback onSave;

  @override
  State<FollowUserEditDialog> createState() => _FollowUserEditDialogState();
}

class _FollowUserEditDialogState extends State<FollowUserEditDialog> {
  late final _nameController = TextEditingController(text: widget.initial?.name ?? '');
  late String _iconPath = widget.initial?.iconPath ?? '';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: ImagePickerField(
              imagePath: _iconPath,
              onImagePicked: (path) => setState(() => _iconPath = path),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: '名前'),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('キャンセル')),
        FilledButton(
          onPressed: () {
            widget.onSave(name: _nameController.text, iconPath: _iconPath);
            Navigator.of(context).pop();
          },
          child: const Text('保存'),
        ),
      ],
    );
  }
}
