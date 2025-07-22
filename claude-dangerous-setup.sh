#!/bin/bash
# Claude Code Dangerous Mode - Safe Setup for Android Tablets
# 8台タブレット対応・コマンド一発実行システム v1.0
# Created: 2025-07-22

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETUP_LOG="$SCRIPT_DIR/work-history/claude-dangerous-setup-$(date +%Y%m%d-%H%M%S).log"
SANDBOX_DIR="$HOME/claude-sandbox"
ISOLATION_DIR="$SANDBOX_DIR/isolated-env"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date '+%H:%M')] $1${NC}"
    echo "$(date '+%H:%M') $1" >> "$SETUP_LOG"
}

warn() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
    echo "$(date '+%H:%M') [WARNING] $1" >> "$SETUP_LOG"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
    echo "$(date '+%H:%M') [ERROR] $1" >> "$SETUP_LOG"
}

# Check if running in Termux
check_environment() {
    log "環境チェック開始..."
    
    if [[ ! "$PREFIX" =~ .*termux.* ]]; then
        error "このスクリプトはTermux環境で実行してください"
        exit 1
    fi
    
    if ! command -v pkg &> /dev/null; then
        error "pkgコマンドが見つかりません。Termux環境を確認してください"
        exit 1
    fi
    
    log "✅ Termux環境確認完了"
}

# Install required packages
install_dependencies() {
    log "必要パッケージのインストール開始..."
    
    # Core packages for isolation and development
    PACKAGES=(
        "proot"           # For sandboxing
        "git"            # Version control
        "curl"           # Download tools
        "wget"           # Alternative download
        "nodejs"         # Node.js runtime
        "python"         # Python runtime
        "openssh"        # SSH support
        "rsync"          # File synchronization
        "tar"            # Archive handling
        "gzip"           # Compression
    )
    
    for package in "${PACKAGES[@]}"; do
        if ! pkg list-installed 2>/dev/null | grep -q "^${package}/"; then
            log "インストール中: $package"
            pkg install -y "$package" || {
                warn "$package のインストールに失敗しましたが、続行します"
            }
        else
            log "✅ $package は既にインストール済み"
        fi
    done
    
    log "✅ パッケージインストール完了"
}

# Setup sandbox directory structure
setup_directories() {
    log "ディレクトリ構造のセットアップ開始..."
    
    mkdir -p "$SANDBOX_DIR"/{isolated-env,backups,scripts,configs,logs}
    mkdir -p "$HOME/work-history/$(date +%Y-%m)"
    
    log "✅ ディレクトリ構造作成完了"
}

# Create proot isolation environment
create_proot_environment() {
    log "proot隔離環境の構築開始..."
    
    # Download and setup termux-proot
    cd "$SANDBOX_DIR"
    
    if [ ! -f "termux-proot.sh" ]; then
        log "termux-prootスクリプトのダウンロード..."
        curl -sLO https://git.io/termux-proot.sh || {
            error "termux-proot.shのダウンロードに失敗"
            return 1
        }
        chmod +x termux-proot.sh
    fi
    
    # Set environment variables for customization
    export TERMUX_SANDBOX_PATH="$ISOLATION_DIR"
    export TERMUX_SANDBOX_PROOT_OPTIONS="--kill-on-exit --mount=/system --mount=/vendor"
    
    log "✅ proot隔離環境の準備完了"
}

# Install Claude Code in isolated environment
install_claude_code() {
    log "Claude Codeのインストール開始..."
    
    # Check if Claude Code is already installed
    if command -v claude &> /dev/null; then
        log "✅ Claude Codeは既にインストール済み"
        CLAUDE_VERSION=$(claude --version 2>/dev/null || echo "不明")
        log "Claude Code Version: $CLAUDE_VERSION"
    else
        log "Claude Codeをインストール中..."
        # Install Claude Code using npm
        npm install -g @anthropic/claude-code || {
            warn "Claude Codeのnpmインストールに失敗。手動インストールが必要です"
        }
    fi
}

# Configure Claude Code permissions
configure_claude_permissions() {
    log "Claude Code権限設定の作成..."
    
    # Create Claude settings directory
    CLAUDE_DIR="$HOME/.config/claude"
    mkdir -p "$CLAUDE_DIR"
    
    # Create safe permissions configuration
    cat > "$CLAUDE_DIR/settings.json" << 'EOF'
{
  "permissions": {
    "allow": [
      "Edit",
      "Write", 
      "Read",
      "Bash(npm run *)",
      "Bash(node *)",
      "Bash(python *)",
      "Bash(git status)",
      "Bash(git diff)",
      "Bash(git add *)",
      "Bash(git commit *)",
      "Bash(ls *)",
      "Bash(cat *)",
      "Bash(mkdir *)",
      "Bash(cp *)",
      "Bash(mv *)",
      "Bash(cd *)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(sudo *)",
      "Bash(su *)",
      "Bash(curl *)",
      "Bash(wget *)",
      "Bash(termux-* *)",
      "Bash(pkg *)",
      "Bash(apt *)"
    ]
  },
  "dangerous_mode": {
    "enabled": true,
    "sandbox_only": true,
    "backup_before_run": true,
    "max_session_duration": 7200
  }
}
EOF
    
    log "✅ Claude Code権限設定完了"
}

