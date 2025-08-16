# 🚀 Ultimate Ghostty + Zsh Terminal Setup Script

A comprehensive, one-command setup script that transforms your macOS terminal into a beautiful, modern development environment with Ghostty, Oh My Zsh, Powerlevel10k, and essential developer tools.

## ✨ What This Script Does

This single script automatically installs and configures everything you need for a professional-grade terminal experience:

### 🎨 **Terminal Emulator**
- **Ghostty**: A modern, GPU-accelerated terminal emulator with excellent performance and customization options
- Automatic theme selection from curated collection (Dracula, Tokyo Night, Catppuccin, etc.)
- Configurable window decorations and background opacity
- Optimized for macOS with native integration

### 🎯 **Shell & Framework**
- **Zsh**: Enhanced shell with advanced features
- **Oh My Zsh**: Popular Zsh configuration framework with plugin management
- **Powerlevel10k**: Fast, feature-rich prompt with beautiful diamond (◆) design
- Custom multiline prompt with status indicators and Git integration

### 🔧 **Essential Developer Tools**
- **lsd**: Modern `ls` replacement with colors, icons, and tree view
- **bat**: Enhanced `cat` with syntax highlighting and Git integration
- **zsh-completions**: Additional completion definitions for Zsh

### 🎨 **Fonts & Typography**
- **JetBrains Mono Nerd Font**: Primary coding font with programming ligatures
- **Fira Code Nerd Font**: Alternative coding font with ligatures
- **Meslo LG Nerd Font**: Powerlevel10k's recommended font
- **Hack Nerd Font**: Clean, readable programming font
- All fonts include Nerd Font icons for terminal symbols and Git status

### 🔌 **Zsh Plugins**
- **zsh-autosuggestions**: Fish-like autosuggestions based on command history
- **zsh-syntax-highlighting**: Syntax highlighting for commands as you type
- **zsh-completions**: Additional completion definitions
- **git**: Built-in Git integration with status indicators

## 🛠️ System Requirements

- **macOS** (Intel or Apple Silicon)
- **Internet connection** for downloading packages and fonts
- **Administrator privileges** for Homebrew installation (if needed)

## 📦 What Gets Installed

### Package Manager
- **Homebrew**: macOS package manager (installed automatically if missing)

### Terminal Applications
- **Ghostty**: Modern terminal emulator
- **lsd**: Colorful directory listing tool
- **bat**: Syntax-highlighted file viewer

### Fonts (via Homebrew Casks)
- `font-jetbrains-mono-nerd-font`
- `font-fira-code-nerd-font`
- `font-meslo-lg-nerd-font`
- `font-hack-nerd-font`

### Shell Framework & Plugins
- **Oh My Zsh**: Zsh configuration framework
- **Powerlevel10k**: Fast, feature-rich prompt theme
- **zsh-autosuggestions**: Command autosuggestions
- **zsh-syntax-highlighting**: Command syntax highlighting
- **zsh-completions**: Additional completions

## 🎨 Available Themes

The script offers a curated selection of beautiful themes:

1. **Dracula** - Dark theme with purple accents
2. **Catppuccin Mocha** - Warm dark theme with pastel colors
3. **Tokyo Night** - Elegant dark blue theme
4. **Gruvbox** - Retro groove color scheme
5. **Rose Pine** - Subtle, elegant dark theme
6. **Nord** - Arctic-inspired color palette
7. **Builtin Solarized Dark** - Classic dark theme
8. **Builtin Tango Dark** - Traditional dark theme

## 🚀 Quick Start

### **New Installation or Repair Mode**
The script automatically detects if you have an existing installation and offers repair/update mode.

### Option 1: Direct Download & Run
```bash
# Download the script
curl -fsSL https://raw.githubusercontent.com/yourusername/yourrepo/main/setup_terminal_resolved.sh -o setup_terminal.sh

# Make it executable
chmod +x setup_terminal.sh

# Run the setup
./setup_terminal.sh
```

### Option 2: Clone Repository
```bash
# Clone the repository
git clone https://github.com/yourusername/yourrepo.git
cd yourrepo

# Run the setup script
./setup_terminal_resolved.sh
```

## 📋 Installation Process

1. **Confirmation**: Script shows what will be installed and asks for confirmation
2. **System Detection**: Automatically detects your Mac's architecture (Intel/Apple Silicon)
3. **Homebrew Setup**: Installs Homebrew if not present
4. **Ghostty Installation**: Installs the Ghostty terminal emulator
5. **Tool Installation**: Installs `lsd`, `bat`, and `zsh-completions`
6. **Font Installation**: Downloads and installs Nerd Fonts
7. **Theme Selection**: Interactive theme picker
8. **Configuration**: Sets up window decorations and opacity
9. **Oh My Zsh Setup**: Installs Oh My Zsh framework
10. **Plugin Installation**: Clones and configures Zsh plugins
11. **Powerlevel10k**: Installs and configures the diamond prompt
12. **Final Configuration**: Updates `.zshrc` and creates configuration files

## 🔧 Configuration Files Created

The script creates/modifies these files:

- `~/.config/ghostty/config` - Ghostty terminal configuration
- `~/.zshrc` - Main Zsh configuration (backed up if existing)
- `~/.zshenv` - Zsh environment variables
- `~/.p10k.zsh` - Powerlevel10k prompt configuration

