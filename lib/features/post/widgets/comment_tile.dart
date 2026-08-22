import 'package:flutter/material.dart';

import '../../../core/widgets/confirm_delete_dialog.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../../data/hive/models/comment.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({
    super.key,
    required this.comment,
    this.onEdit,
    this.onDelete,
  });

  final Comment comment;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserAvatar(iconPath: comment.userIconPath, radius: 16),
      title: Text.rich(
        TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: '${comment.userName}  ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: comment.body),
          ],
        ),
      ),
      trailing: onEdit == null && onDelete == null
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onEdit != null)
                  IconButton(icon: const Icon(Icons.edit, size: 18), onPressed: onEdit),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    onPressed: () async {
                      final confirmed = await confirmDelete(
                        context,
                        message: 'このコメントを削除しますか?',
                      );
                      if (confirmed) onDelete!();
                    },
                  ),
              ],
            ),
    );
  }
}
