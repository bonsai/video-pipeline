# kanban: JEPISODE

> 運用ルール: `docs/scrum.md`。DoD は全 6 項目(企画/記事/音声/動画/YT/公開)。
> あらすじは `docs/jepisode-01-12.md`、キャラは `docs/characters.md`。

## Backlog

- [#03] bonsai/furui — 判断特化AIの塀の内側(イメージ=墓標? → notyet)
- [#04] bonsai/shizuka — 掃除婦が型で掃除する
- [#05] bonsai/bons.ai — スコアだけを並べる男
- [#06] bonsai/ast-editor — 型付きエディタの請負
- [#07] bonsai/goemon — 五右衛門が湯に浸かる(並列サンプラー)
- [#08] bonsai/podcast-generator — 音声で記録を仕事にする
- [#09] bonsai/music-bigdata — 音楽をデータで測る
- [#10] bonsai/idol-db(+playlist) — 地下アイドルをファンクラブで
- [#11] codex / claude-code — 型なし外注に一矢
- [#12] 総括 — 請負屋の仕事納め(書籍の結章)

## Doing

- [#01] typesafe-jev — kikaku.md / speech-90s.md 済・article.md 未 → **次: article 執筆**

## Done

- [#02] uehaj-jev-semgrep — article/blog/speech + mp3/mp4 完成
- [pilot] jev-wine テーマ — ローカル動画(YT private: YdnZICIRgO8) + CI(YT private: hkm9wfjH1uk) まで完走
  = パイプラインの検証完了(トポロジー/認証/CI すべて通る)

## 検証環境メモ

- ローカル: `~/git/github.com/bonsai/video-gen` ⇔ 旧シンボリックリンク `~/projects/video-gen`(現・消失, 使うなら再作成)
- CI secrets: SAKURA_API_KEY / YT_CLIENT_ID / YT_CLIENT_SECRET / YT_REFRESH_TOKEN / CF_ACCOUNT_ID 設定済(CF_API_TOKEN のみ dashboard で要作成)
- トークン: YT OAuth refresh 有効。CF OAuth は 1h ごと cf_refresh.sh