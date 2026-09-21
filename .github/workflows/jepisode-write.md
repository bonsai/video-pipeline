---
emoji: 🎬
description: 指定された JEPISODE の「書く側」(企画・記事・台本)を産出する。workflow_dispatch で episode と slug を指定すると、kikaku→research→article→speech の 4 段階を通して PR を作る。
intent: 対象話を書籍 1 章相当の品質で書き下ろし、人間(publish)がレビューできる PR にする
on:
  workflow_dispatch:
    inputs:
      episode:
        type: string
        description: 話数(1-12 / backlog の #N)
        required: true
      slug:
        type: string
        description: 対象リポジトリ `owner-repo` 例 `bonsai-furui`(空なら episode のあらすじを参照)
        required: false
concurrency:
  job-discriminator: "${{ github.run_id }}"
permissions:
  contents: read
  pull-requests: read
  issues: read
tools:
  github:
    mode: gh-proxy
    toolsets: [default]
safe-outputs:
  create-pull-request:
    allowed-files:
      - "content/**"
      - "data/programs/**"
---

# JEPISODE 執筆(企画 → 記事 → 台本)

## Task

1. **定位置の整理**:
   - `docs/jepisode-01-12.md` のあらすじ、`docs/characters.md` の客キャラ、`docs/ontology.md` の用語、`docs/workflow-topology.md` の段階を読む。
   - `kanban/JEPISODE.md` を読み、指定 `episode` の状態を確認する。
   - `slug` があれば、対象リポジトリの README / docs / API 面を調査する(`gh repo view` / `gh api` を利用。エージェントは GitHub 読み取りのみ)。

2. **ノードを順に実行**: 順序は必ず kikaku → research → article → speech。
   - **kikaku(企画)** `content/<slug>/kikaku.md`:
     - ミッション宣言(ゴルゴ軸)を冒頭 3 行で。寡黙・一撃必殺・契約遂行
     - くだらない軽口(ルパン軸)を 1 回以上
     - 働く男の物差し(島工作軸)で締める語彙
     - アーキテクチャ/型/コスト原価の高スぺ展開を 1 段落以上
     - 書籍章名もここで決める
   - **article(記事)** `content/<slug>/article.md`: 約 4,000-6,000 字。書籍 1 章原稿として成立させる
   - **speech(90秒台本)** `content/<slug>/speech-90s.md` と `data/programs/<slug>/script.md` の両方: 約 600-700 字、文単位の句点区切り、`#構成:` メタ行で締める
   - **blog(任意)** `content/<slug>/blog.md`: 宣伝帯用

3. **Safe Outputs**: 生成結果は `create-pull-request` のみで出す。PR タイトルは `[JEPISODE]<episode> <slug> 執筆`、本文に 企画・台本の要点、DoD チェックリスト、`kanban/JEPISODE.md` の状態遷移案を書く。
   - PR は `content/**` と `data/programs/**` に限定する。
   - 既に同じスコープの PR が open なら新しい PR を作らず、既存 PR に追記方針を提案する。

4. **noop**: 以下の場合は `noop` で短い理由を返す。
   - 指定 `episode` が 1-12 の backlog に無い
   - 対象情報が不足し、kikaku の IP フック(ミッション宣言)が書けない
   - 既存の `content/<slug>/` に同一品質の成果物が揃っており改善余地がない

5. **逐次原則**: 書き始める前に必ず kikaku を確定する。article は speech の前に書き、speech は article の構造から導出する。書籍 1 章(article)が無い状態で speech だけを量産しない。

## 言語

日本語。対象 repo が日本語 README ならそれに合わせ、そうでなくとも文体は JEPISODE(請負屋)の口調を維持する。