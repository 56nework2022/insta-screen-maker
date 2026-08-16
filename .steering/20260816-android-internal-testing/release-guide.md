# リリース手順書: Android内部テスト配布

本手順は、あなた自身のマシン(このCLIサンドボックス環境ではなく、Android SDK/Javaが使えるローカルPC)で実施してください。
キーストアのパスワード等の機密情報は、Claudeとの会話やリポジトリに書き込まないでください。

## 0. 前提

- Flutter SDK / Android SDK / JDKがローカルにインストール済みであること(`flutter doctor` で問題ないことを確認)
- Google Play Consoleの開発者アカウントが準備済みであること(確認済み)
- このリポジトリを `git pull` などで最新化していること(`android/app/build.gradle.kts` の署名設定変更が反映されていること)

## 1. リリース用キーストアの作成

初回のみ実施します。**一度作成したキーストアは紛失・変更すると、以後同じアプリ(同じ `applicationId`)を更新できなくなるため、安全な場所にバックアップしてください。**

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

- 実行すると、パスワードや氏名・組織名などの入力を求められます。パスワードは安全に(パスワードマネージャー等に)保管してください。
- 保存先は `~/upload-keystore.jks` としていますが、任意の安全な場所で構いません(リポジトリ内には置かないこと)。

## 2. `android/key.properties` の作成

リポジトリ直下ではなく `android/` ディレクトリの直下に、`android/key.properties.example` をコピーして作成します。

```bash
cp android/key.properties.example android/key.properties
```

`android/key.properties` を開き、以下を実際の値に書き換えます。

```properties
storePassword=<手順1で設定したキーストアのパスワード>
keyPassword=<手順1で設定したキーのパスワード>
keyAlias=upload
storeFile=/Users/you/upload-keystore.jks  # 手順1で保存したキーストアの絶対パス
```

**Windowsの場合の注意**: `storeFile`にバックスラッシュ(`C:\Users\...`)をそのまま書くと、Javaのプロパティファイルではバックスラッシュがエスケープ文字として解釈され、`Malformed \uxxxx encoding`エラーでビルドが失敗します。必ずフォワードスラッシュで書いてください。

```properties
storeFile=C:/Users/you/upload-keystore.jks
```

このファイルは `.gitignore` により追跡対象外になっているため、`git status` で `key.properties` が出てこないことを確認してください(誤ってコミットしないための最終チェック)。

## 3. バージョン番号の確認

`pubspec.yaml` の `version:` を確認します。

```yaml
version: 1.0.0+1
```

- `+` の後ろの数値(ビルド番号 = `versionCode`)は、Google Playへ再アップロードするたびに必ず増やす必要があります(同じ番号は再アップロード不可)。
- 初回アップロードは `1.0.0+1` のままで問題ありません。2回目以降は `1.0.0+2`、`1.0.0+3` のように増やしてください。

## 4. App Bundle(AAB)のビルド

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

成功すると、以下にAABが生成されます。

```
build/app/outputs/bundle/release/app-release.aab
```

エラーが出る場合は「6. トラブルシューティング」を参照してください。

## 5. Google Play Consoleへのアップロード

1. [Google Play Console](https://play.google.com/console) にログインし、対象アプリを開く(初回の場合はアプリを新規作成し、`applicationId`: `com.picapp.instascreenmaker.insta_screen_maker` と一致させる)
2. 左メニューの「テスト」→「内部テスト」を開く
3. 「新しいリリースを作成」をクリック
4. Play App Signingへの登録が初回は求められる場合があるので、画面の指示に従って有効化する(アップロードした鍵とは別に、Google側が最終的な配布用署名を管理する仕組み。手順1〜4のアップロード鍵とは役割が異なる)
5. 「アプリバンドルをアップロード」で `build/app/outputs/bundle/release/app-release.aab` を選択
6. リリースノート(簡単な説明でよい)を入力し、保存 → 内部テストとして公開
7. 「テスター」タブでテスターのメールアドレス、または既存のGoogleグループ/Googleドライブのリンクを設定
8. 発行された「テスト参加用リンク」をテスターに共有する

## 6. トラブルシューティング

- **`Malformed \uxxxx encoding` エラー(Windows)**: `key.properties`の`storeFile`にバックスラッシュ(`C:\Users\...`)をそのまま書いていることが原因です。フォワードスラッシュ(`C:/Users/...`)に書き換えてください。
- **`Keystore file '...' not found` エラー**: `android/key.properties` の `storeFile` のパスが間違っている、または相対パスと絶対パスを混同している可能性があります。絶対パスを指定してください。
- **`Failed to read key ... from store` エラー**: `storePassword` / `keyPassword` / `keyAlias` のいずれかが手順1で設定した値と一致していません。
- **署名なしで `flutter build appbundle` が成功してしまう(debug鍵で署名されている)**: `android/key.properties` が存在しない状態でビルドすると、`signingConfigs.release` の各値が `null` になり、Gradleがエラーを出さずデフォルト動作にフォールバックする場合があります。ビルド後に以下のコマンドで実際に使われた署名鍵を確認してください。

  ```bash
  keytool -printcert -jarfile build/app/outputs/bundle/release/app-release.aab
  ```

  ここで表示される証明書の情報が、手順1で作成したキーストアのものと一致していることを確認してください。
- **Play Consoleで「バージョンコードが既に使用されています」と表示される**: 手順3に従って `pubspec.yaml` の `version` のビルド番号を増やし、再ビルド・再アップロードしてください。

## 7. 今後のリリースサイクル

2回目以降の内部テスト配布は、手順1・2(キーストア作成・`key.properties`作成)は不要で、手順3〜5(バージョン番号更新・ビルド・アップロード)のみを繰り返します。
