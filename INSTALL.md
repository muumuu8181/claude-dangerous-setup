# 📦 インストールガイド

Claude Code Safe Dangerous Mode Setup の詳細インストール手順

## 🎯 インストール方法

### 方法1: 自動インストール（推奨）

```bash
# GitHubからクローンして即実行
git clone https://github.com/muumuu8181/claude-dangerous-setup.git
cd claude-dangerous-setup
./claude-dangerous-setup.sh
```

### 方法2: スクリプトダイレクト実行

```bash
# スクリプトを直接ダウンロードして実行
curl -sL https://github.com/muumuu8181/claude-dangerous-setup/raw/main/claude-dangerous-setup.sh | bash
```

### 方法3: 手動インストール

```bash
# 1. 必要パッケージの手動インストール
pkg install proot git curl nodejs python openssh

# 2. セットアップスクリプトダウンロード
wget https://github.com/muumuu8181/claude-dangerous-setup/raw/main/claude-dangerous-setup.sh
chmod +x claude-dangerous-setup.sh

# 3. 実行
./claude-dangerous-setup.sh
```

## 📋 事前準備

### 1. Termuxアプリのインストール

**推奨: F-Droid版** (最新機能対応)
```
https://f-droid.org/packages/com.termux/
```

**代替: Google Play版**
```
https://play.google.com/store/apps/details?id=com.termux
```

### 2. ストレージアクセス設定

```bash
# Termux起動後、最初に実行
termux-setup-storage
```

これにより以下がアクセス可能になります:
- `~/storage/downloads/` - ダウンロードフォルダ
- `~/storage/shared/` - 共有ストレージ

### 3. 基本パッケージ更新

```bash
# パッケージリストを更新
pkg update

# 基本パッケージをアップグレード
pkg upgrade
```

## 🔧 詳細インストール手順

### Phase 1: 環境チェック

スクリプトが自動で以下をチェック:
- ✅ Termux環境であることを確認
- ✅ pkgコマンドの存在確認
- ✅ 必要な権限の確認

### Phase 2: 依存関係インストール

自動インストールされるパッケージ:
```
proot      - サンドボックス環境構築
git        - バージョン管理
curl       - ファイルダウンロード
nodejs     - JavaScript実行環境
python     - Python実行環境
openssh    - SSH機能
rsync      - ファイル同期
```

### Phase 3: ディレクトリ構成作成

```
~/claude-sandbox/
├── isolated-env/      # proot隔離環境
├── backups/          # 自動バックアップ
├── scripts/          # 実行スクリプト
├── configs/          # 設定ファイル
└── logs/            # 操作ログ
```

### Phase 4: proot環境構築

- termux-proot.sh の自動ダウンロード
- 環境変数の設定
- 隔離環境の初期化

### Phase 5: Claude Code設定

- 権限設定ファイル作成
- エイリアスコマンド設定
- 安全設定の適用

## 🚨 トラブルシューティング

### よくあるエラーと解決法

#### エラー1: "Permission denied"
```bash
# 原因: 実行権限がない
# 解決:
chmod +x claude-dangerous-setup.sh
```

#### エラー2: "pkg: command not found"
```bash
# 原因: Termux環境外で実行している
# 解決: Termuxアプリ内で実行
```

#### エラー3: "curl: command not found"
```bash
# 原因: 基本パッケージが不足
# 解決:
pkg install curl
```

#### エラー4: "proot: command not found"
```bash
# 原因: prootパッケージが不足
# 解決:
pkg install proot
```

### ログファイルの確認

```bash
# インストールログの確認
ls -la ~/work-history/claude-dangerous-setup-*.log

# 最新ログの表示
tail -50 ~/work-history/claude-dangerous-setup-$(date +%Y%m%d)-*.log
```

## 📱 デバイス別の注意点

### Samsung Galaxy Tab
- **特記事項**: DeXモード対応
- **推奨設定**: 
  ```bash
  export SAMSUNG_DEX_MODE=1
  ```

### iPad + iSH
- **制限事項**: proot機能制限あり
- **代替方法**: chroot環境使用
  ```bash
  export USE_CHROOT_INSTEAD=1
  ./claude-dangerous-setup.sh
  ```

### Xiaomi Pad
- **MIUI制限**: バックグラウンド制限に注意
- **推奨設定**: 
  - Termuxを「バッテリー最適化」から除外
  - 「自動起動」を許可

### HUAWEI MatePad
- **HarmonyOS**: 基本的にAndroid互換
- **注意**: Google Playサービス不要

## 🔄 アップデート手順

### 自動更新チェック

```bash
# 最新版チェック
cd ~/claude-dangerous-setup
git pull origin main

# 新しいバージョンがある場合、再実行
./claude-dangerous-setup.sh
```

### 手動更新

```bash
# バックアップ作成
cp -r ~/claude-sandbox ~/claude-sandbox.backup

# 最新版取得
rm -rf ~/claude-dangerous-setup
git clone https://github.com/muumuu8181/claude-dangerous-setup.git

# 設定保持して更新
cd claude-dangerous-setup
./claude-dangerous-setup.sh --preserve-config
```

## ✅ インストール完了確認

### 基本動作テスト

```bash
# 1. エイリアス確認
alias | grep claude

# 2. サンドボックス環境テスト
enter-sandbox
exit

# 3. バックアップ機能テスト
cd ~/test-project
cdg-safe --version

# 4. 復元機能テスト
restore-backup
```

### 期待される出力

```
✅ Termux環境確認完了
✅ パッケージインストール完了
✅ ディレクトリ構造作成完了
✅ proot隔離環境の準備完了
✅ Claude Code権限設定完了
✅ 便利スクリプト作成完了
✅ 環境設定完了
✅ インストール検証完了

🎉 セットアップが完了しました！
```

## 🆘 サポート

インストールでお困りの場合:

1. **GitHub Issues**: https://github.com/muumuu8181/claude-dangerous-setup/issues
2. **ラベル**: `installation-help` を付けて投稿
3. **情報**: 以下を含めて報告してください
   - Androidバージョン
   - デバイス名
   - エラーメッセージ全文
   - インストールログ

---

**インストールが完了したら、[README.md](README.md) の使用方法をご確認ください！**