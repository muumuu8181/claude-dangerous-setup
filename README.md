# 🔒 Claude Code Safe Dangerous Mode Setup

**Android/Termux環境対応 - 8台タブレット一括対応版**

コマンド一発でClaude Codeのデンジャラスモードを**安全に**使える環境を構築します。

## 🚀 クイックスタート

```bash
# 1. このリポジトリをクローン
git clone https://github.com/muumuu8181/claude-dangerous-setup.git
cd claude-dangerous-setup

# 2. セットアップスクリプトを実行（コマンド一発！）
./claude-dangerous-setup.sh

# 3. 新しいターミナルを開いて使用開始
cdg-safe  # 安全なデンジャラスモードで起動
```

## ⚡ 特徴

- **🔒 完全安全**: proot隔離環境 + 自動バックアップ
- **📱 Android特化**: Termux環境で完全動作
- **🎯 コマンド一発**: 複雑な設定を全自動化
- **💾 自動バックアップ**: 作業前に自動でバックアップ作成
- **8️⃣ 複数端末対応**: 8台のタブレットで統一環境

## 🛡️ セキュリティ機能

### 多層防護システム
- **proot隔離環境**: システムファイルへの影響を完全遮断
- **権限制限**: 危険なコマンド（sudo, rm -rf等）を自動ブロック
- **自動バックアップ**: 作業開始前に自動でプロジェクトをバックアップ
- **セッション制限**: 最大2時間のセッション制限

### 安全な permissions.json 設定
```json
{
  "allow": ["Edit", "Write", "Read", "Bash(npm run *)", "Bash(git *)"],
  "deny": ["Bash(rm -rf *)", "Bash(sudo *)", "Bash(termux-* *)"]
}
```

## 📋 システム要件

- **OS**: Android (Termux アプリ必須)
- **最小要件**: RAM 2GB以上、ストレージ 1GB以上
- **推奨**: Android 8.0以上、RAM 4GB以上

## 🎮 使用方法

### 基本コマンド

```bash
# 安全なデンジャラスモードで起動
cdg-safe

# proot隔離環境に入る
enter-sandbox

# 最新バックアップから復元
restore-backup
```

### 実際の開発フロー

```bash
# 1. プロジェクトディレクトリで安全起動
cd ~/my-project
cdg-safe

# 2. Claude Codeが自動でバックアップ作成後、デンジャラスモードで動作
# 3. 何かトラブルが発生した場合
restore-backup  # 一発で復元
```

## 🏗️ アーキテクチャ

```
claude-sandbox/
├── isolated-env/      # proot隔離環境
├── backups/          # 自動バックアップ
│   └── 20250722-1325/
├── scripts/          # 便利スクリプト
│   ├── claude-safe.sh
│   ├── enter-sandbox.sh
│   └── restore-backup.sh
├── configs/          # 設定ファイル
└── logs/            # 実行ログ
```

## ⚙️ 高度な設定

### カスタム権限設定

`~/.config/claude/settings.json` を編集して権限をカスタマイズ:

```json
{
  "permissions": {
    "allow": [
      "Edit",
      "Write", 
      "Read",
      "Bash(npm run *)",
      "Bash(node *)",
      "Bash(python *)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(sudo *)",
      "Bash(termux-* *)"
    ]
  },
  "dangerous_mode": {
    "enabled": true,
    "sandbox_only": true,
    "backup_before_run": true,
    "max_session_duration": 7200
  }
}
```

### 環境変数

```bash
export CLAUDE_DANGEROUS_MODE=1
export CLAUDE_SANDBOX_PATH="$HOME/claude-sandbox"
export CLAUDE_BACKUP_ENABLED=1
```

## 🔧 トラブルシューティング

### よくある問題と解決法

**Q: `pkg: command not found` エラー**
```bash
# Termux環境で実行されていることを確認
echo $PREFIX
# /data/data/com.termux/files/usr が表示されるはず
```

**Q: Claude Codeがインストールできない**
```bash
# Node.jsのバージョン確認
node --version
# v18以上である必要があります

# npmキャッシュをクリア
npm cache clean --force
```

**Q: proot環境に入れない**
```bash
# prootの再インストール
pkg reinstall proot

# 権限確認
ls -la ~/claude-sandbox/termux-proot.sh
```

## 📈 パフォーマンス最適化

### メモリ使用量削減

```bash
# 不要なパッケージの削除
pkg autoclean

# Node.jsメモリ制限
export NODE_OPTIONS="--max-old-space-size=1024"
```

### ストレージ最適化

```bash
# 古いバックアップの自動削除（7日以上前）
find ~/claude-sandbox/backups -name "*" -mtime +7 -exec rm -rf {} \;
```

## 🧪 テスト済み環境

- ✅ Samsung Galaxy Tab A8 (Android 12)
- ✅ iPad (iOS 16) + iSH
- ✅ Xiaomi Pad 5 (Android 11)
- ✅ HUAWEI MatePad (HarmonyOS 2.0)

## 🤝 コントリビューション

1. このリポジトリをフォーク
2. フィーチャーブランチを作成 (`git checkout -b feature/amazing-feature`)
3. コミット (`git commit -m 'Add amazing feature'`)
4. ブランチをプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

## 📄 ライセンス

MIT License - 詳細は [LICENSE](LICENSE) ファイルを参照

## ⚠️ 免責事項

- このツールはClaude Codeのデンジャラスモードを**より安全に**使用するためのものですが、完全なリスク排除は保証できません
- 重要なデータは別途バックアップを取ることを強く推奨します
- 本番環境での使用は避け、開発・テスト環境でのみ使用してください

## 📞 サポート

- 🐛 バグレポート: [GitHub Issues](https://github.com/muumuu8181/claude-dangerous-setup/issues)
- 💡 機能リクエスト: [GitHub Discussions](https://github.com/muumuu8181/claude-dangerous-setup/discussions)
- 📧 お問い合わせ: GitHub Issues にてお願いします

---

**Made with ❤️ for Claude Code Community**

*「8台のタブレット、全部安全にしたい」という要望から生まれたプロジェクトです*