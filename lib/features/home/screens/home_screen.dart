import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/hive/models/feed.dart';
import '../../../data/hive/models/post.dart';
import '../../../data/hive/models/profile.dart';
import '../../../data/hive/models/story_group.dart';
import '../../feed/providers/feed_list_provider.dart';
import '../../feed/screens/feed_edit_screen.dart';
import '../../post/providers/post_list_provider.dart';
import '../../post/screens/post_edit_screen.dart';
import '../../profile/providers/profile_list_provider.dart';
import '../../profile/screens/profile_edit_screen.dart';
import '../../story/providers/story_list_provider.dart';
import '../../story/screens/story_edit_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postListProvider);
    final profiles = ref.watch(profileListProvider);
    final storyGroups = ref.watch(storyListProvider);
    final feeds = ref.watch(feedListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('撮影用インスタ画面メーカー')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HomeSection<Post>(
            title: '投稿',
            items: posts,
            itemLabel: (post) => post.caption.isEmpty ? '(無題の投稿)' : post.caption,
            onCreate: () async {
              final post = ref.read(postListProvider.notifier).createPost();
              await Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => PostEditScreen(postId: post.id)),
              );
              ref.read(postListProvider.notifier).refresh();
            },
            onTapItem: (post) async {
              await Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => PostEditScreen(postId: post.id)),
              );
              ref.read(postListProvider.notifier).refresh();
            },
            onDeleteItem: (post) => ref.read(postListProvider.notifier).deletePost(post.id),
          ),
          _HomeSection<Profile>(
            title: 'プロフィール',
            items: profiles,
            itemLabel: (profile) => profile.name.isEmpty ? '(無題のプロフィール)' : profile.name,
            onCreate: () async {
              final profile = ref.read(profileListProvider.notifier).createProfile();
              await Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => ProfileEditScreen(profileId: profile.id)),
              );
              ref.read(profileListProvider.notifier).refresh();
            },
            onTapItem: (profile) async {
              await Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => ProfileEditScreen(profileId: profile.id)),
              );
              ref.read(profileListProvider.notifier).refresh();
            },
            onDeleteItem: (profile) =>
                ref.read(profileListProvider.notifier).deleteProfile(profile.id),
          ),
          _HomeSection<StoryGroup>(
            title: 'ストーリーズ',
            items: storyGroups,
            itemLabel: (storyGroup) =>
                storyGroup.ownerName.isEmpty ? '(無題のストーリーズ)' : storyGroup.ownerName,
            onCreate: () async {
              final storyGroup = ref.read(storyListProvider.notifier).createStoryGroup();
              await Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => StoryEditScreen(storyGroupId: storyGroup.id)),
              );
              ref.read(storyListProvider.notifier).refresh();
            },
            onTapItem: (storyGroup) async {
              await Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => StoryEditScreen(storyGroupId: storyGroup.id)),
              );
              ref.read(storyListProvider.notifier).refresh();
            },
            onDeleteItem: (storyGroup) =>
                ref.read(storyListProvider.notifier).deleteStoryGroup(storyGroup.id),
          ),
          _HomeSection<Feed>(
            title: 'フィード',
            items: feeds,
            itemLabel: (feed) => feed.name.isEmpty ? '(無題のフィード)' : feed.name,
            onCreate: () async {
              final feed = ref.read(feedListProvider.notifier).createFeed();
              await Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => FeedEditScreen(feedId: feed.id)),
              );
              ref.read(feedListProvider.notifier).refresh();
            },
            onTapItem: (feed) async {
              await Navigator.of(context).push<void>(
                MaterialPageRoute(builder: (_) => FeedEditScreen(feedId: feed.id)),
              );
              ref.read(feedListProvider.notifier).refresh();
            },
            onDeleteItem: (feed) => ref.read(feedListProvider.notifier).deleteFeed(feed.id),
          ),
        ],
      ),
    );
  }
}

class _HomeSection<T> extends StatelessWidget {
  const _HomeSection({
    required this.title,
    required this.items,
    required this.itemLabel,
    required this.onCreate,
    required this.onTapItem,
    required this.onDeleteItem,
  });

  final String title;
  final List<T> items;
  final String Function(T item) itemLabel;
  final VoidCallback onCreate;
  final ValueChanged<T> onTapItem;
  final ValueChanged<T> onDeleteItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: onCreate),
          ],
        ),
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('まだありません', style: TextStyle(color: Colors.grey)),
          )
        else
          for (final item in items)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(itemLabel(item)),
              onTap: () => onTapItem(item),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => onDeleteItem(item),
              ),
            ),
        const Divider(height: 24),
      ],
    );
  }
}
