# 設計: Android内部テスト配布

## 1. 実装アプローチ

コード変更(署名設定の切り替え)はこのリポジトリ内で行うが、以下はこの開発環境(CLIサンドボックス)では実行不可能なため、手順書を整備したうえでユーザー自身のマシンで実施してもらう。

- Java/Android SDKが本環境に存在せず、`flutter build appbundle` 等のビルドコマンドが実行できない
- キーストア(秘密鍵)の生成・保管は、セキュリティ上ユーザー自身のマシンで行うべき(この対話環境やリポジトリに秘密鍵・パスワードを一切残さない)
- Google Play Consoleへのアクセス手段がない

そのため本作業の成果物は次の2種類に分かれる。

1. **コード変更**: `android/app/build.gradle.kts` を、`key.properties` から署名情報を読み込んでreleaseビルドに適用する構成に変更する
2. **手順書**: キーストア作成からPlay Console内部テストへのアップロードまでを、ユーザーがこのまま実行できる形でまとめた `release-guide.md` を作成する

## 2. 変更するコンポーネント

### 2.1 `android/app/build.gradle.kts`

現状、releaseビルドタイプが `signingConfigs.getByName("debug")` を参照している。これを以下のように変更する。

- ファイル先頭で `android/key.properties`(存在すれば)を読み込む
- `signingConfigs` に `release` を追加し、`key.properties` の内容(`storeFile` / `storePassword` / `keyAlias` / `keyPassword`)を割り当てる
- `buildTypes.release.signingConfig` を新しい `release` 署名設定に切り替える
- `key.properties` が存在しない場合(この開発環境や他の開発者のマシンなど)でも `flutter build` (debug) 自体は壊れないようにする。ただし release ビルドを試みて `key.properties` が無い場合はビルドエラーとなる(意図した挙動 — 誤って未署名/デバッグ鍵でのリリースビルドを防ぐ)

参考実装(Flutter公式ドキュメント準拠のKotlin DSLパターン):

```kotlin
import java.util.Properties
import java.io.FileInputStream

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // ...(既存設定はそのまま)

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

### 2.2 `android/key.properties.example`(新規追加・コミット対象)

実際のパスワードを含まない、フォーマットのみを示すテンプレートファイルを追加する。ユーザーはこれをコピーして `android/key.properties` を作成し、実際の値を埋める。

```properties
storePassword=<キーストアのパスワード>
keyPassword=<キーのパスワード>
keyAlias=upload
storeFile=<キーストアファイルへの絶対パス、例: /home/you/upload-keystore.jks>
```

### 2.3 `.gitignore`(確認のみ、変更不要)

`android/.gitignore` に既に以下が含まれていることを確認済み。追加対応は不要。

```
key.properties
**/*.keystore
**/*.jks
```

### 2.4 `pubspec.yaml` のバージョニング方針

- 初回の内部テストアップロードでは現状の `version: 1.0.0+1` をそのまま使用する
- 以降、内部テスト版を再アップロードするたびに `+` 以降のビルド番号(`versionCode`)を必ずインクリメントする(Google Playは同一 `versionCode` の再アップロードを許可しないため)
- リリースノート的な意味合いを持たせたい場合は `1.0.0+1` → `1.0.1+2` のように `version` 部分も適宜更新する

このルールは `release-guide.md` に明記し、コード変更は今回行わない。

## 3. 新規ドキュメント: `release-guide.md`

`.steering/20260816-android-internal-testing/release-guide.md` として、以下の内容をユーザーがそのまま実行できる手順として記載する。

1. リリース用キーストアの作成(`keytool -genkey ...`)
2. `android/key.properties` の作成(`key.properties.example` をコピーして値を埋める)
3. `flutter build appbundle --release` の実行とAABの出力先確認
4. Google Play Consoleでの内部テストトラック作成・テスター登録・AABアップロード手順
5. トラブルシューティング(署名エラー時の確認ポイント等)

## 4. 影響範囲の分析

- **影響するファイル**: `android/app/build.gradle.kts`(変更)、`android/key.properties.example`(新規)、`.steering/20260816-android-internal-testing/release-guide.md`(新規)
- **影響しないもの**: アプリのDartコード(`lib/` 配下)、既存テスト、`pubspec.yaml` の依存関係。機能面の変更は一切なし
- **リスク**: `build.gradle.kts` の変更ミスがあると `flutter build` (debug含む)自体が壊れる可能性があるため、既存のdebugビルド設定には触れず、release署名設定のみを追加する形にとどめる
- **検証方法**: 本サンドボックスではAndroidビルドツールチェーンがないため、コードレビューでの確認までとし、実際の `flutter build appbundle --release` 実行はユーザーのマシンで行う(Phase 7の実機確認と同様の制約)
