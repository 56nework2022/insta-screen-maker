# タスクリスト: 不要な写真/動画権限の削除

## Phase 1: 権限削除

- [x] `android/app/src/main/AndroidManifest.xml` から `READ_MEDIA_IMAGES` / `READ_EXTERNAL_STORAGE` を削除
- [x] `flutter analyze` を実行し、問題がないことを確認(No issues found!)

## Phase 2: バージョン管理

- [x] `pubspec.yaml` のversionCodeを `14` → `15` にバンプ

## Phase 3: ユーザー側での実施(本環境では実行不可)

- [ ] ユーザーが `flutter build appbundle --release` を実行し、AABを再生成
- [ ] 実機で画像選択機能(プロフィール画像・投稿サムネイル等)が引き続き動作することを確認
- [ ] クローズドテストトラックにversionCode 15のAABを再アップロードし、Play Consoleの権限警告が解消されることを確認

## 完了条件

- Phase 1〜2が完了していること
- `requirements.md` の受け入れ条件を満たしていること
- Phase 3はユーザーからの報告を受けて別途記録する
