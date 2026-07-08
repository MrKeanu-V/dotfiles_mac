# 🖥️ macOS Dotfiles & Configurations

> **Personal configuration files for my macOS setup.**
> This repository serves as a backup and synchronization source for my development environment, focusing on terminal-based workflows and system customization.

## ✨ Overview

This repository contains the configuration files (dotfiles) for my daily driver applications on macOS. The goal is to maintain a consistent, efficient, and aesthetically pleasing environment across different machines.

## 📂 Directory Structure

```text
.
├── clash/          # Clash proxy client configurations
├── ghostty/        # Ghostty terminal emulator settings
├── nvim/           # Neovim editor configuration (Lua based)
├── raycast/        # Raycast launcher extensions & settings
├── sketchybar/     # Sketchybar status bar configuration
├── yazi/           # Yazi file manager config & plugins
├── .DS_Store       # macOS system file (ignored)
├── LICENSE         # Project license
├── README.md       # Project documentation
└── starship.toml   # Starship cross-shell prompt configuration
```

## 🛠️ Application Details

### ⚡ Yazi (Terminal File Manager)
A blazing fast terminal file manager written in Rust. My configuration focuses on efficiency and visual feedback.

- **Core Configs**: `yazi.toml`, `keymap.toml`, `theme.toml`
- **Installed Plugins**:
    - 🗑️ [recycle-bin](https://github.com/uhs-robert/recycle-bin.yazi): Safe deletion with trash support.
    - 🏷️ [mactag](https://github.com/yazi-rs/plugins/tree/main/mactag): Integration with macOS Finder tags.
    - 🌲 [full-border](https://github.com/yazi-rs/plugins/tree/main/full-border): Adds borders to panes for better visual separation.
    - 📊 [yaziline](https://github.com/yazi-rs/plugins/tree/main/yaziline): Customizable status line components.
    - 🔀 [toggle-pane](https://github.com/yazi-rs/plugins/tree/main/toggle-pane): Quick pane visibility toggling.
    - 📋 [smart-paste](https://github.com/yazi-rs/plugins/tree/main/smart-paste): Intelligent paste handling.
    - 📦 [mount](https://github.com/yazi-rs/plugins/tree/main/mount): Mount/Unmount drives easily.
    - 🐙 [git](https://github.com/yazi-rs/plugins/tree/main/git): Git status integration.
    - 📝 [chmod](https://github.com/yazi-rs/plugins/tree/main/chmod): Quick permission changes.
    - 📄 [diff](https://github.com/yazi-rs/plugins/tree/main/diff): File diffing support.
    - 🎵 [piper](https://github.com/yazi-rs/plugins/tree/main/piper): Media preview enhancements.

### 🚀 Neovim
My primary code editor, configured with Lua for maximum performance.
*(You can add details here like: "Using Lazy.nvim as plugin manager", "LSP setup with Mason", etc.)*

### 💻 Ghostty
A modern, GPU-accelerated terminal emulator.
*(You can add details here like: "Configured for ligatures and custom fonts")*

### 🍎 Sketchybar
A highly customizable macOS status bar replacement.
*(You can add details here like: "Minimalist design with battery and workspace indicators")*

### 🌐 Clash
Proxy client configuration for network management.

### 🔭 Raycast
Extensions and settings to boost productivity on macOS.

### ✨ Starship
A minimal, blazing-fast, and infinitely customizable prompt for any shell.

## 🚀 Installation / Usage

To use these configurations, clone the repository and symlink the files to your home directory.

```bash
# Clone the repository
git clone https://github.com/MrKeanu-V/dotconfig_for_mac.git ~/dotfiles

# Example: Symlink Yazi config
ln -sf ~/dotfiles/yazi ~/.config/yazi

# Example: Symlink Starship config
ln -sf ~/dotfiles/starship.toml ~/.config/starship.toml
```

> **⚠️ Note:** Please review the configurations before applying them, as some paths or keybindings might be specific to my local setup.

## 📄 License

This project is licensed under the [LICENSE](LICENSE).

