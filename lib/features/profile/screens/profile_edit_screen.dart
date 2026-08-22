import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/confirm_delete_dialog.dart';
import '../../../core/widgets/image_picker_field.dart';
import '../../../core/widgets/named_avatar_tile.dart';
import '../../../data/hive/models/follow_user.dart';
import '../providers/profile_notifier.dart';
import '../widgets/follow_user_edit_dialog.dart';
import 'profile_preview_screen.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key, required this.profileId});

  final String profileId;

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileNotifierProvider(widget.profileId));
    _nameController = TextEditingController(text: profile.name);
    _bioController = TextEditingController(text: profile.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileNotifierProvider(widget.profileId));
    final notifier = ref.read(profileNotifierProvider(widget.profileId).notifier);

    final followers = profile.followUsers.where((u) => u.listType == 'follower').toList();
    final following = profile.followUsers.where((u) => u.listType == 'following').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィールを編集'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => ProfilePreviewScreen(profileId: widget.profileId)),
              );
            },
            child: const Text('プレビュー'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: ImagePickerField(
              imagePath: profile.iconPath,
              onImagePicked: notifier.updateIconPath,
              width: 96,
              height: 96,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: '名前'),
            onChanged: notifier.updateName,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _bioController,
            decoration: const InputDecoration(labelText: '自己紹介'),
            maxLines: 3,
            onChanged: notifier.updateBio,
          ),
          const SizedBox(height: 24),
          const Text('投稿サムネイル', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final path in profile.postThumbnailPaths)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(path),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.shade200,
                          child: Icon(Icons.broken_image, color: Colors.grey.shade500),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => notifier.removePostThumbnail(path),
                        child: const CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.black54,
                          child: Icon(Icons.close, size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ImagePickerField(
                imagePath: '',
                shape: BoxShape.rectangle,
                width: 80,
                height: 80,
                onImagePicked: notifier.addPostThumbnail,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _FollowUserSection(
            title: 'フォロワー',
            users: followers,
            onAdd: () => _showFollowUserDialog(notifier, listType: 'follower'),
            onEdit: (user) => _showFollowUserDialog(notifier, listType: 'follower', initial: user),
            onDelete: (user) => notifier.deleteFollowUser(user.id),
          ),
          const SizedBox(height: 16),
          _FollowUserSection(
            title: 'フォロー',
            users: following,
            onAdd: () => _showFollowUserDialog(notifier, listType: 'following'),
            onEdit: (user) => _showFollowUserDialog(notifier, listType: 'following', initial: user),
            onDelete: (user) => notifier.deleteFollowUser(user.id),
          ),
        ],
      ),
    );
  }

  void _showFollowUserDialog(ProfileNotifier notifier, {required String listType, FollowUser? initial}) {
    showDialog<void>(
      context: context,
      builder: (_) => FollowUserEditDialog(
        title: initial == null ? '追加' : '編集',
        initial: initial,
        onSave: ({required name, required iconPath}) {
          if (initial == null) {
            notifier.addFollowUser(listType: listType, name: name, iconPath: iconPath);
          } else {
            notifier.updateFollowUser(initial.id, name: name, iconPath: iconPath);
          }
        },
      ),
    );
  }
}

class _FollowUserSection extends StatelessWidget {
  const _FollowUserSection({
    required this.title,
    required this.users,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final String title;
  final List<FollowUser> users;
  final VoidCallback onAdd;
  final ValueChanged<FollowUser> onEdit;
  final ValueChanged<FollowUser> onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            IconButton(icon: const Icon(Icons.add), onPressed: onAdd),
          ],
        ),
        for (final user in users)
          NamedAvatarTile(
            name: user.name,
            iconPath: user.iconPath,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit, size: 18), onPressed: () => onEdit(user)),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  onPressed: () async {
                    final confirmed = await confirmDelete(
                      context,
                      message: '「${user.name}」を削除しますか?',
                    );
                    if (confirmed) onDelete(user);
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
