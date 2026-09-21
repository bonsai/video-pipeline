# JEPISODE スキルセット

JEPISODE 制作に要る「道具」の目録。**不足**は都度ここに追記し、実装は aw-workflow-skill / opencode の skills・agents へ。

## 1. 制作スキル(必須)

| スキル | 役割 |
|---|---|
| `aw-workflow-skill` | パイプラインの組み立て、ノード列の標準(kikaku→…→upload)。参照: `docs/workflow-topology.md` |
| `tts-skill` | Markdown を gtts で読み上げ・再生(レビュー用) |
| `script-writer-skill` | 30 秒早口短編の定型(必要時のみ) |

## 2. 運用スキル(プロセス)

| スキル | 役割 |
|---|---|
| `dev-recap` | セッション状態の保存・引き継ぎ(スクラム日次) |
| `session-kanban` | 1 セッション=1 ボードで kanban+日誌+Epistemic 3問 |
| `daily-outreach` / `nippou` | 朝のプラン・日報(任意) |
| `epistemic-check` | known/unknown/should-know の整理(DoD 判定に使用) |
| `model-manager` / `model-agent-skill` | 実行時モデル選択(執筆/調査の切り替え) |

## 3. 外部・支援スキル

| スキル | 役割 |
|---|---|
| `customize-opencode` | 本スキルセットそのものを編集する手引き |
| `agentic-workflows` / `gh-peco-diff` | GH ワークフロー調査/リポ選択 |
| `lms-manager` | ローカル LLM / embed モデル(ML 埋め込み等、将来) |
| `yt-upload`(上の `vgen` CLI) | YouTube 投稿・OAuth は repo 内 `scripts/yt_oauth.py` |

## 4. CLI ツール(検証済み)

```bash
# 制作(ローカル)
vg list                              # テーマ一覧
vg build  --theme <slug>             # radio.mp3 + thumbnail.png (script)
vg image  --theme <slug>             # bg.png (CF Workers AI)
vg motion --theme <slug>             # motion.mp4 (9:16)
vg short  --theme <slug>             # Short private 投稿 (ローカル)
vg push   --theme <slug>             # 量産DM系 (script以外)

# CI 実行
gh workflow run video-gen -R bonsai/video-gen \
  -f theme=<slug> -f engine=gtts -f image=none -f upload=true

# 認証・環境
bash scripts/cf_refresh.sh           # CF OAuth 1h 更新 (repo/video-gen)
python3 scripts/yt_oauth.py url      # YT 認証 URL 発行 (video-gen)
python3 scripts/yt_oauth.py token '<CODE>'
```

## 5. エージェント(サブ / 役割)

| エージェント | 用途 |
|---|---|
| `explore` | repo/README 調査(n1 research) |
| `general` | article/speech 執筆の並列化、検証 |
| `mito` | SM(計画・進捗・ブロッカー) |
| `minami` / `utaki` | 方向性・決裁(長続きの相談) |
| `model-manager`(skill) | 執筆・調査のモデル選択 |

## 6. 不足メモ(TO DO)

- [ ] 書籍用 md→Kindle 変換(kindlegen / EPUB)を 1 コマンド化
- [ ] note/Qiita/Zenn 投稿スキルの連携(宣伝帯)
- [ ] `voicevox` エンジン検証(ローカル・無料・感情)
- [ ] 公開(private→public)運用のバッチ/自動化(スケジュール投稿)
- [ ] gtts 429 時の sakura 自動フォールバック

## 反映と再起動

- スキルの追加・変更は `~/.config/opencode/` 配下に書いた後、**opencode の再起動**が必要(設定は起動時読込)。
- 本スキルセットの「正」はこのファイル。実装を作るときは aw-workflow-skill を更新した後、ここへ記録する。