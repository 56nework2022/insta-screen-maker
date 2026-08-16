# 技術仕様書: 撮影用インスタ画面メーカー

## 1. テクノロジースタック

### 1.1 コアフレームワーク

| 項目 | 選定技術 | 備考 |
|---|---|---|
| フレームワーク | Flutter (stable channel) | iOS / Android 両対応のクロスプラットフォーム開発 |
| 言語 | Dart (null safety) | Flutter標準 |
| 状態管理 | Riverpod (`flutter_riverpod`) | コード生成(`riverpod_generator`)は使わず、素の`Notifier`/`AsyncNotifier`で実装しビルド構成をシンプルに保つ |
| ローカルDB | Hive (`hive`, `hive_flutter`) | 型安全な永続化のため `hive_generator` + `build_runner` で `TypeAdapter` を自動生成する |

具体的なパッケージバージョンは実装開始時に `pubspec.yaml` / `pubspec.lock` で固定する(本書では最新の安定版を採用する方針のみ定める)。

### 1.2 主要な依存パッケージ

| パッケージ | 用途 |
|---|---|
| `flutter_riverpod` | 状態管理 |
| `hive` / `hive_flutter` | ローカル永続化 |
| `hive_generator` / `build_runner` | Hive用`TypeAdapter`のコード生成 |
| `image_picker` | 端末ギャラリーからの画像選択 |
| `path_provider` | アプリ専用ストレージ領域の取得(選択画像のコピー保存先) |
| `uuid` | 各エンティティ(`Post`/`Profile`/`StoryGroup`/`Feed`等)のID生成 |
| `flutter_lints` | 静的解析・Lintルール |
| `flutter_test` | 単体・Widgetテスト |

### 1.3 ナビゲーション

- 画面遷移は Flutter標準の `Navigator`(`MaterialPageRoute`によるpush/pop)で実装する
- 本アプリの画面遷移は「ホーム→編集→プレビュー→(プロフィールからの)派生一覧」という比較的単純な階層構造であり、ディープリンクや複雑なURLベースの状態復元も不要なため、`go_router`等のルーティングライブラリは導入しない(過剰な抽象化を避ける)

## 2. 開発ツールと手法

### 2.1 開発環境

- 開発環境: devcontainer(`.devcontainer/`)上で Claude Code を用いて開発する
- エディタ: VS Code(devcontainer連携)
- パッケージ管理: Dart標準の `pub`(`pubspec.yaml`)

### 2.2 コード生成

- `build_runner` を用いて以下を生成する
  - Hiveの `TypeAdapter`(`*.g.dart`)
- コード生成コマンド例: `dart run build_runner build --delete-conflicting-outputs`
- 生成ファイル(`*.g.dart`)はリポジトリにコミットする(CIやチームメンバーがコード生成環境を持たない場合でもビルド可能にするため)

### 2.3 品質チェック

- 静的解析: `flutter analyze`(`flutter_lints` ルールセットを使用)
- フォーマット: `dart format`
- テスト: `flutter test`(単体テスト・Widgetテスト)
- コード変更後は上記チェックをローカルで実行してからコミットする(詳細な規約は `development-guidelines.md` で定義)

### 2.4 バージョン管理

- Git を使用する
- コミット・ブランチ運用の詳細は `development-guidelines.md` で定義する

### 2.5 CI/CD

- Phase 1時点ではCI/CDパイプラインは構築しない(個人・小規模チーム開発かつローカル完結アプリのため)
- ストア配布(App Store / Google Play)のビルド・審査手順は、リリース準備段階で別途検討する

## 3. 技術的制約と要件

### 3.1 オフライン動作

- 本アプリはネットワーク通信を一切行わない。実SNSサーバーとの通信機能は持たず、インターネット接続権限(パーミッション)も要求しない
- すべてのデータはHiveによって端末内にのみ保存する

### 3.2 対応プラットフォーム

- iOS / Android の両OSに対応する
- サポート対象OSバージョンは、実装時点でのFlutter安定版が公式サポートする範囲に準拠する(例: Flutter最新安定版が要求する iOS / Android の最小バージョン)

### 3.3 権限(パーミッション)

- 画像選択(`image_picker`)のため、以下の権限が必要
  - iOS: `NSPhotoLibraryUsageDescription`(フォトライブラリへのアクセス)
  - Android: 写真・メディアへのアクセス権限(`READ_MEDIA_IMAGES`等、対象Android APIレベルに応じた権限)
- 上記以外の権限(位置情報、連絡先、通信等)は要求しない

### 3.4 画像データの扱い

- `image_picker` で選択した画像は、一時パスのまま参照するとOSにより削除・無効化される可能性があるため、`path_provider` で取得したアプリ専用ディレクトリに複製し、そのパスをHiveに保存する
- 画像本体はファイルシステムに保存し、Hiveにはファイルパス(文字列)のみを保存する(DBの肥大化を避ける)

### 3.5 データ永続化

- HiveのBoxは機能単位(`Post` / `Profile` / `StoryGroup` / `Feed`)で分割する(詳細は `functional-design.md` のデータモデル定義を参照)
- マイグレーション(スキーマ変更時の互換性)は、Phase 1では簡易的な対応(Hiveの`TypeAdapter`の`typeId`管理を徹底する)に留め、大規模なマイグレーション機構は導入しない

## 4. パフォーマンス要件

- **起動時間**: アプリ起動からホーム画面表示まで、体感で待たされない速度(目安: 2秒以内)を確保する
- **画面遷移**: 編集画面⇔プレビュー画面間の遷移は遅延を感じさせない速度で行う
- **スクロール**: フィード画面での投稿スクロールは60fps相当の滑らかさを維持する。画像は端末解像度に対して過剰なサイズで読み込まない(必要に応じて`Image`ウィジェットの`cacheWidth`等で表示サイズに合わせて負荷を抑える)
- **ストーリーズ送り**: タップによる次画像への切り替えは即時(体感遅延なし)に行う
- **画像取り込み**: ギャラリーからの画像選択〜アプリ内保存までの処理は、撮影現場での実演操作を妨げない速度で完了させる
