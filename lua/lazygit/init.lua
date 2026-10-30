local config = require("lazygit.config")
local env = require("lazygit.env")
local theme = require("lazygit.theme")

---@class lazygit.Api
---@overload fun(opts?: lazygit.Config): terminal?
---@type lazygit.Api
---@diagnostic disable-next-line: missing-fields
local M = setmetatable({}, {
	__call = function(t, ...)
		return t.open(...)
	end,
})

M.meta = {
	desc = "Open LazyGit in a float, auto-configure colorscheme and integration with Neovim",
}

local dirty = true

vim.api.nvim_create_autocmd({ "ColorScheme", "User" }, {
	pattern = { "*", "ThemeApply" },
	callback = function()
		dirty = true
	end,
})

---@param opts? lazygit.Config
---@return lazygit.Api
function M.setup(opts)
	config.setup(opts)
	return M
end

---@param opts lazygit.Config
local function update(opts)
	theme.write(opts)
	dirty = false
end

---@param opts? lazygit.Config
---@return terminal?
function M.open(opts)
	local resolved = config.resolve(opts)
	local args = vim.deepcopy(resolved.args or {})
	local cmd = { "lazygit" }
	vim.list_extend(cmd, args)

	if resolved.configure then
		if dirty then
			update(resolved)
		end
		env.setup(resolved)
	end
	return require("terminal").open(cmd, resolved)
end

---@param opts? lazygit.Config
---@return terminal?
function M.log(opts)
	local resolved = vim.deepcopy(opts or {})
	resolved.args = resolved.args or { "log" }
	return M.open(resolved)
end

---@param opts? lazygit.Config
---@return terminal?
function M.log_file(opts)
	local file = vim.trim(vim.api.nvim_buf_get_name(0))
	local resolved = vim.deepcopy(opts or {})
	resolved.args = vim.list_extend(resolved.args or {}, { "-f", file })
	resolved.cwd = vim.fn.fnamemodify(file, ":h")
	return M.open(resolved)
end

return M
