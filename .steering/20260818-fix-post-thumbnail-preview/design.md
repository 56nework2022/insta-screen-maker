# 設計: 投稿サムネイルのプレビュー表示不具合の修正

## 実装アプローチ

画像読み込み失敗時に「何も表示されない(空白)」状態を避け、
明示的なプレースホルダー(壊れた画像アイコン + 背景色)を表示するように、
既存の`Image.file`/`DecorationImage`の使用箇所を最小限の変更で修正する。

データ層(`ProfileNotifier`, `Profile`, Hiveスキーマ)は変更しない。

## 変更するコンポーネント

### 1. `lib/features/profile/screens/post_grid_screen.dart`

- `Image.file(File(path), fit: BoxFit.cover)` に `errorBuilder` を追加し、
  読み込み失敗時は背景色(`Colors.grey.shade200`)+ `Icons.broken_image` アイコンを表示する。

### 2. `lib/features/profile/screens/profile_edit_screen.dart`

- サムネイル一覧の各アイテムは現在 `Container` + `BoxDecoration(image: DecorationImage(...))`
  で実装されており、`DecorationImage`自体には`errorBuilder`が無いため、
  `DecorationImage(..., onError: ...)` コールバックを使い、エラー時に
  `StatefulWidget`で保持したフラグを立てて `Icons.broken_image` を上に重ねて表示する方式ではなく、
  よりシンプルに **`Image.file(file, fit: BoxFit.cover, errorBuilder: ...)` を
  `ClipRRect`で角丸にして使う実装に置き換える**(`DecorationImage`から`Image.file`ベースへ変更)。
  これにより`PostGridScreen`と同じ`errorBuilder`パターンで統一でき、実装・保守がシンプルになる。

### 3. 共通のプレースホルダー表示

- 各ファイルで簡潔な `Container(color: Colors.grey.shade200, child: Icon(Icons.broken_image, ...))`
  を`errorBuilder`内で返す。共通Widget化は今回のスコープでは行わない(2箇所のみのため、
  抽象化コストの方が高い)。

## データ構造の変更

なし。

## 影響範囲の分析

- 表示コンポーネントのみの変更であり、`ProfileNotifier`・Hiveボックス・他フィーチャー
  (`post`, `feed`, `story`)には影響しない。
- 既存のwidgetテスト(`profile_preview_screen_test.dart`)は`postThumbnailPaths`を使わない
  ケースのみを検証しており、影響なし。
- 本環境では`Image.file`を含むwidgetテストの実行(pump)がハングする既知の制約があるため、
  今回の修正に対する新規widgetテストの追加は見送り、`flutter analyze`と既存テストの
  グリーンを確認する。実機での最終確認はユーザーに依頼する。
