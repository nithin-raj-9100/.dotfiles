-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<C-h>", ":<C-U>TmuxNavigateLeft<CR>", opts)
vim.keymap.set("n", "<C-j>", ":<C-U>TmuxNavigateDown<CR>", opts)
vim.keymap.set("n", "<C-k>", ":<C-U>TmuxNavigateUp<CR>", opts)
vim.keymap.set("n", "<C-l>", ":<C-U>TmuxNavigateRight<CR>", opts)
vim.keymap.set("t", "<C-h>", [[<C-\><C-n>:TmuxNavigateLeft<CR>]], opts)
vim.keymap.set("t", "<C-j>", [[<C-\><C-n>:TmuxNavigateDown<CR>]], opts)
vim.keymap.set("t", "<C-k>", [[<C-\><C-n>:TmuxNavigateUp<CR>]], opts)
vim.keymap.set("t", "<C-l>", [[<C-\><C-n>:TmuxNavigateRight<CR>]], opts)

vim.keymap.set("n", "<S-]>", "zz", opts)
vim.keymap.set("n", "<S-[>", "zz", opts)
