if vim.g.loaded_lazygit_nvim then
	return
end
vim.g.loaded_lazygit_nvim = true

require("lazygit").setup()
