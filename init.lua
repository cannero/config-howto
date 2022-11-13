local opt = vim.opt

opt.mouse = "a"
-- todo check with unnamed,unnamedplus .. opt.clipboard
-- https://stackoverflow.com/questions/30691466/what-is-difference-between-vims-clipboard-unnamed-and-unnamedplus-settings
opt.clipboard = opt.clipboard + {"unnamedplus"}
opt.autochdir = true
opt.expandtab = true
opt.hidden = true
opt.title = true
opt.ignorecase = true
opt.softtabstop = -1
opt.shiftwidth = 2

local function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

map('n', 'k', 'gk')
map('n', 'j', 'gj')

vim.api.nvim_set_var('airline#extensions#tabline#enabled', 1)
vim.api.nvim_set_var('airline#extensions#tabline#buffer_nr_show', 1)

require'nvim-treesitter.configs'.setup {
  ensure_installed = {"elixir", "heex", "eex"}, -- only install parsers for elixir and heex
  -- ensure_installed = "all", -- install parsers for all supported languages
  sync_install = false,
  ignore_install = { },
  highlight = {
    enable = true,
    disable = { },
  },
}

local elixir = require("elixir")
elixir.setup({
  nolangserver = true,
  settings = elixir.settings({
    dialyzerEnabled = true,
    fetchDeps = false,
    enableTestLenses = false,
    suggestSpecs = false,
  })
})
