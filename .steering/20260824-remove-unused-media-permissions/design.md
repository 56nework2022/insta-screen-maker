# 設計: 不要な写真/動画権限の削除

## 1. 実装アプローチ

`AndroidManifest.xml` から不要な `<uses-permission>` を2行削除するのみ。コードロジックの変更は不要(`image_picker` の呼び出し方はそのまま)。

## 2. 変更するコンポーネント

### 2.1 `android/app/src/main/AndroidManifest.xml`

以下の2行を削除する。

```xml
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32"/>
```

削除後もimage_pickerプラグインは自動的にAndroid Photo Picker(権限不要)を使用するため、機能面の影響はない。

### 2.2 `pubspec.yaml`

versionCodeを1つバンプする(直近は`14`。Play Console側の実際の状況次第で番号がずれる可能性がある点は既存の運用ルールどおり)。

## 3. 影響範囲の分析

- **影響するファイル**: `android/app/src/main/AndroidManifest.xml`(変更)、`pubspec.yaml`(バージョンバンプ)
- **影響しないもの**: Dartコード(`lib/`配下)は変更なし。画像選択のUI/挙動は変わらない(Photo Picker経由のまま)
- **リスク**: 低い。権限削除により画像選択が壊れる可能性はほぼないが、念のためユーザーに実機での動作確認を依頼する
- **検証方法**: 本環境では `flutter analyze` のみ。実機ビルド・動作確認はユーザーのWindows機で実施
