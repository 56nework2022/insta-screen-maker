# 初回実装 タスクリスト: 撮影用インスタ画面メーカー

進捗管理方法: 実装を進めるたびに、該当タスクのチェックボックスを `- [x]` に更新する。本ファイルが本作業の進捗状況の正とする。

## Phase 0: プロジェクト基盤

- [x] Flutterプロジェクト初期化(`pubspec.yaml`に依存パッケージ追加: `flutter_riverpod`, `hive`, `hive_flutter`, `hive_generator`, `build_runner`, `image_picker`, `path_provider`, `uuid`, `flutter_lints`)
- [x] `lib/core/theme/app_colors.dart` / `app_theme.dart` 作成(Instagram風配色・テーマ定義)
- [x] `lib/core/utils/image_storage_helper.dart` 作成(`image_picker`で選択した画像をアプリ専用ディレクトリへコピー)
- [x] `lib/core/utils/id_generator.dart` 作成(`uuid`ラッパー)
- [x] `lib/main.dart` / `lib/app.dart` の雛形作成(`ProviderScope`、`MaterialApp`、テーマ適用)

## Phase 1: データ層(Hive)

- [x] `lib/data/hive/models/post.dart`(`typeId: 0`)作成
- [x] `lib/data/hive/models/comment.dart`(`typeId: 1`)作成
- [x] `lib/data/hive/models/profile.dart`(`typeId: 2`)作成
- [x] `lib/data/hive/models/follow_user.dart`(`typeId: 3`)作成
- [x] `lib/data/hive/models/story_group.dart`(`typeId: 4`)作成
- [x] `lib/data/hive/models/story_image.dart`(`typeId: 5`)作成
- [x] `lib/data/hive/models/feed.dart`(`typeId: 6`)作成
- [x] `build_runner`実行によるアダプタ(`*.g.dart`)生成確認
- [x] `lib/data/hive/hive_boxes.dart` 作成(Box名定数)
- [x] `main.dart`でのHive初期化・アダプタ登録・Box open処理実装

## Phase 2: `post`フィーチャー

- [x] `PostNotifier`実装(作成/編集/削除、いいねトグル、コメント追加/編集/削除)
- [x] `postListProvider`実装(一覧取得)
- [x] `PostEditScreen`実装(画像選択、キャプション/いいね数/投稿者情報/投稿時間ラベル入力、コメント編集)
- [x] `PostPreviewScreen`実装(実機風レイアウト、いいねトグル操作、コメント追加操作)
- [x] 関連Widget(いいねボタン、コメント行等)実装
- [x] `PostNotifier`の単体テスト作成
- [x] `PostPreviewScreen`のWidgetテスト作成

## Phase 3: `profile` / `follow_list`フィーチャー

- [x] `ProfileNotifier`実装(プロフィール編集、投稿サムネイル追加/削除、フォロワー/フォロー追加/編集/削除)
- [x] `profileListProvider`実装
- [x] `ProfileEditScreen`実装
- [x] `ProfilePreviewScreen`実装(投稿数/フォロワー数/フォロー数の遷移導線含む)
- [x] `PostGridScreen`実装(投稿サムネイルのグリッド表示)
- [x] `FollowerListScreen` / `FollowingListScreen`実装
- [x] `ProfileNotifier`の単体テスト作成
- [x] `ProfilePreviewScreen`のWidgetテスト作成

## Phase 4: `story`フィーチャー

- [x] `StoryNotifier`実装(所有者情報編集、画像追加/削除/順序編集)
- [x] `storyListProvider`実装
- [x] `StoryEditScreen`実装
- [x] `StoryPreviewScreen`実装(全画面表示、タップで次送り、進捗バー)
- [x] `StoryNotifier`の単体テスト作成
- [x] `StoryPreviewScreen`のWidgetテスト作成

## Phase 5: `feed`フィーチャー

- [x] `FeedNotifier`実装(投稿/ストーリーズグループの選択・並び替え、参照先欠損時の非表示処理)
- [x] `feedListProvider`実装
- [x] `FeedEditScreen`実装
- [x] `FeedPreviewScreen`実装(投稿スクロール一覧、ストーリーズリング、ストーリーズ画面への遷移)
- [x] `FeedNotifier`の単体テスト作成
- [x] `FeedPreviewScreen`のWidgetテスト作成

## Phase 6: `home`フィーチャー

- [x] `HomeScreen`実装(投稿/プロフィール/フィード/ストーリーズグループの一覧表示、新規作成導線)
- [x] 各フィーチャーの編集/プレビュー画面への遷移配線

## Phase 7: 結合確認・品質チェック

- [x] `flutter analyze` を実行し、警告・エラーがないことを確認(0件)
- [x] `flutter test` を実行し、全テストが通過することを確認(9ファイル・20テスト、すべて成功)
- [x] シミュレータ/実機で、ホーム画面から5画面(投稿詳細・プロフィール・フォロワー/フォロー一覧・フィード・ストーリーズ)すべてに遷移し、データ入力・プレビュー表示ができることを手動確認
  - 2026-08-16、ユーザーによりエミュレータ上で確認完了。問題なし。
- [x] アプリを再起動し、入力したデータが保持されていることを確認
  - 2026-08-16、ユーザーによりエミュレータ上で確認完了。問題なし。

## 完了条件

- 本タスクリストの全項目が完了していること
- `.steering/20260815-initial-implementation/requirements.md` の「4. 受け入れ条件」をすべて満たしていること
- 残作業なし。初回実装は完了。
