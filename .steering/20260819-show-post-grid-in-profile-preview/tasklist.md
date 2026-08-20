# タスクリスト: プロフィールプレビュー画面に投稿サムネイルグリッドを直接表示

## 1. `PostThumbnailGrid` ウィジェットの新規作成

- [x] `lib/features/profile/widgets/post_thumbnail_grid.dart` を新規作成
  - [x] `PostThumbnailGrid` (StatelessWidget) を定義
    - プロパティ: `paths` (`List<String>`, required), `shrinkWrap` (`bool`, デフォルト `false`), `physics` (`ScrollPhysics?`, デフォルト `null`)
    - 中身は `PostGridScreen` の `GridView.builder`(3列, 余白/間隔2px, `errorBuilder`)をそのまま移植
  - [x] `_BrokenThumbnail`(灰色背景 + `Icons.broken_image`)を `post_grid_screen.dart` からこのファイルに移動

## 2. `PostGridScreen` を `PostThumbnailGrid` を使う薄いラッパーに変更

- [x] `lib/features/profile/screens/post_grid_screen.dart` を編集
  - [x] 独自の `GridView.builder` 実装を削除し、`PostThumbnailGrid(paths: profile.postThumbnailPaths)` を呼び出すだけにする(デフォルトでフルスクリーンスクロール、見た目は現状維持)
  - [x] `_BrokenThumbnail` クラスを削除(1.で移動済み)
  - [x] `post_thumbnail_grid.dart` を import

## 3. `ProfilePreviewScreen` にグリッドを埋め込み

- [x] `lib/features/profile/screens/profile_preview_screen.dart` を編集
  - [x] `import 'post_grid_screen.dart';` を削除し、`import '../widgets/post_thumbnail_grid.dart';` を追加
  - [x] `bio` 表示の下に投稿サムネイルのセクションを追加
    - `postCount == 0`: 空状態 `Text('まだ投稿がありません', style: TextStyle(color: AppColors.secondaryText))` を中央寄せで表示
    - `postCount > 0`: `PostThumbnailGrid(paths: profile.postThumbnailPaths, shrinkWrap: true, physics: const NeverScrollableScrollPhysics())`
  - [x] `_StatColumn.onTap` を `VoidCallback?`(nullable)に変更
    - `onTap == null` の場合はタップ操作なしの `Column` として描画(`GestureDetector` を使わない)
  - [x] 「投稿」の `_StatColumn` 呼び出しから `onTap`(`PostGridScreen` へのpush)を削除し `null` を渡す
  - [x] 「フォロワー」「フォロー」の `_StatColumn` は `onTap` を維持(現状の遷移を変更しない)

## 4. 品質チェック

- [x] `flutter analyze` を実行し、新規の警告・エラーが出ないことを確認
  - [x] `PostGridScreen` が未参照になっても public クラスなので警告が出ないことを確認(No issues found!)
- [x] `flutter test` を実行し、既存テストがすべてパスすることを確認(20テスト全てpass)
  - [x] `profile_preview_screen_test.dart` に空状態表示("まだ投稿がありません")のアサーションを追加
  - [x] `Image.file` を含む新規widgetテストは追加しない(既知のpumpハング制約のため)

## 5. 完了条件

- [x] `ProfilePreviewScreen` を開くと自己紹介の下に投稿サムネイルグリッドが表示される(コードレベルで確認)
- [x] 「投稿」タップで画面遷移しないことをコードで確認(フォロワー/フォローは維持)
- [x] `flutter analyze` / `flutter test` がグリーン
- [x] 実機・エミュレータでの最終目視確認はユーザーに依頼する(2026-08-20 確認済み・OK)
