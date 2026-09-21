# 企画 #1 — TypeSafe Jev 「Jev とは / System One モデル総論」

- repo: https://github.com/typesafe-ai 系(TypeSafe Jev / typesafe-jev)
- 章名(書籍仮): 序・第2章 「Jev とは — 文章を書かない判断モデル」
- 状態: 企画確定 v1 (2026-09-21)

## IP フック(ミッション宣言・ゴルゴ軸)

「標的は判断。弾は型付きの答えだけ。一発で仕留める AI が出た。」→ ミッション: 判断を 70-500ms で撃ち抜く。報酬: 入力 100 万トークン 4 セント強。
くだらない一回(ルパン軸): 「LLM が文字を一文字ずつ書いてる間に、こっちはもう撃ち終えてる。」

## 高スぺ展開の芯

- 3 プリミティブ(Choice / Score / Noul)と返り値の構造
- RLCD(較正済み強化学習)= 信頼度が当たる
- 並列サンプラー = 非自己回帰・70-500ms・出力無料(¥ $0.042/1M inputs)
- 「型安全」は出力の形の保証であり「判断の正しさ」の保証ではない(使いどころ: 確率で分岐して低信頼は人へ)

## 参考(調査から)

- 発表: 2026-09-15 TypeSafe AI「Introducing System One Models and Jev」
- 語源: System One = カーネマン『ファスト&スロー』、Jev = 経済学者 Jevons(知能のコスト低下で需要拡大)
- 実測記事: ai-native.jp / ai-souken.com / Qiita×複数 で比較検証済み(日本精度・SLA・将来の落とし穴は控えめに書く)

## アウトプット計画

- speech-90s.md(本作成) / article.md(次段・書籍 1 章分) / blog.md → note+Qiita 転載

*企画段階の成果物。次のノードは research 済み → article → speech の順で進む。*