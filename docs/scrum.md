# JEPISODE スクラム

2 週間スプリントで「企画→YouTube」まで 1 本を完走し、3 ヶ月(11月〜12月)で Kindle 原稿 12 章 + 12 本の動画を狙う。

## ロール

| ロール | 担当 | 責務 |
|---|---|---|
| PO | ユーザー | 話の承認・方向決め・IP 維持・公開判断(private→public) |
| SM | mito(運用PM) | 計画・進捗・ブロッカー検出・チーム調整・タイムボックス |
| Dev | 本エージェント + サブ(explore/general) | kikaku〜article〜speech 執筆、動画生成、CI 実行 |
| 検証 | CI(GH Actions `video-gen`) | 音声・画像・動画・YT 投稿の回帰 |

## カレンダー(1 スプリント = 2 週)

```
月(開始) スプリント計画: バックログから 2 話を選定。テーマ(客キャラ)と IP フック(ミッション宣言)を決める
月〜金    日次 check-in: 「いま何がわかっているか/わかってないか/わかるべきか」(dev-recap)
金(奇数週) スプリントレビュー: 動画を private 公開し PO が確認。放送可否・修正点
金(偶数週) 振り返り: ボトルネック(tts 429 / 画像 / レビュー待ち)を記録
```

## バックログ規約

- 表記: 状態 `[Backlog|Doing|Done]`、`#N 話slug`、担当、DoD チェック。
- kanban 正: `kanban/JEPISODE.md`。
- 1 話の DoD:
  1. `kikaku.md`(IP フック4種 + 章名)が書けている
  2. `article.md`(4,000-6,000字・書籍1章相当)が書けている
  3. script.md で `vg build` が通り radio.mp3 + thumbnail.png が出る
  4. `vg motion` で motion.mp4(9:16)が出る
  5. `vg short`(または CI upload=true)で YouTube private 投稿、URL 記録
  6. (任意) note/Qiita/Zenn またはブログに公開

## タイムボックス

- 1 話の目標: 企画・原稿(1日) / 検証動画(1日) / 公開判断(半日)。最大 3 日で 1 本。
- 12 話 × 3 日 = 36 日 ≒ 10 週。11月末までに第一次 12 話、12月は Kindle 編集に専念。

## リスクと対策

| リスク | 影響 | 対策 |
|---|---|---|
| gtts 429 レート制限 | 音声遅延 | P=3・リトライ、大量は sakura へ切替 |
| CF 画像無料枠枯渇 | 背景なし | gradient fallback(bg 無しでも動画は成立) |
| YT 投稿上限/著作権 | 公開待ち | private 運用を前提、後から public |
| レビュー待ち | 進捗停滞 | SM がタイムボックス強制・Po 判断を朝に固定 |
| 技術書典 申込期限切れ | Kindle のみ | 12月 KDP を主軸に変更(収益目標は不変) |

## 継続は how を変える

- 記録: `dev-recap`(状態の引き継ぎ) / `nippou`(日報) / `session-kanban`(1セッション=1板)。
- 判断: 記事で済ませるか動画まで行くかは「宣伝帯 vs 書籍章」で区別。