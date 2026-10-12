-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Undo、Redo 普通模式下的映射
vim.keymap.set("n", "<C-Z>", "u", { desc = "Undo" })
vim.keymap.set("n", "<C-S-Z>", "<C-R>", { desc = "Redo" })

-- Undo、Redo 插入模式下的映射
vim.keymap.set("i", "<C-Z>", "<C-O>u", { desc = "Undo" })
vim.keymap.set("i", "<C-S-Z>", "<C-O><C-R>", { desc = "Redo" })
