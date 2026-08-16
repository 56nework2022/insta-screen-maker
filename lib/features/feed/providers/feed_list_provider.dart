import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../core/utils/id_generator.dart';
import '../../../data/hive/hive_boxes.dart';
import '../../../data/hive/models/feed.dart';

class FeedListNotifier extends Notifier<List<Feed>> {
  Box<Feed> get _box => Hive.box<Feed>(HiveBoxes.feedBoxName);

  @override
  List<Feed> build() => _box.values.toList();

  Feed createFeed() {
    final feed = Feed(id: IdGenerator.generate(), name: '');
    _box.put(feed.id, feed);
    refresh();
    return feed;
  }

  void deleteFeed(String id) {
    _box.delete(id);
    refresh();
  }

  void refresh() {
    state = _box.values.toList();
  }
}

final feedListProvider = NotifierProvider<FeedListNotifier, List<Feed>>(
  FeedListNotifier.new,
);
