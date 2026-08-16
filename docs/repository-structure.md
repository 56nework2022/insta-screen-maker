# リポジトリ構造定義書: 撮影用インスタ画面メーカー

## 1. フォルダ・ファイル構成

```
claude-picapp/
├── .devcontainer/                 # 開発コンテナ設定
├── .steering/                     # 作業単位のステアリングドキュメント
│   └── [YYYYMMDD]-[開発タイトル]/
├── docs/                          # 永続的ドキュメント
│   ├── ideas/                     # 元資料(PRD等)
│   ├── images/                    # 複雑な図表用の画像(必要な場合のみ)
│   ├── product-requirements.md
│   ├── functional-design.md
│   ├── architecture.md
│   ├── repository-structure.md
│   ├── development-guidelines.md
│   └── glossary.md
├── lib/
│   ├── main.dart                  # エントリーポイント(Hive初期化、runApp)
│   ├── app.dart                   # MaterialAppルートWidget・テーマ適用
│   ├── core/                      # 機能横断の共通コード
│   │   ├── theme/                 # AppTheme・カラー・テキストスタイル定義
│   │   ├── widgets/                # 複数フィーチャーで使う共通Widget
│   │   └── utils/                  # 画像選択・保存ヘルパー、ID生成ラッパー等
│   ├── data/                      # 永続化層
│   │   └── hive/
│   │       ├── hive_boxes.dart     # Box名の定数・Box初期化処理
│   │       └── models/             # Hiveモデル(TypeAdapter対象クラス)
│   │           ├── post.dart / post.g.dart
│   │           ├── comment.dart / comment.g.dart
│   │           ├── profile.dart / profile.g.dart
│   │           ├── follow_user.dart / follow_user.g.dart
│   │           ├── story_group.dart / story_group.g.dart
│   │           ├── story_image.dart / story_image.g.dart
│   │           └── feed.dart / feed.g.dart
│   └── features/                  # フィーチャー単位のモジュール
│       ├── home/
│       │   ├── screens/            # ホーム画面(作成物一覧・新規作成メニュー)
│       │   ├── widgets/
│       │   └── providers/
│       ├── post/
│       │   ├── screens/            # post_edit_screen.dart, post_preview_screen.dart
│       │   ├── widgets/            # いいねボタン、コメント行 等
│       │   └── providers/          # post_notifier.dart, post_list_provider.dart
│       ├── profile/
│       │   ├── screens/            # profile_edit_screen.dart, profile_preview_screen.dart, post_grid_screen.dart
│       │   ├── widgets/
│       │   └── providers/          # profile_notifier.dart, profile_list_provider.dart
│       ├── follow_list/
│       │   ├── screens/            # follower_list_screen.dart, following_list_screen.dart
│       │   └── widgets/
│       ├── feed/
│       │   ├── screens/            # feed_edit_screen.dart, feed_preview_screen.dart
│       │   ├── widgets/
│       │   └── providers/          # feed_notifier.dart, feed_list_provider.dart
│       └── story/
│           ├── screens/            # story_edit_screen.dart, story_preview_screen.dart
│           ├── widgets/            # 進捗バー 等
│           └── providers/          # story_notifier.dart, story_list_provider.dart
├── test/                          # lib/ と同一構造でテストを配置
│   ├── core/
│   ├── data/
│   └── features/
├── android/                       # Flutterプラットフォームコード(自動生成含む)
├── ios/                           # Flutterプラットフォームコード(自動生成含む)
├── pubspec.yaml
├── analysis_options.yaml
├── CLAUDE.md
└── README.md
```

## 2. ディレクトリの役割

| ディレクトリ | 役割 |
|---|---|
| `docs/` | プロダクト全体の恒久的な設計ドキュメント(本書もここに含まれる) |
| `.steering/` | 個々の開発作業の要求・設計・タスクを記録する作業単位のドキュメント |
| `lib/core/` | 特定のフィーチャーに属さない共通コード(テーマ、共通Widget、ユーティリティ) |
| `lib/data/hive/` | Hiveのモデル定義・Box初期化など、永続化に関わるコードを集約する |
| `lib/features/<feature>/screens/` | そのフィーチャーの画面(編集画面・プレビュー画面)を配置する |
| `lib/features/<feature>/widgets/` | そのフィーチャー専用のUI部品(他フィーチャーから参照しない) |
| `lib/features/<feature>/providers/` | そのフィーチャーのRiverpod Notifier・Provider定義 |
| `test/` | `lib/` と対応するディレクトリ構造でテストコードを配置する |

`functional-design.md` で定義したフィーチャー(`post` / `profile` / `follow_list` / `feed` / `story` / `home`)を、そのまま `lib/features/` 配下のディレクトリ名として採用する。

## 3. ファイル配置ルール

- **1ファイル1クラスを原則とする**: 画面(Screen)、Notifier、Hiveモデルはそれぞれ独立したファイルに定義する
- **ファイル名は snake_case**: Dartの標準命名規則に従う(例: `post_edit_screen.dart`)。クラス名はUpperCamelCase(例: `PostEditScreen`)とし、ファイル名と対応させる
- **Hiveモデルとアダプタ**: `xxx.dart` にモデルクラス、`build_runner` が生成する `xxx.g.dart` は同じディレクトリに配置し、コミット対象とする(`architecture.md` 参照)
- **共通か専用かの判断基準**: 2つ以上のフィーチャーから使われるWidget・ユーティリティは `lib/core/` に置く。1フィーチャー内でしか使わないものは、そのフィーチャーの `widgets/` に留める(安易な共通化はしない)
- **画像アセット**: アプリ内蔵アセット(アイコン等)は `assets/images/` に配置し、`pubspec.yaml` に登録する。ユーザーが選択した画像(ダミーデータ用)はアセットではなく、実行時に端末内アプリ専用ディレクトリへコピーして扱う(`architecture.md` 3.4節参照)
- **テストファイル**: `test/` 配下に `lib/` と同じ相対パス・ファイル名(`_test.dart` サフィックス)で配置する(例: `lib/features/post/providers/post_notifier.dart` → `test/features/post/providers/post_notifier_test.dart`)
- **ステアリングディレクトリ**: 命名規則・運用ルールは `CLAUDE.md` に従う(`.steering/[YYYYMMDD]-[開発タイトル]/`)
