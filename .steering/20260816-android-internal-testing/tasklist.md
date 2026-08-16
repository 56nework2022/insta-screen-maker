# タスクリスト: Android内部テスト配布

## Phase 1: 署名設定のコード変更

- [x] `android/app/build.gradle.kts` に `key.properties` 読み込み処理を追加
- [x] `signingConfigs.create("release")` を追加し、`key.properties` の値を割り当て
- [x] `buildTypes.release.signingConfig` を新しい `release` 署名設定に切り替え
- [x] `android/key.properties.example`(テンプレート、実パスワードなし)を新規作成
- [x] `android/.gitignore` に `key.properties` / `*.jks` / `*.keystore` が既に含まれていることを再確認(既存のまま、追加対応不要と確認)

## Phase 2: 手順書作成

- [x] `.steering/20260816-android-internal-testing/release-guide.md` を作成
  - キーストア作成手順(`keytool`)
  - `key.properties` の作成手順
  - `flutter build appbundle --release` の実行手順
  - Google Play Console 内部テストトラックへのアップロード・テスター登録手順
  - バージョニング方針(`pubspec.yaml` の `version`/ビルド番号インクリメントルール)
  - トラブルシューティング

## Phase 3: 品質チェック(本環境で可能な範囲)

- [x] `flutter analyze` を実行し、警告・エラーがないことを確認(0件、無関係な `pubspec.lock` の変更は破棄済み)
- [x] `build.gradle.kts` の変更内容をコードレビュー形式で自己確認(Kotlin DSL構文の妥当性、既存debug設定への影響がないこと)

## Phase 4: ユーザー側での実施(本環境では実行不可)

- [x] ユーザーが `release-guide.md` に沿ってリリース用キーストアを作成
- [x] ユーザーが `android/key.properties` を作成(実パスワードを記入、コミットしない)
- [x] ユーザーが `flutter build appbundle --release` を実行し、署名済みAABが生成されることを確認(2026-08-16、`app-release.aab` 46.8MB 生成成功。Windows特有の `Malformed \uxxxx encoding` エラーが発生したが、`storeFile`をフォワードスラッシュ表記に修正して解決)
- [x] プライバシーポリシーページを公開(2026-08-16、`docs/privacy-policy.md` 作成・コミット。`claude-lineapp`/`claude-postapp` と同じ運用パターンを踏襲し、リポジトリをPrivate→Publicに変更、GitHub Pagesを`main`ブランチ`/docs`ソースで有効化。公開URL: https://56nework2022.github.io/insta-screen-maker/privacy-policy.html 、表示確認済み)
- [ ] ユーザーがGoogle Play Consoleでアプリを新規作成し、ストア掲載情報・データセーフティ等の必須項目(プライバシーポリシーURLを含む)を入力
- [ ] ユーザーがGoogle Play Consoleの内部テストトラックにAABをアップロード
- [ ] ユーザーが内部テスターを登録し、テスト用リンクを取得
- [ ] テスターが内部テスト版アプリをインストールし、動作確認できることを確認

## 完了条件

- 本タスクリストのPhase 1〜3が完了していること
- `.steering/20260816-android-internal-testing/requirements.md` の「4. 受け入れ条件」を満たしていること
- Phase 4(ユーザー側での実機操作・Play Console操作)は本環境の制約により、`release-guide.md` の手順整備をもって本タスクリスト上は区切りとする。実施結果はユーザーからの報告を受けて別途記録する
