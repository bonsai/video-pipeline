---
name: jev-video-pipeline
description: >
  台本(speech*.md)から TTS 音声と mp4 動画を量産する Jev 系コンテンツパイプライン。
  起動キーワード：「動画作って」「video pipeline」「TTS」「台本から動画」「jepisode」「音声生成」「mp4生成」「コンテンツ量産」で発動。
  スクリプト: `make_tts.sh` / `make_video.sh` / `run_all.sh`
---

# Jev 動画パイプライン (jev-video-pipeline)

`content/*/speech*.md` を読み、TTS→フレーム→mp4 へ一括変換する。ディレクトリごとに1話として処理される。

## 使い方

```bash
./run_all.sh          # content 配下を全話処理
./make_tts.sh         # 音声のみ
./make_video.sh       # 音声あり前提で動画合成
```

成果物は `tts/` `videos/`。台本仕様は `docs/jepisode-plan.md`・`docs/characters.md` 参照。

## 主要ファイル

- `make_tts.sh` / `make_video.sh` / `run_all.sh` — パイプライン本体
- `docs/` — 台本計画・登場人物・ontology・scrum・skillset
- `content/` `kanban/` `assets/` `tts/` `videos/`

## 関連

- [aw-workflow-skill](../aw-workflow-skill/SKILL.md) — マルチステージ pipeline 標準
- [tts-skill](../tts-skill/SKILL.md) / [tts-selector-skill](../tts-selector-skill/SKILL.md) — TTSエンジン
- [youtube](../youtube/SKILL.md) — アップロード
