# ユビキタス言語定義: 撮影用インスタ画面メーカー

## 1. ドメイン用語の定義

| 用語 | 定義 |
|---|---|
| フェイク画面 / ダミー画面 | 実際のSNSと通信せず、ユーザーが自由入力したデータのみで構成される、撮影小道具用の模擬画面 |
| 投稿(Post) | 1件分の投稿データ。画像・キャプション・いいね数・投稿者情報・コメント一覧を持つ |
| コメント(Comment) | 投稿に紐づく1件のコメント。投稿者名・アイコン・本文を持つ |
| プロフィール(Profile) | 1件分のアカウントを模したデータ。名前・アイコン・自己紹介・投稿サムネイル・フォロワー一覧・フォロー一覧を持つ |
| フォロワー / フォロー(FollowUser) | プロフィールに紐づく、フォロワー一覧またはフォロー一覧の1件(名前・アイコンのみを持つ簡易ユーザー) |
| ストーリーズグループ(StoryGroup) | 1ユーザー分のストーリーズ。複数のストーリーズ画像を順序付きで持つ |
| ストーリーズ画像(StoryImage) | ストーリーズグループに属する1枚の画像と表示順 |
| フィード(Feed) | フィード画面に表示する投稿とストーリーズアイコン列の並び順を定義した構成データ |
| 編集画面(Edit Screen) | 各フィーチャーにおいて、ダミーデータを入力・編集するための画面 |
| プレビュー画面(Preview Screen) | 実機のSNS画面に似せて全画面表示する、撮影に実際に使う画面 |

## 2. ビジネス用語の定義

| 用語 | 定義 |
|---|---|
| フリーミアム | コア機能を無料で提供し、追加機能を有料で提供する収益モデル |
| コア機能 | Phase 1で定義した全画面(投稿詳細・プロフィール・フォロワー/フォロー一覧・フィード・ストーリーズ)。無料・ウォーターマークなしで提供する |
| 買い切り課金 | 追加機能を一度の購入で恒久的に利用できるようにする課金方式(サブスクリプションではない) |
| ウォーターマーク | 無料版であることを示す透かし。本アプリのコア機能には付与しない方針 |
| フェイク画面メーカーシリーズ | 撮影用の模擬SNS画面を作るアプリ群の総称。LINE版(トーク画面メーカー)、X版(ポスト画面メーカー)、Instagram版(本アプリ)からなる |

## 3. UI/UX用語の定義

| 用語 | 定義 |
|---|---|
| いいね(Like) | 投稿に対する好意的リアクション。件数表示とアイコンのトグル(オン/オフ)操作を持つ |
| キャプション(Caption) | 投稿に付与する本文テキスト |
| サムネイル(Thumbnail) | プロフィール画面のグリッドに表示する縮小画像 |
| グリッド表示(Grid View) | プロフィール画面で投稿サムネイルを格子状に並べる表示形式 |
| 進捗バー(Progress Bar) | ストーリーズ画面上部に表示される、再生位置を示すバー(ストーリーズ枚数分に分割される) |
| タップで次送り | ストーリーズ画面で画面タップにより次のストーリーズ画像へ進む操作 |
| ストーリーズリング | フィード画面上部に表示される、ストーリーズ所有ユーザーのアイコン列(タップでストーリーズ画面へ遷移) |

## 4. 英語・日本語対応表

| 日本語 | 英語(コード上の識別子) |
|---|---|
| 投稿 | `Post` |
| コメント | `Comment` |
| プロフィール | `Profile` |
| フォロワー/フォロー(簡易ユーザー) | `FollowUser` |
| ストーリーズグループ | `StoryGroup` |
| ストーリーズ画像 | `StoryImage` |
| フィード | `Feed` |
| いいね数 | `likeCount` |
| いいね済みフラグ | `isLiked` |
| キャプション | `caption` |
| 投稿時間ラベル | `postedAtLabel` |
| 自己紹介文 | `bio` |
| 投稿サムネイルパス一覧 | `postThumbnailPaths` |
| アイコン画像パス | `iconPath` |
| 一覧種別(フォロワー/フォロー) | `listType`(値: `follower` / `following`) |
| ホーム画面 | `HomeScreen` |
| 投稿編集画面 | `PostEditScreen` |
| 投稿詳細プレビュー画面 | `PostPreviewScreen` |
| プロフィール編集画面 | `ProfileEditScreen` |
| プロフィールプレビュー画面 | `ProfilePreviewScreen` |
| フォロワー一覧画面 | `FollowerListScreen` |
| フォロー一覧画面 | `FollowingListScreen` |
| フィード編集画面 | `FeedEditScreen` |
| フィードプレビュー画面 | `FeedPreviewScreen` |
| ストーリーズ編集画面 | `StoryEditScreen` |
| ストーリーズプレビュー画面 | `StoryPreviewScreen` |

## 5. コード上の命名規則

命名規則(ファイル名・クラス名・変数名等)の詳細は `development-guidelines.md` の「2. 命名規則」を正とする。本節では、本用語集固有の補足のみを記す。

### 5.1 Hive `typeId` 管理台帳

Hiveの`TypeAdapter`は`typeId`の重複がデータ破損の原因となるため、新規モデル追加時は必ず本表に追記してから実装する。

| typeId | モデルクラス | 定義ファイル |
|---|---|---|
| 0 | `Post` | `lib/data/hive/models/post.dart` |
| 1 | `Comment` | `lib/data/hive/models/comment.dart` |
| 2 | `Profile` | `lib/data/hive/models/profile.dart` |
| 3 | `FollowUser` | `lib/data/hive/models/follow_user.dart` |
| 4 | `StoryGroup` | `lib/data/hive/models/story_group.dart` |
| 5 | `StoryImage` | `lib/data/hive/models/story_image.dart` |
| 6 | `Feed` | `lib/data/hive/models/feed.dart` |

### 5.2 Hive Box名

| Box名(定数) | 文字列値 | 格納するモデル |
|---|---|---|
| `postBoxName` | `"posts"` | `Post` |
| `profileBoxName` | `"profiles"` | `Profile` |
| `storyGroupBoxName` | `"story_groups"` | `StoryGroup` |
| `feedBoxName` | `"feeds"` | `Feed` |

`Comment` / `FollowUser` / `StoryImage` は親モデルに埋め込まれる値オブジェクトのため、独立したBoxは持たない(`functional-design.md` 4.3節参照)。
