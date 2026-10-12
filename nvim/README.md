# 💤 Neovim config

Personal Neovim configuration, based on the [LazyVim](https://github.com/LazyVim/LazyVim)
starter template ([LazyVim/starter](https://github.com/LazyVim/starter)).
Refer to the [LazyVim documentation](https://lazyvim.github.io/installation) for the
framework itself.

## Local changes vs. the starter template

`lua/config/keymaps.lua` is the only file modified: it adds Ctrl-Z / Ctrl-Shift-Z
undo and redo.

| Mode   | Keymap    | Action              |
| ------ | --------- | ------------------- |
| Normal | `<C-z>`   | Undo (`u`)          |
| Normal | `<C-S-z>` | Redo (`<C-r>`)      |
| Insert | `<C-z>`   | Undo (`<C-o>u`)     |
| Insert | `<C-S-z>` | Redo (`<C-o><C-r>`) |

Two generated files are versioned here although the starter template does not
track them, so a fresh machine can restore the exact plugin versions:

- `lazy-lock.json` - pinned plugin commits, restore with `:Lazy restore`
- `lazyvim.json` - LazyVim install state (no extras enabled)

Everything else, including `lua/plugins/example.lua`, is unchanged from the template.

## Install

    git clone <this dotfiles repo> ~/.config   # nvim/ lands at ~/.config/nvim
    nvim                                       # plugins install on first launch

## License

Apache-2.0, inherited from LazyVim (see `LICENSE`).
