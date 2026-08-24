# タスクリスト: 投稿サムネイルのプレビュー表示不具合の修正

## タスク

- [x] `post_grid_screen.dart` の `Image.file` に `errorBuilder` を追加し、
      読み込み失敗時にプレースホルダー(灰色背景 + 壊れた画像アイコン)を表示する
- [x] `profile_edit_screen.dart` のサムネイル表示を `DecorationImage` から
      `Image.file(..., errorBuilder: ...)` ベースに変更し、同様のプレースホルダーを表示する
- [x] `flutter analyze` を実行し、新規の警告・エラーがないことを確認する (No issues found!)
- [x] `flutter test` を実行し、既存テストがすべてパスすることを確認する (20 tests, All tests passed!)
- [x] ユーザーに実機での確認を依頼する(壊れた画像アイコンが出るか、正常に画像が表示されるか)

## 完了条件

- 上記タスクがすべて完了している
- `flutter analyze` / `flutter test` がグリーン → 達成
- ユーザーへ実機確認の依頼と、原因切り分けのための質問(壊れたアイコンが表示されるかどうか)を共有済み → 完了(2026-08-24 実機確認済み)
