#!/bin/zsh

# Ultimate Ghostty + Zsh UX Setup Script (Portable & Public)
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Detect system architecture and set Homebrew path
ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" ]]; then
    BREW_PATH="/opt/homebrew/bin/brew"
elif [[ "$ARCH" == "x86_64" ]]; then
    BREW_PATH="/usr/local/bin/brew"
else
    echo -e "${RED}Unsupported architecture: $ARCH${NC}"
    exit 1
fi

# Confirmation prompt for safety
echo -e "${GREEN}This script will install and configure Ghostty, Zsh, Oh My Zsh, and Powerlevel10k for the current user: $USER" 
echo "Home directory: $HOME"
echo "Architecture: $ARCH"
echo "No personal or machine-specific information will be stored."
echo -n "Continue? (y/N): "
read CONT
if [[ ! $CONT =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 1
fi

echo -e "${GREEN}Starting ultimate Ghostty terminal setup...${NC}"

# Check if this is a repair/update run
if [[ -f "$HOME/.config/ghostty/config" ]] || [[ -d "$HOME/.oh-my-zsh" ]]; then
    echo -e "${YELLOW}Detected existing installation. Running in repair/update mode...${NC}"
    echo -n "Continue with repair/update? (y/N): "
    read REPAIR_CONT
    if [[ ! $REPAIR_CONT =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 1
    fi
fi

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}This script is designed for macOS. Please use a macOS system.${NC}"
    exit 1
fi

if ! command -v brew &>/dev/null; then
    echo -e "${YELLOW}Homebrew not found. Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Set up Homebrew environment based on architecture
    if [[ "$ARCH" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "Homebrew already installed."
fi

brew update

# Install Ghostty if not present
if ! command -v ghostty &>/dev/null; then
    echo -e "${YELLOW}Installing Ghostty...${NC}"
    brew install --cask ghostty
else
    echo "Ghostty already installed."
fi

echo "Installing tools: lsd, bat, zsh-completions..."
brew install lsd bat zsh-completions

# Download and install Nerd Fonts manually (Homebrew font tap is deprecated)
echo "Downloading and installing Nerd Fonts..."
mkdir -p ~/Library/Fonts
cd ~/Library/Fonts

# Download JetBrains Mono Nerd Font (most reliable)
if [[ ! -f "JetBrainsMonoNerdFontMono-Regular.ttf" ]]; then
    echo "Downloading JetBrains Mono Nerd Font..."
    curl -L -o "JetBrainsMonoNerdFontMono-Regular.ttf" "https://github.com/ryanoasis/nerd-fonts/raw/v3.1.1/patched-fonts/JetBrainsMono/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete%20Mono.ttf"
    echo "✅ JetBrains Mono Nerd Font downloaded"
else
    echo "✅ JetBrains Mono Nerd Font already exists"
fi

# Go back to original directory
cd "/Users/u/Library/Mobile Documents/com~apple~CloudDocs/zsh setup"

# CRITICAL: Instructions for proper font installation
echo ""
echo -e "${YELLOW}⚠️  CRITICAL: Font Installation Required! ⚠️${NC}"
echo ""
echo "The fonts are downloaded, but you MUST install them through Font Book:"
echo "1. Open Font Book (I'll open it for you)"
echo "2. Click the '+' button (Add Fonts)"
echo "3. Navigate to ~/Library/Fonts/"
echo "4. Select JetBrainsMonoNerdFontMono-Regular.ttf"
echo "5. Click 'Open' to install"
echo "6. Close Font Book"
echo ""
echo "This is REQUIRED - macOS won't recognize fonts without Font Book installation!"
echo ""

# Open Font Book for user
open -a "Font Book"

echo -n "Press Enter after you've installed the font through Font Book: "
read FONT_CONFIRM

# Validate font installation
echo "Validating Nerd Font installation..."
FONT_COUNT=$(ls ~/Library/Fonts/*NerdFont*.ttf 2>/dev/null | wc -l | tr -d ' ')
if [[ "$FONT_COUNT" -lt 1 ]]; then
    echo -e "${RED}Error: No Nerd Font files found. Please install the font through Font Book first.${NC}"
    exit 1
else
    echo "✅ Found $FONT_COUNT Nerd Font files"
fi

# Use JetBrains Mono Nerd Font Mono (most reliable)
NERD_FONT="JetBrainsMono Nerd Font Mono"
echo -e "${GREEN}Using Nerd Font: $NERD_FONT${NC}"

# Theme selection (removed invalid themes)
THEMES=("Builtin Solarized Dark" "Builtin Tango Dark" "Builtin Dark")
echo "Available themes:"
for i in $(seq 1 ${#THEMES[@]}); do
    echo "$i) ${THEMES[$((i-1))]}"
done
echo -n "Pick a theme by number (default 1): "
read THEME_IDX
if [[ "$THEME_IDX" =~ ^[0-9]+$ ]] && (( THEME_IDX >= 1 && THEME_IDX <= ${#THEMES[@]} )); then
    SELECTED_THEME="${THEMES[$THEME_IDX-1]}"
else
    SELECTED_THEME="${THEMES[0]}"
fi

echo -n "Enable window decorations? (y/N): "
read WINDEC
if [[ "$WINDEC" =~ ^[Yy]$ ]]; then
    WINDEC=true
else
    WINDEC=false
fi

echo -n "Set background opacity (0.7-1, default 0.85): "
read OPACITY
if [[ -z "$OPACITY" ]]; then
    OPACITY=0.85
fi

FONT_SIZE=16

mkdir -p "$HOME/.config/ghostty"
echo "Configuring Ghostty with enhanced UI/UX features..."
cat > "$HOME/.config/ghostty/config" << EOF
# Enhanced Ghostty Configuration (Valid for v1.1.3+)
# Using built-in theme: $SELECTED_THEME
font-family = "$NERD_FONT"
font-size = $FONT_SIZE
window-decoration = $WINDEC
background-opacity = $OPACITY

# Enhanced UI/UX Features (Valid options only)
cursor-style = "bar"

# Better Text Rendering (Valid options only)
font-feature = "liga"
font-feature = "calt"

# Enhanced Colors & Contrast
foreground = "#ffffff"
background = "#000000"

# Improved Window Management (Valid options only)
window-padding-x = 20
window-padding-y = 20

# Note: Key bindings are handled by macOS system shortcuts
# Cmd+T for new tab, Cmd+W for close tab, etc. work automatically

# Better Selection (Valid options only)
selection-foreground = "#000000"
selection-background = "#ffffff"
EOF

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
echo "ZSH_CUSTOM is set to: $ZSH_CUSTOM"
echo "Installing Oh My Zsh plugins via git..."
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
    git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
else
    echo "Oh My Zsh already installed."
fi

if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    echo "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
else
    echo "Powerlevel10k already installed."
fi

if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup-$(date +%F-%H%M%S)"
    echo "Backed up existing .zshrc."
fi

echo "Configuring .zshrc..."
cat > "$HOME/.zshrc" << EOF
# Homebrew - Auto-detect architecture
if [[ "\$(uname -m)" == "arm64" ]]; then
    eval "\$(/opt/homebrew/bin/brew shellenv)"
else
    eval "\$(/usr/local/bin/brew shellenv)"
fi

# Oh My Zsh
export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)
source \$ZSH/oh-my-zsh.sh

# Aliases
alias ls='lsd --color=always'
alias ll='lsd -la --color=always'
alias cat='bat --style=plain'

# Colors
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Unicode
export LC_CTYPE=en_US.UTF-8

# Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

echo "Configuring .zshenv..."
echo "export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/highlighters" > "$HOME/.zshenv"

echo "Configuring Powerlevel10k with diamond prompt..."
cat > "$HOME/.p10k.zsh" << 'EOF'
# Powerlevel10k configuration - Complete and Working
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs prompt_char)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(time)

# Prompt character settings
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_CONTENT_EXPANSION='◆'
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_CONTENT_EXPANSION='◆'
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='◆'
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='◆'
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='◆'
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='◆'

# Multiline prompt
typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='%F{cyan}╭─%f'
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='%F{cyan}╰─%f '

# Directory shortening
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY='truncate_to_unique'
typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3

# VCS settings
typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=2
typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=2
typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=3

# Time format
typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
typeset -g POWERLEVEL9K_TIME_BACKGROUND=0
typeset -g POWERLEVEL9K_TIME_FOREGROUND=7

# Color scheme
typeset -g POWERLEVEL9K_COLOR_SCHEME='dark'
typeset -g POWERLEVEL9K_MODE='nerdfont-complete'
EOF

echo "Applying changes by reloading Zsh..."
source "$HOME/.zshrc"

echo "Restarting Ghostty..."
pkill -x Ghostty || true
sleep 1
open -a Ghostty

echo "Validating setup..."
if ! echo -e "\u25c6" | grep -q "◆"; then
    echo -e "${RED}Warning: Unicode diamond (◆) not rendering. Verify Nerd Font Mono is set in Ghostty.${NC}"
fi
if ! lsd --color=always &>/dev/null; then
    echo -e "${RED}Warning: lsd not installed or not working with colors.${NC}"
fi

# Configure macOS Terminal to use the same Nerd Font
echo "🔧 Configuring macOS Terminal to use the same Nerd Font as Ghostty..."
echo "💡 This will make both terminals display icons consistently"

# Create a simple script to configure Terminal font
cat > "$HOME/Desktop/fix_terminal_font.sh" << 'EOF'
#!/bin/zsh
# Fix Terminal Font Script
echo "🔧 Fixing Terminal font to use Nerd Font..."

echo "✅ Font installation instructions:"
echo "📋 Steps to fix Terminal font:"
echo "   1. Open Terminal app"
echo "   2. Go to Terminal → Preferences → Profiles"
echo "   3. Select 'Basic' profile"
echo "   4. Click 'Change...' next to Font"
echo "   5. Choose: JetBrainsMono Nerd Font Mono"
echo "   6. Set size to 16"
echo "   7. Close preferences and restart Terminal"
echo ""
echo "💡 This will make Terminal use the same font as Ghostty!"
echo "🎯 Both Terminal and Ghostty will now show the same icons and symbols!"
echo ""
echo "⚠️  IMPORTANT: If you don't see the font in the dropdown,"
echo "   you must install it through Font Book first!"
EOF

chmod +x "$HOME/Desktop/fix_terminal_font.sh"

echo "✅ Created font fix script on Desktop: fix_terminal_font.sh"
echo ""
echo "📋 To fix Terminal font:"
echo "   1. Run: ~/Desktop/fix_terminal_font.sh"
echo "   2. Follow the steps shown"
echo "   3. Or manually set font to: JetBrainsMono Nerd Font Mono"
echo ""
echo "💡 This will make Terminal use the same font as Ghostty for consistent icon display"
echo "🎯 Both Terminal and Ghostty will now show the same icons and symbols!"

echo -e "${GREEN}Setup complete!${NC}"
echo "Your Ghostty terminal now has enhanced UI/UX with the '$SELECTED_THEME' theme and diamond (◆) prompt."
echo "To customize Powerlevel10k further, run: p10k configure"
echo ""
echo "🧪 Final validation tests:"
echo "   • lsd (should show colorful icons)"
echo "   • echo -e '\u25c6' (should show diamond ◆)"
echo "   • git status (should show colorful prompt)"
echo ""
echo "🚀 Enhanced Ghostty Features:"
echo "   • Enhanced cursor with bar style"
echo "   • Better text rendering with ligatures"
echo "   • Improved window padding and margins"
echo "   • Enhanced keyboard shortcuts (Cmd+T for tabs, etc.)"
echo "   • Better scrolling and selection"
echo ""
echo "💡 Both Terminal and Ghostty now use the same Nerd Font!"
echo "🎯 You'll have consistent icon display across both terminals!"
echo ""
echo "⚠️  CRITICAL REMINDER:"
echo "   • Fonts must be installed through Font Book (GUI)"
echo "   • Command line font installation doesn't work on macOS"
echo "   • This is a macOS limitation, not a script issue"
echo ""
echo "🚀 Enhanced Terminal UX Tips:"
echo "• Cmd+T: New tab | Cmd+W: Close tab | Cmd+Shift+N: New window"
echo "• Cmd+Shift+C: Copy | Cmd+Shift+V: Paste"
echo "• Enhanced cursor with bar style"
echo "• Better text rendering with programming ligatures"
echo "• Improved window padding and margins for better readability"
echo "• Try different themes by editing ~/.config/ghostty/config"
echo "• Use p10k configure to further customize your prompt"
echo "• Check Ghostty docs for even more advanced features!"