## 🎯 Features After Setup

### Terminal Experience
- **Beautiful diamond prompt (◆)** with multiline design
- **Colorful directory listings** with `lsd`
- **Syntax-highlighted file viewing** with `bat`
- **Command autosuggestions** as you type
- **Syntax highlighting** for commands
- **Git status integration** in prompt
- **Custom theme** with your chosen color scheme

### Ghostty Features
- **GPU acceleration** for smooth performance (144 FPS)
- **Custom themes** with easy switching
- **Window decorations** (optional)
- **Background opacity** control
- **Nerd Font support** for icons and symbols
- **Native macOS integration**
- **Enhanced cursor** with beam style and blinking
- **Better text rendering** with programming ligatures
- **Improved window padding** and margins
- **Enhanced keyboard shortcuts** (Cmd+T for tabs, Cmd+Shift+N for windows)
- **Better scrolling** with 10,000 line history
- **Smooth vsync** and performance optimizations

### Developer Workflow
- **Enhanced completions** for common commands
- **Git integration** with status indicators
- **Programming ligatures** with coding fonts
- **Color-coded output** for better readability
- **Fast, responsive** terminal experience

## 🔍 Verification Commands

After installation, test these commands:

```bash
# Test colorful directory listing
lsd

# Test syntax-highlighted file viewing
bat README.md

# Test diamond prompt rendering
echo -e '\u25c6'

# Test Git status in prompt
git status

# Customize Powerlevel10k
p10k configure
```

## 🛠️ Customization

### Changing Themes
Edit `~/.config/ghostty/config`:
```toml
theme = "your-theme-name"
```

### Adjusting Opacity
Edit `~/.config/ghostty/config`:
```toml
background-opacity = 0.85
```

### Customizing Prompt
Run the Powerlevel10k configuration:
```bash
p10k configure
```

### Adding More Plugins
Edit `~/.zshrc` and add to the plugins array:
```bash
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions your-plugin)
```

## 🔒 Safety Features

- **Backup Creation**: Existing `.zshrc` is backed up before modification
- **Confirmation Prompt**: Shows what will be installed before proceeding
- **Error Handling**: Graceful handling of missing dependencies
- **Architecture Detection**: Works on both Intel and Apple Silicon Macs
- **Non-Destructive**: Doesn't overwrite existing configurations without backup

## 🐛 Troubleshooting

### Font Issues (Missing Icons/Logos/Question Marks)
If icons don't display correctly or you see question marks instead of symbols:

#### **For Ghostty (Primary Terminal):**
The script automatically configures Ghostty with enhanced UI/UX features. If you see issues:
1. **Restart Ghostty completely**
2. **Check font configuration:** `cat ~/.config/ghostty/config`
3. **Reinstall fonts:** `brew reinstall --cask font-jetbrains-mono-nerd-font font-fira-code-nerd-font font-meslo-lg-nerd-font font-hack-nerd-font`

#### **macOS Terminal Reset:**
Our script automatically resets macOS Terminal to default settings since Ghostty provides a superior experience:
- **No more font configuration issues**
- **Clean, default Terminal state**
- **Focus on the better terminal (Ghostty)**

#### **Quick Fix Commands:**
```bash
# Update everything
brew update && brew upgrade

# Reinstall fonts
brew reinstall --cask font-jetbrains-mono-nerd-font font-fira-code-nerd-font font-meslo-lg-nerd-font font-hack-nerd-font

# Reinstall tools
brew reinstall lsd bat zsh-completions

# Refresh font cache
fc-cache -frv
```

### **Why This Approach is Better:**
- **Ghostty** is faster, more modern, and has better features
- **No more Terminal app font issues** - it's reset to default
- **Enhanced UI/UX** with GPU acceleration, better cursors, and improved rendering
- **Consistent experience** across all your terminal sessions

### Theme Not Applied
1. Restart Ghostty completely
2. Check theme name in `~/.config/ghostty/config`
3. Verify theme is available in Ghostty

### Command Not Found
If `lsd` or `bat` aren't found:
1. Restart your terminal
2. Check Homebrew installation: `brew --version`
3. Reinstall tools: `brew install lsd bat`

### Quick Fix Command (All-in-One)
If you're experiencing multiple issues, run this command to fix everything:
```bash
brew update && brew upgrade && brew reinstall --cask font-jetbrains-mono-nerd-font font-fira-code-nerd-font font-meslo-lg-nerd-font font-hack-nerd-font && brew reinstall lsd bat zsh-completions
```

## 📝 License

This script is provided as-is for educational and personal use. Please review the script before running it on your system.

## 🤝 Contributing

Feel free to submit issues, feature requests, or pull requests to improve this setup script.

## 🙏 Acknowledgments

- [Ghostty](https://github.com/mitchellh/ghostty) - Modern terminal emulator
- [Oh My Zsh](https://ohmyz.sh/) - Zsh configuration framework
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Fast prompt theme
- [Nerd Fonts](https://www.nerdfonts.com/) - Iconic fonts for developers
- [Homebrew](https://brew.sh/) - macOS package manager

---

**Enjoy your beautiful, modern terminal setup! 🎉** 