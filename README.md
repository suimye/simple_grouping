<p align="center">
  <img src="icon/icon_1024.png" width="160" alt="GroupMaker icon">
</p>

<h1 align="center">GroupMaker</h1>

<p align="center">名前のリストとグループ数を入れるだけで、ランダムにグループ分けする macOS アプリ</p>

---

## 特長

- 名前を **コンマ区切り** で入力（全角の `，` `、` や改行区切りでもOK）
- グループ数を指定して **ワンクリック（⌘ + Return）** でグループ分け
- 乱数には macOS の `SystemRandomNumberGenerator`（暗号学的に安全な乱数）を使用
- 各グループの人数差は最大 1 人になるよう均等に配分
- 結果をテキストでクリップボードにコピー可能
- SwiftUI 製の単一ファイルアプリ。Xcode プロジェクト不要

## 動作環境

- macOS 14 (Sonoma) 以降
- Swift コンパイラ（Xcode または Command Line Tools）

```bash
xcode-select --install
```

## ビルド

```bash
git clone https://github.com/suimye/simple_grouping.git
cd simple_grouping
./build.sh
```

`GroupMaker.app` が生成されます。ダブルクリックで起動するか、`アプリケーション` フォルダへドラッグしてください。

```bash
open GroupMaker.app
```

> ad-hoc 署名のため、他の Mac にコピーして初回起動する際は Finder で右クリック →「開く」を選んでください。

## 使い方

1. 上部の欄に名前を入力します（例: `田中, 佐藤, 鈴木, 高橋, 伊藤, 渡辺`）
2. 「グループ数」を入力、またはステッパーで調整します
3. 「グループ分け」ボタン（⌘ + Return）を押すと結果が表示されます。押すたびに組み合わせが変わります
4. 「コピー」で結果を以下の形式でクリップボードにコピーできます

```
グループ 1: 鈴木, 田中
グループ 2: 渡辺, 佐藤
グループ 3: 伊藤, 高橋
```

## 仕組み

名前リストを `shuffled(using: &SystemRandomNumberGenerator)` でシャッフルし、先頭から順にグループ 1, 2, …, N, 1, 2, … と配っていきます。

## ファイル構成

| ファイル | 内容 |
|---|---|
| `GroupMaker.swift` | アプリ本体（SwiftUI） |
| `build.sh` | `.app` バンドルを作るビルドスクリプト |
| `icon/make_icon.swift` | アプリアイコンを描画するスクリプト |
| `icon/icon_1024.png` | アイコン画像（1024×1024） |

アイコンを作り直す場合:

```bash
swift icon/make_icon.swift icon/icon_1024.png && ./build.sh
```

## ライセンス

[MIT License](LICENSE)
