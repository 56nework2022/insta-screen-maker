# 開発ガイドライン: 撮影用インスタ画面メーカー

## 1. コーディング規約

### 1.1 基本方針

- [Effective Dart](https://dart.dev/effective-dart) に準拠する
- `flutter_lints` の規約に従い、`flutter analyze` で警告が出ない状態を維持する
- コミット前に `dart format .` を実行し、フォーマットを統一する

### 1.2 Widget設計

- 可能な限り `StatelessWidget` + Riverpodの`ConsumerWidget`/`HookConsumerWidget`(hooks_riverpodは導入しないため`ConsumerWidget`)で構成し、`StatefulWidget`は真にローカルなUI状態(アニメーションコントローラ等)に限定して使う
- `build()` メソッドが肥大化する場合は、Widgetとして切り出す(メソッド分割ではなくWidgetクラスとして分割し、`const`コンストラクタを積極的に使う)
- 1画面(Screen)は「レイアウトの組み立て」に専念し、ビジネスロジック(データ加工・永続化)はProvider/Notifier側に置く

### 1.3 Riverpod規約

- 状態はコード生成なしの `Notifier` / `AsyncNotifier` で実装する(`architecture.md`参照)
- Providerの命名は `xxxProvider`、Notifierクラスの命名は `XxxNotifier` とする
- 画面内では `ref.watch` で購読、イベントハンドラ(onTap等)内では `ref.read` を使う(不要な再構築を避ける)
- Provider定義はフィーチャーの `providers/` ディレクトリに集約し、画面・Widgetファイルに直書きしない

### 1.4 データ層(Hive)

- Hiveモデルクラスには一意な `typeId` を割り振り、`docs/glossary.md`または該当モデルファイルのコメントで管理台帳を残す(typeId重複はデータ破損の原因になるため)
- Box名は `hive_boxes.dart` に定数として集約し、文字列リテラルを画面・Provider側に直接書かない
- 画像ファイルの読み書き(コピー・削除)は `core/utils/` のヘルパー関数経由で行い、各Notifierに重複実装しない

### 1.5 エラーハンドリング

- 本アプリは通信を持たないため、想定される例外は主に「画像ファイルの読み込み失敗」「Hiveの読み書き失敗」に限られる。これらI/O境界でのみ `try/catch` を行い、ユーザーに簡潔なエラー表示(SnackBar等)を行う
- 発生し得ない異常系(nullになり得ない値のnullチェック等)への防御的コードは書かない

### 1.6 コメント

- コメントは「なぜそうしているか」が非自明な場合にのみ1行程度で書く(CLAUDE.md全体方針に準拠)
- 何をしているかが読めばわかる処理・命名で説明可能な処理にはコメントを書かない

## 2. 命名規則

| 対象 | 規則 | 例 |
|---|---|---|
| ファイル名 | snake_case | `post_edit_screen.dart` |
| クラス名 | UpperCamelCase | `PostEditScreen` |
| 変数・関数名 | lowerCamelCase | `likeCount`, `toggleLike()` |
| 定数 | lowerCamelCase(`const`/`static const`) | `const defaultIconPath = ...` |
| Riverpod Provider変数 | `xxxProvider` | `postListProvider` |
| Notifierクラス | `XxxNotifier` | `PostNotifier` |
| Hive Boxキー(定数) | lowerCamelCase文字列定数 | `postBoxName` |
| privateメンバー | `_` プレフィックス | `_imagePath` |

- コード上の識別子(クラス名・変数名等)はすべて英語で記述する
- UI上のラベル・文言は日本語で記述する(本アプリの利用者は日本語話者を想定)。UI文言は各Widget内に直接記述してよく、Phase 1では多言語対応(i18n)の仕組みは導入しない
- ドメイン用語の英語・日本語対応表は `docs/glossary.md` で管理する

## 3. スタイリング規約

- Flutterのテーマ機構(`ThemeData`)を用いて、配色・タイポグラフィを `lib/core/theme/` に一元定義する(Web版のTailwind CSSに相当する「共通デザインシステム」として扱う)
- Instagram風の見た目を再現するため、以下を `AppColors` としてテーマに定義する
  - 背景色(白基調)、テキスト色(黒・グレー階調)、アクセントカラー(いいねの赤、リンク色の青など)
  - ストーリーズのリング用グラデーション配色
- フォントはFlutter標準のシステムフォントを使用し、Phase 1ではカスタムフォントの導入は行わない
- レイアウトはスマートフォン縦画面を主対象とする(タブレット・横画面への最適化はPhase 1のスコープ外)
- ボタン・アイコン等、複数画面で見た目が共通するUI部品は `lib/core/widgets/` にWidgetとして切り出し、色や余白のハードコードを避けて `Theme.of(context)` 経由の値を参照する

## 4. テスト規約

- テスト種別
  - **単体テスト**: Notifierのロジック(いいねトグル、コメント追加、フィードの並び替え等)を対象とする
  - **Widgetテスト**: 主要なプレビュー画面(投稿詳細・プロフィール・フィード・ストーリーズ)が、与えたデータを正しく表示することを対象とする
- Hiveを利用するテストは、一時ディレクトリ(`Hive.init(tempDir.path)`相当)を使ったテスト専用の初期化を行い、実データに影響を与えない
- テストファイルは `repository-structure.md` の規則に従い、`test/` 配下に `lib/` とミラーリングした構成・命名(`_test.dart`)で配置する
- 網羅率(カバレッジ)の数値目標は設けない。UIの見た目確認よりも、状態変更・永続化まわりのロジックを優先的にテストする方針とする

## 5. Git規約

- **ブランチ運用**: `main` を安定ブランチとし、機能追加・修正は `feature/<内容>` ブランチを切って作業する。軽微な修正(ドキュメント修正等)は `main` への直接コミットも許容する
- **コミットメッセージ**: 日本語で「何を・なぜ」が分かる簡潔な一文とする。先頭に種別プレフィックスを付ける(Conventional Commits風)
  - `feat:` 新機能の追加
  - `fix:` 不具合修正
  - `docs:` ドキュメントのみの変更
  - `refactor:` 挙動を変えないコード整理
  - `test:` テストの追加・修正
  - `chore:` ビルド設定・依存関係更新等
  - 例: `feat: 投稿詳細画面のいいねトグル機能を追加`
- **コミット単位**: 1コミットは1つの論理的な変更に留め、無関係な変更を混在させない
- **生成ファイルの扱い**: `build_runner` が生成する `*.g.dart` はコミット対象とする(`architecture.md` 2.2節参照)。`.gitignore` にはFlutterの標準的なビルド生成物(`build/`, `.dart_tool/` 等)のみ除外設定する
