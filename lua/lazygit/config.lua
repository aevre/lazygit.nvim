---@class lazygit.Configuration
local M = {}

---@type lazygit.Config
local defaults = {
	configure = true,
	config = {
		os = { editPreset = "nvim-remote" },
		gui = { nerdFontsVersion = "3" },
	},
	theme_path = vim.fs.normalize(vim.fn.stdpath("cache") .. "/lazygit-theme.yml"),
	theme = {
		[241] = { fg = "Special" },
		activeBorderColor = { fg = "MatchParen", bold = true },
		cherryPickedCommitBgColor = { fg = "Identifier" },
		cherryPickedCommitFgColor = { fg = "Function" },
		defaultFgColor = { fg = "Normal" },
		inactiveBorderColor = { fg = "FloatBorder" },
		optionsTextColor = { fg = "Function" },
		searchingActiveBorderColor = { fg = "MatchParen", bold = true },
		selectedLineBgColor = { bg = "Visual" },
		unstagedChangesColor = { fg = "DiagnosticError" },
	},
	win = {},
}

---@type lazygit.Config
local config = {}

---@param opts? lazygit.Config
---@return lazygit.Config
function M.resolve(opts)
	local resolved =
		vim.tbl_deep_extend("force", vim.deepcopy(defaults), vim.deepcopy(config), vim.deepcopy(opts or {}))
	---@cast resolved lazygit.Config
	return resolved
end

---@param opts? lazygit.Config
function M.setup(opts)
	config = vim.tbl_deep_extend("force", config, vim.deepcopy(opts or {}))
end

return M
