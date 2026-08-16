import 'package:flutter/material.dart';

import '../../../core/widgets/image_picker_field.dart';
import '../../../data/hive/models/comment.dart';

typedef CommentSaveCallback = void Function({
  required String userName,
  required String userIconPath,
  required String body,
});

class CommentEditDialog extends StatefulWidget {
  const CommentEditDialog({super.key, this.initial, required this.onSave});

  final Comment? initial;
  final CommentSaveCallback onSave;

  @override
  State<CommentEditDialog> createState() => _CommentEditDialogState();
}

class _CommentEditDialogState extends State<CommentEditDialog> {
  late final _userNameController = TextEditingController(text: widget.initial?.userName ?? '');
  late final _bodyController = TextEditingController(text: widget.initial?.body ?? '');
  late String _userIconPath = widget.initial?.userIconPath ?? '';

  @override
  void dispose() {
    _userNameController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initial == null ? 'コメントを追加' : 'コメントを編集'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: ImagePickerField(
              imagePath: _userIconPath,
              onImagePicked: (path) => setState(() => _userIconPath = path),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _userNameController,
            decoration: const InputDecoration(labelText: 'ユーザー名'),
          ),
          TextField(
            controller: _bodyController,
            decoration: const InputDecoration(labelText: 'コメント本文'),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        FilledButton(
          onPressed: () {
            widget.onSave(
              userName: _userNameController.text,
              userIconPath: _userIconPath,
              body: _bodyController.text,
            );
            Navigator.of(context).pop();
          },
          child: const Text('保存'),
        ),
      ],
    );
  }
}
