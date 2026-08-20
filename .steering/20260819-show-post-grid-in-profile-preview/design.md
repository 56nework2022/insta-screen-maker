# 設計: プロフィールプレビュー画面に投稿サムネイルグリッドを直接表示

## 実装アプローチ

`PostGridScreen`の3列グリッド描画部分(プレースホルダー表示込み)を再利用可能なWidget
`PostThumbnailGrid`として切り出し、`PostGridScreen`(フルスクリーン・スクロール可能)と
`ProfilePreviewScreen`(プロフィール情報の下に埋め込み・親の`ListView`と一緒にスクロール)の
両方から利用する。

データ層(`ProfileNotifier`, `Profile`, Hiveスキーマ)は変更しない。

## 変更するコンポーネント

### 1. 新規: `lib/features/profile/widgets/post_thumbnail_grid.dart`

- `PostThumbnailGrid` (StatelessWidget) を新規作成。
  - プロパティ: `paths` (`List<String>`), `shrinkWrap` (`bool`, デフォルト `false`),
    `physics` (`ScrollPhysics?`, デフォルト `null` = 通常のスクロール)。
  - 中身は現行`PostGridScreen`の`GridView.builder`(3列, 余白/間隔2px, `errorBuilder`で
    `_BrokenThumbnail`表示)をそのまま移植し、`shrinkWrap`/`physics`を可変にする。
  - `_BrokenThumbnail`(プレースホルダー: 灰色背景+`Icons.broken_image`)もこのファイルに移動する。

### 2. `lib/features/profile/screens/post_grid_screen.dart`

- 独自の`GridView.builder`実装を削除し、`PostThumbnailGrid(paths: profile.postThumbnailPaths)`
  を呼び出すだけにする(デフォルトの`shrinkWrap: false`でフルスクリーンスクロール、見た目は現状維持)。
- `_BrokenThumbnail`クラスは`post_thumbnail_grid.dart`に移動するため、こちらから削除する。

### 3. `lib/features/profile/screens/profile_preview_screen.dart`

- `bio`表示の下に投稿サムネイルのセクションを追加する。
  - `postCount == 0`の場合: 空状態として `Padding` + 中央寄せの `Text('まだ投稿がありません', style: TextStyle(color: AppColors.secondaryText))` を表示。
  - `postCount > 0`の場合: `PostThumbnailGrid(paths: profile.postThumbnailPaths, shrinkWrap: true, physics: const NeverScrollableScrollPhysics())`
    を表示する(親の`ListView`内に埋め込むため`shrinkWrap`と`NeverScrollableScrollPhysics`が必須)。
- 「投稿」の`_StatColumn`から`onTap`によるページ遷移(`PostGridScreen`へのpush)を削除する。
  - `_StatColumn.onTap`を`VoidCallback?`(nullable)に変更し、`null`の場合は`GestureDetector`を使わず
    ただの`Column`として描画する(タップ操作自体を無効化するため)。
  - 「フォロワー」「フォロー」は現状通り`onTap`を渡し、遷移を維持する。
- `import 'post_grid_screen.dart';` は不要になるため削除し、代わりに
  `import '../widgets/post_thumbnail_grid.dart';` を追加する。

## データ構造の変更

なし。

## 影響範囲の分析

- `PostGridScreen`は`profile_edit_screen.dart`のプレビュー導線からは直接遷移しなくなるが、
  クラス自体は要求通り削除しない(コード上は`ProfilePreviewScreen`から参照されなくなるが、
  独立した画面として引き続き有効)。`flutter analyze`で未使用の警告が出ないことを確認する
  (Dartは未参照のpublicクラスを警告しないため、問題ない見込み)。
- `profile_edit_screen.dart`側のサムネイル一覧(`Wrap`+`Image.file`)は本設計の対象外
  (編集用のUIであり、閲覧用の`PostThumbnailGrid`とは表示要件が異なるため据え置く)。
- 既存の`flutter test`のうち`profile_preview_screen_test.dart`は`postThumbnailPaths`が空の
  ケースを検証しているため、今回追加する空状態表示のテストケースとして機能する見込み。
  内容を確認し、必要なら空状態のテキストが表示されることを検証するアサーションを追加する。
- 本環境では`Image.file`を含むwidgetテストの実行(pump)がハングする既知の制約があるため、
  グリッド埋め込み部分の新規widgetテストは見送り、`flutter analyze`と既存テストのグリーンを
  確認する。実機での最終確認はユーザーに依頼する。
