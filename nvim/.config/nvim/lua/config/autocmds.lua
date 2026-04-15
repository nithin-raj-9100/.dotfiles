-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("BufReadCmd", {
  desc = "Open raster image files in macOS Preview",
  pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.bmp", "*.ico", "*.avif" },
  callback = function(ev)
    local file = vim.fn.expand("<amatch>")
    vim.fn.jobstart({ "open", "-a", "Preview", file }, { detach = true })
    vim.defer_fn(function()
      vim.api.nvim_buf_delete(ev.buf, { force = true })
    end, 100)
  end,
})

vim.api.nvim_create_autocmd("BufReadCmd", {
  desc = "Open SVG files in default browser",
  pattern = { "*.svg" },
  callback = function(ev)
    local file = vim.fn.expand("<amatch>")
    vim.fn.jobstart({ "open", "-a", "Google Chrome", file }, { detach = true })
    vim.defer_fn(function()
      vim.api.nvim_buf_delete(ev.buf, { force = true })
    end, 100)
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({
      timeout = 30,
    })
  end,
})
