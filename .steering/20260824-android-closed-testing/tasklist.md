# タスクリスト: Android クローズドテスト移行

## Phase 1: 手順書作成(本環境で実施)

- [x] `.steering/20260824-android-closed-testing/release-guide.md` を作成
  - versionCode確認・更新手順
  - クローズドテストトラック作成手順
  - テスターリスト設定方法(メール直接登録 / Googleグループの2案)
  - 12人×14日間要件の運用方針(起算日の注意点、進捗確認方法)
  - テスト参加用リンクの共有方法
  - トラブルシューティング

## Phase 2: ユーザー側での実施(本環境では実行不可)

- [ ] ユーザーがPlay Console上で直近使用済みのversionCodeを確認し、`pubspec.yaml` を更新
- [ ] ユーザーが `flutter build appbundle --release` を実行し、AABを再生成
- [ ] ユーザーがGoogle Play Consoleでクローズドテストトラックを新規作成し、AABをアップロード
- [ ] ユーザーがテスターリストの登録方法(案A/案B)を選択し、テスターを登録
- [ ] ユーザーがテスト参加用リンクをテスターへ共有し、オプトインを依頼
- [ ] 12人のテスターがオプトインし、14日間の継続参加を開始したことをPlay Console上で確認

## 完了条件

- Phase 1(手順書作成)が完了していること
- `.steering/20260824-android-closed-testing/requirements.md` の「4. 受け入れ条件」を満たしていること
- Phase 2(ユーザー側でのPlay Console操作・12人×14日の要件達成)は本環境の制約により、手順書の整備をもって本タスクリスト上は区切りとする。実施結果はユーザーからの報告を受けて別途記録する
