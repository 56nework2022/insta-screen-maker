# 初回実装 設計: 撮影用インスタ画面メーカー

## 1. 実装アプローチ

新規プロジェクトのため、依存関係の少ない基盤から順に積み上げ、他フィーチャーから参照される土台(投稿・ストーリーズ)を先に完成させてから、それらを組み合わせるフィーチャー(フィード)、最後に全体を横断するホーム画面を実装する。

### 実装順序

1. **プロジェクト基盤**: `pubspec.yaml`の依存追加、`main.dart`/`app.dart`、`core/theme`(配色・テーマ)
2. **データ層**: `lib/data/hive/models/`配下の7モデル(`docs/glossary.md`のtypeId台帳に従う)、`hive_boxes.dart`、`main.dart`でのHive初期化
3. **`post`フィーチャー**: Notifier → 編集画面 → プレビュー画面 → Widget → 単体テスト。他フィーチャー(フィード)から参照される基礎データのため最初に実装する
4. **`profile`フィーチャー + `follow_list`**: プロフィール編集/プレビュー画面、フォロワー/フォロー一覧画面(プロフィールに埋め込みのため同時実装)
5. **`story`フィーチャー**: ストーリーズ編集/プレビュー画面。フィードのストーリーズリングから参照されるため、フィードより先に実装する
6. **`feed`フィーチャー**: `post`・`story`の完成後に実装(既存の投稿・ストーリーズグループをID参照で組み合わせる構成のため)
7. **`home`フィーチャー**: 全Boxを横断参照する一覧画面。全フィーチャーの編集/プレビュー画面が揃った時点で、導線をつなぐ形で最後に実装する
8. **結合確認**: シミュレータ/実機でホーム画面から全画面への遷移・データ入力・永続化を手動確認し、`flutter analyze` / `flutter test` を実行する

各フィーチャーの実装単位は「Notifier(状態・永続化ロジック) → 編集画面 → プレビュー画面 → 単体テスト」の順を基本とする(データを操作できる状態を先に作り、UIで確認しながら進める)。

## 2. 新規作成するコンポーネント

初回実装のため「変更」ではなく全て新規作成となる。`docs/repository-structure.md`のフォルダ構成に従い、以下を作成する。

| レイヤ | 主なファイル |
|---|---|
| エントリーポイント | `lib/main.dart`, `lib/app.dart` |
| 共通(core) | `lib/core/theme/app_theme.dart`, `app_colors.dart` / `lib/core/utils/image_storage_helper.dart`(画像コピー処理), `id_generator.dart`(UUID発行) |
| データ層 | `lib/data/hive/hive_boxes.dart` / `lib/data/hive/models/{post,comment,profile,follow_user,story_group,story_image,feed}.dart`(+生成される`.g.dart`) |
| `post` | `screens/post_edit_screen.dart`, `screens/post_preview_screen.dart`, `providers/post_notifier.dart`, `providers/post_list_provider.dart`, `widgets/`(いいねボタン、コメント行など) |
| `profile` | `screens/profile_edit_screen.dart`, `screens/profile_preview_screen.dart`, `screens/post_grid_screen.dart`, `providers/profile_notifier.dart`, `providers/profile_list_provider.dart` |
| `follow_list` | `screens/follower_list_screen.dart`, `screens/following_list_screen.dart` |
| `story` | `screens/story_edit_screen.dart`, `screens/story_preview_screen.dart`, `providers/story_notifier.dart`, `providers/story_list_provider.dart`, `widgets/progress_bar.dart` |
| `feed` | `screens/feed_edit_screen.dart`, `screens/feed_preview_screen.dart`, `providers/feed_notifier.dart`, `providers/feed_list_provider.dart` |
| `home` | `screens/home_screen.dart`, `widgets/`(各フィーチャーへの導線カード等) |

`lib/core/widgets/`配下の共通Widgetは、実装を進める中で2フィーチャー以上から必要になった時点で切り出す(先行して汎用部品を作り込まない)。

## 3. データ構造

`docs/functional-design.md`の「4. データモデル定義」で確定済みのER図・エンティティ定義をそのまま実装に用いる。初回実装時点での変更はない。Hiveの`typeId`割り当ては`docs/glossary.md`の管理台帳(`Post=0`〜`Feed=6`)に従う。

## 4. 影響範囲の分析

- 新規プロジェクトの初回実装であり、既存の稼働コードへの影響はない
- `pubspec.yaml`に追加する依存パッケージ(`flutter_riverpod`, `hive`, `hive_flutter`, `hive_generator`, `build_runner`, `image_picker`, `path_provider`, `uuid`, `flutter_lints`)は、devcontainer上のFlutter SDKバージョンとの互換性を導入時に確認する
- `feed`フィーチャーは`post`・`story_group`のデータに依存するID参照を持つため、参照先(投稿・ストーリーズグループ)が削除された場合の表示(欠損時のフォールバック表示)を実装時に決定する必要がある。本設計では「参照先が存在しない場合はフィード上でその項目を非表示にする」方針とする
- `home`画面は全Boxを横断参照するため、各フィーチャーのBox初期化(`main.dart`)が完了していることが前提となる。実装順序(本書1節)により担保する
