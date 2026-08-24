# 要求内容: 不要な写真/動画権限の削除

## 1. 背景・目的

クローズドテストのPlay Console審査で、「写真と動画」に関する未申告権限として `android.permission.READ_MEDIA_IMAGES` が指摘された。Googleのポリシーでは、写真/動画へのアクセスが一度だけ・頻繁でないアプリはAndroidの写真選択ツール(Photo Picker)へ移行することが求められている。

## 2. 現状確認結果

- `android/app/src/main/AndroidManifest.xml` に `READ_MEDIA_IMAGES` と `READ_EXTERNAL_STORAGE`(maxSdkVersion=32)が明示的に宣言されている
- アプリのコード上は `lib/core/widgets/image_picker_field.dart` から `ImagePicker().pickImage(source: ImageSource.gallery)` を1枚ずつ呼ぶのみ(プロフィール画像・投稿サムネイル等)
- 使用中の `image_picker_android` プラグイン(0.8.13+17)自体のマニフェストにはこれらの権限が含まれておらず、Android Photo Picker経由で権限不要にアクセスする実装になっている
- 結論: アプリ側マニフェストの2行は不要な宣言であり、削除すればPhoto Picker移行の要件を満たせる

## 3. スコープ

### 今回対応する内容
- `AndroidManifest.xml` から `READ_MEDIA_IMAGES` / `READ_EXTERNAL_STORAGE` の宣言を削除
- `flutter analyze` で問題がないことを確認
- 動作確認(画像選択機能が引き続き動作すること)
- 次回アップロード用にversionCodeをバンプ

### 今回対応しないこと(スコープ外)
- Play Console上の「メディア画像を読み取る」質問フォームへの回答(権限自体をなくすため、フォーム回答は不要になる想定)
- image_picker以外の画像アクセス方法の追加

## 4. 受け入れ条件

- [ ] `AndroidManifest.xml` から該当2行が削除されている
- [ ] `flutter analyze` がクリーン
- [ ] `pubspec.yaml` のversionCodeがバンプされている
- [ ] コミット・プッシュ済み

## 5. 制約事項

- 実機でのビルド・動作確認は本環境では実行できないため、ユーザーのWindows機で `flutter build appbundle --release` 実行後、画像選択機能(プロフィール画像・投稿サムネイル等)が問題なく動くことを確認してもらう
