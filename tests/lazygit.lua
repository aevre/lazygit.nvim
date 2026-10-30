vim.opt.runtimepath:prepend(vim.fn.getcwd())
vim.opt.runtimepath:prepend(vim.fn.getcwd() .. "/../terminal.nvim")
vim.opt.runtimepath:prepend(vim.fn.getcwd() .. "/../win.nvim")

local terminal = require("terminal")
local original_open = terminal.open
local calls = {}
---@diagnostic disable-next-line: duplicate-set-field
terminal.open = function(cmd, opts)
	calls[#calls + 1] = { cmd = cmd, opts = opts }
	return { cmd = cmd, opts = opts }
end

local lazygit = require("lazygit")
local theme = require("lazygit.theme")
local cache = vim.fn.tempname()

local ok, err = pcall(function()
	local color = theme.resolve_color({ fg = "ErrorMsg", bold = true })
	assert(color[1]:match("^#%x%x%x%x%x%x$"))
	assert(color[2] == "bold")

	local theme_path = cache .. ".yml"
	lazygit.setup({ configure = false, theme_path = theme_path })
	lazygit.open({ args = { "--debug" } })
	assert(#calls == 1)
	assert(vim.deep_equal(calls[1].cmd, { "lazygit", "--debug" }))

	lazygit.log({ configure = false })
	assert(vim.deep_equal(calls[2].cmd, { "lazygit", "log" }))

	local file = vim.fn.tempname()
	vim.fn.writefile({ "line" }, file)
	vim.cmd.edit(file)
	lazygit.log_file({ configure = false })
	assert(vim.deep_equal(calls[3].cmd, { "lazygit", "-f", file }))
	assert(calls[3].opts.cwd == vim.fn.fnamemodify(file, ":h"))

	local values = vim.tbl_deep_extend("force", { gui = { theme = {} } }, { gui = { nerdFontsVersion = "3" } })
	assert(values.gui.theme ~= nil)
end)

terminal.open = original_open
assert(ok, err)
vim.cmd("qa!")