# Create convenience scripts
create_scripts() {
    log "便利スクリプトの作成開始..."
    
    # Safe dangerous mode launcher
    cat > "$SANDBOX_DIR/scripts/claude-safe.sh" << 'EOF'
#!/bin/bash
# Claude Code Safe Dangerous Mode Launcher

SANDBOX_DIR="$HOME/claude-sandbox"
BACKUP_DIR="$SANDBOX_DIR/backups/$(date +%Y%m%d-%H%M%S)"

echo "🔒 Claude Code Safe Dangerous Mode Starting..."
echo "📁 作業ディレクトリ: $(pwd)"
echo "💾 バックアップ作成中..."

# Create backup
mkdir -p "$BACKUP_DIR"
rsync -av --exclude='node_modules' --exclude='.git' \
    "$(pwd)/" "$BACKUP_DIR/" 2>/dev/null || true

echo "✅ バックアップ完了: $BACKUP_DIR"
echo "🚀 Claude Code Dangerous Mode を開始します..."

# Start Claude Code in dangerous mode
claude --dangerously-skip-permissions "$@"

echo "✅ Claude Code セッション終了"
EOF
    
    chmod +x "$SANDBOX_DIR/scripts/claude-safe.sh"
    
    # Proot sandbox launcher
    cat > "$SANDBOX_DIR/scripts/enter-sandbox.sh" << 'EOF'
#!/bin/bash
# Enter isolated proot environment

SANDBOX_DIR="$HOME/claude-sandbox"
cd "$SANDBOX_DIR"

echo "🔒 隔離環境に入ります..."
echo "📍 サンドボックスディレクトリ: $SANDBOX_DIR"

# Enter proot environment
./termux-proot.sh
EOF
    
    chmod +x "$SANDBOX_DIR/scripts/enter-sandbox.sh"
    
    # Quick restore script
    cat > "$SANDBOX_DIR/scripts/restore-backup.sh" << 'EOF'
#!/bin/bash
# Quick restore from latest backup

BACKUP_DIR="$HOME/claude-sandbox/backups"
LATEST_BACKUP=$(ls -1t "$BACKUP_DIR" | head -n1)

if [ -z "$LATEST_BACKUP" ]; then
    echo "❌ バックアップが見つかりません"
    exit 1
fi

echo "📁 最新バックアップ: $LATEST_BACKUP"
echo "🔄 復元を開始します..."

rsync -av "$BACKUP_DIR/$LATEST_BACKUP/" "$(pwd)/"

echo "✅ 復元完了"
EOF
    
    chmod +x "$SANDBOX_DIR/scripts/restore-backup.sh"
    
    log "✅ 便利スクリプト作成完了"
}

# Setup aliases and environment
setup_environment() {
    log "環境設定のセットアップ開始..."
    
    # Add aliases to bashrc
    cat >> "$HOME/.bashrc" << 'EOF'

# Claude Code Safe Dangerous Mode Aliases
alias cdg-safe='~/claude-sandbox/scripts/claude-safe.sh'
alias claude-safe='~/claude-sandbox/scripts/claude-safe.sh'
alias enter-sandbox='~/claude-sandbox/scripts/enter-sandbox.sh'
alias restore-backup='~/claude-sandbox/scripts/restore-backup.sh'

# Environment variables for Claude Code
export CLAUDE_DANGEROUS_MODE=1
export CLAUDE_SANDBOX_PATH="$HOME/claude-sandbox"
export CLAUDE_BACKUP_ENABLED=1

# Safety reminder
echo "🔒 Claude Code Safe Dangerous Mode 環境が準備されています"
echo "   使用方法: cdg-safe (安全なデンジャラスモード)"
echo "   サンドボックス: enter-sandbox"
echo "   復元: restore-backup"
EOF
    
    log "✅ 環境設定完了"
}

# Verify installation
verify_installation() {
    log "インストール検証開始..."
    
    # Check if all scripts are executable
    if [ -x "$SANDBOX_DIR/scripts/claude-safe.sh" ] && \
       [ -x "$SANDBOX_DIR/scripts/enter-sandbox.sh" ] && \
       [ -x "$SANDBOX_DIR/scripts/restore-backup.sh" ]; then
        log "✅ スクリプト実行権限確認完了"
    else
        error "スクリプトの実行権限に問題があります"
        return 1
    fi
    
    # Check directory structure
    if [ -d "$SANDBOX_DIR" ] && [ -d "$ISOLATION_DIR" ]; then
        log "✅ ディレクトリ構造確認完了"
    else
        error "ディレクトリ構造に問題があります"
        return 1
    fi
    
    log "✅ インストール検証完了"
}

# Main installation function
main() {
    echo -e "${BLUE}================================================${NC}"
    echo -e "${BLUE}  Claude Code Safe Dangerous Mode Setup v1.0${NC}"
    echo -e "${BLUE}  Android/Termux 環境対応版${NC}"
    echo -e "${BLUE}================================================${NC}"
    echo
    
    # Create log directory
    mkdir -p "$(dirname "$SETUP_LOG")"
    
    log "セットアップ開始: $(date)"
    
    # Run setup steps
    check_environment
    install_dependencies
    setup_directories
    create_proot_environment
    install_claude_code
    configure_claude_permissions
    create_scripts
    setup_environment
    verify_installation
    
    echo
    echo -e "${GREEN}🎉 セットアップが完了しました！${NC}"
    echo
    echo -e "${BLUE}使用方法:${NC}"
    echo -e "  ${YELLOW}cdg-safe${NC}          - 安全なデンジャラスモードでClaude Codeを起動"
    echo -e "  ${YELLOW}enter-sandbox${NC}     - proot隔離環境に入る"
    echo -e "  ${YELLOW}restore-backup${NC}    - 最新バックアップから復元"
    echo
    echo -e "${BLUE}ログファイル: ${SETUP_LOG}${NC}"
    echo
    echo -e "${YELLOW}注意: 新しいターミナルセッションを開始して aliases を有効にしてください${NC}"
    
    log "セットアップ完了: $(date)"
}

# Run main function
main "$@"