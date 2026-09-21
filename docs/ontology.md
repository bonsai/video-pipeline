# JEPISODE オントロジ

JEV 解説シリーズ「JEPISODE」の語彙・概念体系。用語は本シリーズと vgen/CI パイプラインで一意に使う。

## 1. 作品層

- **JEV**: 解説対象のプロダクト。TypeSafe AI が 2026-09-15 発表した System One モデル。
  文章非生成・並列サンプラー(70-500ms)・3種のプリミティブのみ。
- **JEPISODE**: 本シリーズ名。1話 = 1つの OSS/概念を 90 秒で解く。
- **テーマ(theme)**: 1 話の設定。`themes/<slug>.json` が正。ワイン職人・寿司職人など「客キャラ」と対応。
- **話(Episode)**: `#1..#12` の通し番号。企業企画は `docs/jepisode-01-12.md` のあらすじが原文。

### コンテンツ種別
| 種別 | ファイル | 用途 |
|---|---|---|
| kikaku | `content/<owner>-<repo>/kikaku.md` | 企画書(ミッション宣言・軽口・物差し・高スぺ) |
| article | `.../article.md` | 紹介記事 = 書籍 1 章原稿(4,000-6,000字) |
| blog    | `.../blog.md`                | ブログ(宣伝帯) |
| speech  | `.../speech-90s.md` または `data/programs/<slug>/script.md` | 90 秒朗読原稿(600-700字) |
| 動画系  | radio.mp3 / bg.png / thumbnail.png / motion.mp4 | tts(image)thumb→motion の出力 |

## 2. IP 層(請負屋)

- **請負屋**: 本シリーズの語り手(ダークヒーロー)。ゴルゴ13(寡黙・一撃必殺・ミッション宣言) × ルパン三世(くだらない軽口1回) × 島耕作(働く男の物差し)。
- **客キャラ**: テーマごとの依頼人。世話として Jev を例える。
  - 樽田三朗(ワイン職人・#1 検証済み) — 以降: 寿司職人 / 銀行審査役 / パイロット / 刑事 / 鳶職など(`docs/characters.md`)
- **IP フック(elements)**: 各話に必ず入れる 4 種。
  1. ミッション宣言(ゴルゴ軸) — 冒頭3行で「標的をどう一撃で仕留めるか」
  2. 軽口(ルパン軸) — 知識がある男にだけ通じるダジャレを 1 回
  3. 物差し(島工作軸) — 職場・単価・残業の語彙で測る
  4. 高スぺ展開 — 型/アーキテクチャ/コスト原価の段落を 1つ以上

## 3. 制作層(パイプライン)

- **ノード(node)**: 1 成果物を作る最小工程。kikaku→research→article→speech→tts→image→thumb→motion→upload。
- **GATE**: ノード実行前の前提検証(入力存在・secret 充足・文字数)。
- **状態(state)**: ノード間で引き渡す。ファイル出力が事実上の state。
- **成果物(artifact)**: `data/<slug>/` と `content/` に残る履歴。
- **境界**: local(手動・秘密鍵あり) / CI(GH Actions・secrets 注入)。

## 4. 実行層(tooling)

- **vg**: vgen CLI(`~/git/github.com/bonsai/video-gen`)。`list/build/thumb/image/motion/short/push`。
- **TTS エンジン**: gtts(無料・既定) / sakura(安価・API key) / voicevox(ローカル)。`TTS_ENGINE` で選択。
- **画像生成**: CF Workers AI flux-1-schnell(無料枠)。`vg image --theme <slug>`。
- **認証**: YT OAuth(installed-app クライアント)→ `~/secrets/yt-upload/` または GH secrets。
- **CF トークン**: OAuth refresh で 1 時間更新(`scripts/cf_refresh.sh`)。CI は長命 API トークンを使用。

## 5. 運用層(プロセス)

- **ロール**: PO(ユーザー) / SM(mito) / Dev(本エージェント+サブ) / CI(検証)。
- **イベント**: スプリント計画・日次check-in・レビュー・振り返り(`docs/scrum.md`)。
- **backlog 状態(FIFO)**: Backlog → Doing → Done(DoD あり)。kanban:`kanban/JEPISODE.md`。

## 6. 得失の物差し(収益)

- 広告単価: 「大人の男(業務系30-50代)」語彙で縦動画を測る。
- 収益軸: **Kindle 出版(12月・KDP)** = article.md 群を録章。note/Qiita/Zenn は宣伝帯。
- 技術書典は申込締切(6-7月頃)が過ぎている可能性 → 出展可否は要確認。

## 用語が衝突したとき

- 本シリーズ内では本オントロジが正。外部(aw / gh-aw / MEGA等)と衝突する場合は文脈で判断し、ここへ追記する。