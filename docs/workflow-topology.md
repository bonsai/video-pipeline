# JEPISODE ワークフロートポロジー

> 定義対象: JEV 解説シリーズ「JEPISODE」における、1 話のコンテンツを **台本→音声→絵→動画→YouTube** に至る制作パイプライン。
> 正(シングルソース): `~/git/github.com/bonsai/video-gen` の vgen CLI + 本ドキュメント。

## 原則

- **1 ノード = 1 成果物**。ノードは入力から出力を作り、出力は `data/<slug>/` にファイルとして残る(途中から再開できる)。
- **文責分離**: 人間(承認)・エージェント(企画/原稿)・機械(生成)・CI(自動実行)をノードごとに明示する。
- **ローカル先行**: パイロットはローカルで完走し、その後 GH Actions へ移す(今は両対応)。
- **コスト原則**: 無料(gtts・CF無料枠)→ 安価(sakura)。有料TTSは既定しない。

## トポロジー(1 話)

```
GATE(入力検証: theme 存在 / secret 充足 / 原稿の文字数)
  │
  n0  kikaku   企画書                     → content/<owner>-<repo>/kikaku.md      [agent]
  n1  research 対象repo調査               → メモ(kikaku.md 更新)                 [agent]
  n2  article  紹介記事(書籍1章原稿)      → content/.../article.md               [agent]
  │
  │  ┌── script モード(vgen) は speech 単独でも可 ──┐
  n3  speech   90秒スピーチ原稿           → data/programs/<slug>/script.md       [agent]
  n4  tts      音声化                     → data/audio/<slug>/radio.mp3          [vgen build / CI gtts|sakura]
  n5  image    背景画像(任意)             → data/<slug>/bg.png                   [vgen image / CF Workers AI・無料枠]
  n6  thumb    サムネイル 1080x1920       → data/<slug>/thumbnail.png            [vgen build(script分岐)]
  n7  motion   縦動画 9:16               → data/<slug>/motion/motion.mp4         [vgen motion(scriptモード)]
  n8  upload   YouTube private Short 投稿 → https://youtu.be/<id>                [vgen short|push / ローカル or CI]
  │
  └─ 分岐(宣伝帯)
     note / Qiita / Zenn          記事(article.md の再構成)      [agent + 手動投稿]
     Kindle(12月軸)               article.md 群 = 書籍の章原稿    [agent 編集 → KDP]
```

`n4` と `n6` は同一コマンド `vg build --theme <slug>` が担う(radio.mp3 + thumbnail.png 同時生成)。
`n7` は `vg motion --theme <slug>`, `n8` は `vg short`(script モードではプレイリスト非使用)または `vg push`(量産DM系)。

## 境界と実行体

| 境界 | 実行体 | 認証・憑藉 |
|---|---|---|
| ローカル | `vg`(/gui ~/.local/bin) | `~/secrets/yt-upload/` (YT OAuth)、`.env` apiキー、CF OAuth(cf_refresh.sh で1hごと更新) |
| CI | GitHub Actions `bonsai/video-gen` `video-gen` WF | GH secrets: `SAKURA_API_KEY`,`YT_CLIENT_ID`,`YT_CLIENT_SECRET`,`YT_REFRESH_TOKEN`,`CF_ACCOUNT_ID`,`CF_API_TOKEN` |
| 承認 | ユーザー | 企画・公開(private→public)は人間が判断 |

実行は `gh workflow run video-gen -R bonsai/video-gen -f theme=<slug> -f engine=gtts -f image=[none|cf] -f upload=[false|true]`。

## GATE(段階の前提)

- n3 前: 原稿 600-700 字(句点区切り, `#構成:` メタ行は TTS strip 対象)
- n4 前: script.md 存在 / TTS_ENGINE の key が揃う
- n6 前: bg.png を敷くか(false ならグラデのみ)
- n8 前: YT クレデンシャルが ローカル or CI のどちらかに存在 / video と audio が存在

## 再開可能性

各ノード出力はファイルとして残る。GATE が出力存在でショートカットできるため、
`tts → image → video → upload` だけの再実行が可能。CI は毎回フレッシュ checkout のため
playlist_id 等の永続状態は扱わない(script モードは upload のみ行う)。

## 関連

- 企画: `docs/jepisode-plan.md` / `jepisode-01-12.md`
- 用語: `docs/ontology.md`
- 運用: `docs/scrum.md` / `kanban/JEPISODE.md`
- 道具: `docs/skillset.md`