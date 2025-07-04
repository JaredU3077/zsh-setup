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

echo "Installing tools: lsd, bat, zsh-completions, font-hack-nerd-font, font-jetbrains-mono-nerd-font, font-firacode-nerd-font, font-meslo-lg-nerd-font..."
brew install lsd bat zsh-completions
brew tap homebrew/cask-fonts || true
brew install --cask font-hack-nerd-font font-jetbrains-mono-nerd-font font-fira-code-nerd-font font-meslo-lg-nerd-font || true

# Detect best available Nerd Font Mono
NERD_FONT=""
for font in "JetBrainsMono Nerd Font Mono" "FiraCode Nerd Font Mono" "MesloLGS Nerd Font Mono" "Hack Nerd Font Mono"; do
    if [[ $(ls "$HOME/Library/Fonts/" 2>/dev/null | grep -i "$(echo $font | tr -d ' ')") ]]; then
        NERD_FONT="$font"
        break
    fi
done
if [ -z "$NERD_FONT" ]; then
    NERD_FONT="Hack Nerd Font Mono"
    echo -e "${YELLOW}Warning: No Nerd Font Mono found in ~/Library/Fonts. Ghostty may not display icons correctly. Please install a Nerd Font Mono manually.${NC}"
else
    echo -e "${GREEN}Using Nerd Font: $NERD_FONT${NC}"
fi

# Curated theme list
THEMES=("dracula" "catppuccin-mocha" "tokyonight" "gruvbox" "rose-pine" "nord" "Builtin Solarized Dark" "Builtin Tango Dark")
echo "Available themes:"
for i in {1..${#THEMES[@]}}; do
    echo "$i) ${THEMES[$i-1]}"
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
echo "Configuring Ghostty with theme '$SELECTED_THEME', font '$NERD_FONT', opacity $OPACITY, decorations $WINDEC..."
cat > "$HOME/.config/ghostty/config" << EOF
theme = "$SELECTED_THEME"
font-family = "$NERD_FONT"
font-size = $FONT_SIZE
window-decoration = $WINDEC
background-opacity = $OPACITY
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
# Powerlevel10k configuration
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs prompt_char)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_CONTENT_EXPANSION='◆'
typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='%F{cyan}╭─%f'
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='%F{cyan}╰─%f '
# Validate diamond rendering
if ! echo -e "\u25c6" | grep -q "◆"; then
    echo "Warning: Diamond (◆) not rendering. Check font setup."
fi
EOF

echo "Applying changes by reloading Zsh..."
source "$HOME/.zshrc"

echo "Restarting Ghostty and applying theme..."
pkill -x Ghostty || true
sleep 1
open -a Ghostty --args +set-theme "$SELECTED_THEME"

echo "Validating setup..."
if ! grep -q "theme = \"$SELECTED_THEME\"" "$HOME/.config/ghostty/config"; then
    echo -e "${RED}Warning: Ghostty theme not set correctly in config file.${NC}"
fi
if ! echo -e "\u25c6" | grep -q "◆"; then
    echo -e "${RED}Warning: Unicode diamond (◆) not rendering. Verify Nerd Font Mono is set in Ghostty.${NC}"
fi
if ! lsd --color=always &>/dev/null; then
    echo -e "${RED}Warning: lsd not installed or not working with colors.${NC}"
fi

echo -e "${GREEN}Setup complete!${NC}"
echo "Your terminal should now have the '$SELECTED_THEME' theme with a diamond (◆) prompt."
echo "To customize Powerlevel10k further, run: p10k configure"
echo "Verify with: lsd (colorful listing), echo -e '\u25c6' (diamond), git status (colorful prompt)."
echo "If colors or the diamond are missing, restart your terminal or check warnings above."
echo "---"
echo "Ghostty UX Tips:"
echo "- Use Cmd+T for new tabs, Cmd+D for splits (if supported)"
echo "- Right-click for context menu and settings"
echo "- Try different themes/fonts by editing ~/.config/ghostty/config"
echo "- Use p10k configure to further tweak your prompt"
echo "- Check Ghostty docs for more advanced features!" 