import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/user_avatar.dart';
import '../../post/providers/post_list_provider.dart';
import '../../story/providers/story_list_provider.dart';
import '../providers/feed_notifier.dart';
import '../utils/feed_resolver.dart';
import 'feed_preview_screen.dart';

class FeedEditScreen extends ConsumerStatefulWidget {
  const FeedEditScreen({super.key, required this.feedId});

  final String feedId;

  @override
  ConsumerState<FeedEditScreen> createState() => _FeedEditScreenState();
}

class _FeedEditScreenState extends ConsumerState<FeedEditScreen> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final feed = ref.read(feedNotifierProvider(widget.feedId));
    _nameController = TextEditingController(text: feed.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feed = ref.watch(feedNotifierProvider(widget.feedId));
    final notifier = ref.read(feedNotifierProvider(widget.feedId).notifier);
    final allPosts = ref.watch(postListProvider);
    final allStoryGroups = ref.watch(storyListProvider);

    final selectedPosts = FeedResolver.resolvePosts(feed.postIds, allPosts);
    final unselectedPosts = allPosts.where((p) => !feed.postIds.contains(p.id)).toList();

    final selectedStoryGroups = FeedResolver.resolveStoryGroups(feed.storyGroupIds, allStoryGroups);
    final unselectedStoryGroups =
        allStoryGroups.where((s) => !feed.storyGroupIds.contains(s.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('フィードを編集'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => FeedPreviewScreen(feedId: widget.feedId)),
              );
            },
            child: const Text('プレビュー'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'フィード名'),
            onChanged: notifier.updateName,
          ),
          const SizedBox(height: 24),
          const Text('ストーリーズ(選択中・ドラッグで順序変更)', style: TextStyle(fontWeight: FontWeight.bold)),
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: notifier.reorderStoryGroup,
            children: [
              for (final storyGroup in selectedStoryGroups)
                ListTile(
                  key: ValueKey(storyGroup.id),
                  leading: UserAvatar(iconPath: storyGroup.ownerIconPath, radius: 16),
                  title: Text(storyGroup.ownerName),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => notifier.removeStoryGroup(storyGroup.id),
                  ),
                ),
            ],
          ),
          if (unselectedStoryGroups.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text('追加できるストーリーズ', style: TextStyle(color: Colors.grey)),
            for (final storyGroup in unselectedStoryGroups)
              ListTile(
                leading: UserAvatar(iconPath: storyGroup.ownerIconPath, radius: 16),
                title: Text(storyGroup.ownerName),
                trailing: IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => notifier.addStoryGroup(storyGroup.id),
                ),
              ),
          ],
          const SizedBox(height: 24),
          const Text('投稿(選択中・ドラッグで順序変更)', style: TextStyle(fontWeight: FontWeight.bold)),
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: notifier.reorderPost,
            children: [
              for (final post in selectedPosts)
                ListTile(
                  key: ValueKey(post.id),
                  leading: UserAvatar(iconPath: post.userIconPath, radius: 16),
                  title: Text(post.userName),
                  subtitle: Text(post.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => notifier.removePost(post.id),
                  ),
                ),
            ],
          ),
          if (unselectedPosts.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text('追加できる投稿', style: TextStyle(color: Colors.grey)),
            for (final post in unselectedPosts)
              ListTile(
                leading: UserAvatar(iconPath: post.userIconPath, radius: 16),
                title: Text(post.userName),
                subtitle: Text(post.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => notifier.addPost(post.id),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
